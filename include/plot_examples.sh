#!/bin/bash

set -eu

warn() {
  echo "${0##*/}: $*" >&2
}

die() {
  warn "Fatal: $*"
  exit 1
}

usage() {
  die "Usage: TIMESTAMP=... SLIDE_...=... $0 INFIX CSV SRCS"
}

[ "$#" -ge 3 ] || usage

[ -n "$TIMESTAMP" ] || usage
[ -n "${SLIDE_TEMPLATE}" ] || usage
[ -n "${SLIDE_TEMPLATE_CALLSITE_HEAD}" ] || usage
[ -n "${SLIDE_TEMPLATE_CALLSITE_TAIL}" ] || usage

INFIX="$1"; shift
CSV="$1"; shift

[ -f "$CSV" ] || die "Plot data CSV \"$CSV\" not found"

SOURCEDATA_TIMESTAMP=$(
    TZ=UTC date --date=@"$(grep World full_data_for_gnuplot.csv | tail -1 | cut -d, -f1)" '+%Y%m%d'
  ) || die "Failed to determine source data timestamp"

TARGET_BASEDIR="archive/plots"
TARGET_DIR="${TARGET_BASEDIR}/$TIMESTAMP"
TARGET_PREFIX="covid19-${INFIX}-${SOURCEDATA_TIMESTAMP}-"
TARGET_SUFFIX=".png"
TARGET_SLIDE="${TARGET_DIR}/slide.html"
TARGET_SLIDE_TT2="${TARGET_SLIDE}.tt2"

if ! [ -d "$TARGET_BASEDIR" ]
then
  mkdir -pv "$TARGET_BASEDIR" || die "Can't create target base directory \"$TARGET_BASEDIR\""
fi

# It is an error if target directory already existed...
[ -d "$TARGET_DIR" ] && die "Target directory \"$TARGET_DIR\" already existed!"
mkdir -v "$TARGET_DIR" || die "Can't create target directory \"$TARGET_DIR\" or already existed..."

echo

(
  cat "${SLIDE_TEMPLATE_CALLSITE_HEAD}"
  echo "  data_date = '${SOURCEDATA_TIMESTAMP}'"
  echo "  plot_run = '$TIMESTAMP'"
  echo "  plot_prefix = '${TARGET_PREFIX}'"
  echo "  plot_suffix = '${TARGET_SUFFIX}'"
  echo "  plot_basenames = [" \
) >"${TARGET_SLIDE_TT2}" || die "Creating slide.html.tt2 failed"

for I in "$@"
do
  echo "Plotting $I ..."
  TARGET_BASENAME="$(basename "$I" .gnuplot.txt)" || die "Extracting basename failed with exit code $?"
  gnuplot -c "$I" png "${TARGET_DIR}/${TARGET_PREFIX}${TARGET_BASENAME}${TARGET_SUFFIX}" || die "gnuplot failed with exit code $?"
  echo "    '${TARGET_BASENAME}'," >>"${TARGET_SLIDE_TT2}" || die "Appending gnuplot result image to slide.html.tt2 failed"
done

(
  echo "  ]"
  cat "${SLIDE_TEMPLATE_CALLSITE_TAIL}"
) >>"${TARGET_SLIDE_TT2}" || die "Finishing slide.html.tt2 failed"

echo
if ! which tpage &>/dev/null
then
  warn "Can't generate slide HTML: Perl Template::Toolkit (TT2)'s command tpage not found"
else
  echo "Generating slide HTML..."
  tpage "${TARGET_SLIDE_TT2}" >"${TARGET_SLIDE}" || die "Generating slide HTML \"${TARGET_SLIDE}\" from template \"${TARGET_SLIDE_TT2}\" failed"
fi

# Success.
exit 0
