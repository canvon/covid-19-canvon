#!/bin/bash

warn() {
	echo "${0##*/}: $*" >&2
}

die() {
	warn "Fatal: $*"
	exit 1
}


[ "$#" -eq 1 ] || die "Usage: $0 DEST_FILENAME"

DEST_FILENAME="$1"
DEST_BASENAME="${1%.*}"
DEST_EXTENSION="${1##*.}"
URL_FILENAME="${DEST_FILENAME}.url.txt"
TMPOUT_FILENAME="${DEST_FILENAME}.new.tmp"
CHECKSUM_FILENAME="${DEST_FILENAME}.new.sha256.tmp"

ARCHIVE_DIR="archive/source_data"

[ -f "$URL_FILENAME" ] || die "Error: URL file \"$URL_FILENAME\" missing!"

[ -n "$TIMESTAMP" ] || die "Error: Time-stamp from make is missing."


rm -f "$CHECKSUM_FILENAME" || true
if [ -e "$DEST_FILENAME" ]
then
	sha256sum "$DEST_FILENAME" | sed -e 's#$#.new.tmp#' >"$CHECKSUM_FILENAME"
fi


echo
echo "Downloading file \"$DEST_FILENAME\" via URL file \"$URL_FILENAME\"..."
echo

wget -O "$TMPOUT_FILENAME" -i "$URL_FILENAME" || die "Downloading file \"$DEST_FILENAME\" via URL file \"$URL_FILENAME\" failed."


if ! [ -e "$CHECKSUM_FILENAME" ] || ! sha256sum -c "$CHECKSUM_FILENAME"
then
	touch -c "$TMPOUT_FILENAME" || die "Updating downloaded file \"$TMPOUT_FILENAME\"'s timestamp failed."

	mkdir -pv "$ARCHIVE_DIR" || die "Creating archive directory \"$ARCHIVE_DIR\" failed."

	cp -avi "$TMPOUT_FILENAME" "$ARCHIVE_DIR/${DEST_BASENAME}-${TIMESTAMP}.${DEST_EXTENSION}" || die "Copying downloaded file \"$TMPOUT_FILENAME\" to archive directory \"$ARCHIVE_DIR\" failed."

	mv -v "$TMPOUT_FILENAME" "$DEST_FILENAME" || die "Moving downloaded file to destination \"$DEST_FILENAME\" failed."
else
	rm -fv "$TMPOUT_FILENAME" || true
fi

rm -f "$CHECKSUM_FILENAME" || true

exit 0
