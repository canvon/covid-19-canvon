export TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

all:
	@echo "Available targets are (at least): timestamp update plot-examples"


.PHONY: timestamp

timestamp:
	@echo "$(TIMESTAMP)"


# (Always try to download again if requested.)
.PHONY: update git-clone git-pull

update: git-pull full_data_for_gnuplot.csv

git-clone COVID-19:
	git clone $$(cat COVID-19.git_clone_url.txt)

git-pull: COVID-19
	cd COVID-19 && git pull --ff-only

DAILY_REPORT_DIR = COVID-19/csse_covid_19_data/csse_covid_19_daily_reports
DAILY_REPORT_FILES = $(wildcard $(DAILY_REPORT_DIR)/*.csv)

time_series_covid19_generated_recovered_global.csv: $(DAILY_REPORT_FILES) generate_time_series.pl
	TZ=UTC ./generate_time_series.pl "$(DAILY_REPORT_DIR)" >"$@"
	mkdir -pv "archive/generated_data"
	cp -avi "$@" "archive/generated_data/$(basename $@)-$(TIMESTAMP)$(suffix $@)"

# (As of 2020-03-25/-26, JHU is seemingly providing a "recovered" time series
# again, but it does not seem to be updated with the other files... Keep
# generating our own, instead, at least for now! => Filter it out.)
TIMESERIES_FILES = $(filter-out %/time_series_covid19_recovered_global.csv,$(wildcard COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_*_global.csv)) time_series_covid19_generated_recovered_global.csv

full_data_for_gnuplot.csv: $(TIMESERIES_FILES) convert_time_series.pl
	./convert_time_series.pl $(TIMESERIES_FILES) >"$@"
	mkdir -pv "archive/generated_data"
	cp -avi "$@" "archive/generated_data/$(basename $@)-$(TIMESTAMP)$(suffix $@)"


.PHONY: plot-examples

SLIDE_TEMPLATE = examples/slide-templated.html.tt2
SLIDE_TEMPLATE_CALLSITE_HEAD = examples/slide-templated-callsite-head.txt
SLIDE_TEMPLATE_CALLSITE_TAIL = examples/slide-templated-callsite-tail.txt

plot-examples: full_data_for_gnuplot.csv $(SLIDE_TEMPLATE) $(SLIDE_TEMPLATE_CALLSITE_HEAD) $(SLIDE_TEMPLATE_CALLSITE_TAIL)
	mkdir -pv "archive/plots"
	mkdir -v "archive/plots/$(TIMESTAMP)"  # It is an error if directory already existed...
	@echo && \
	  SOURCEDATA_TIMESTAMP=$$(TZ=UTC date --date=@$$(grep World full_data_for_gnuplot.csv | tail -1 | cut -d, -f1) '+%Y%m%d') && \
	  TARGET_DIR="archive/plots/$(TIMESTAMP)" && \
	  TARGET_PREFIX="covid19-jhu-$${SOURCEDATA_TIMESTAMP}-" && \
	  TARGET_SUFFIX=".png" && \
	  TARGET_SLIDE="$${TARGET_DIR}/slide.html" && \
	  TARGET_SLIDE_TT2="$${TARGET_SLIDE}.tt2" && \
	  ( \
	    cat "$(SLIDE_TEMPLATE_CALLSITE_HEAD)" && \
	    echo "  data_date = '$${SOURCEDATA_TIMESTAMP}'" && \
	    echo "  plot_run = '$(TIMESTAMP)'" && \
	    echo "  plot_prefix = '$${TARGET_PREFIX}'" && \
	    echo "  plot_suffix = '$${TARGET_SUFFIX}'" && \
	    echo "  plot_basenames = [" \
	  ) >"$${TARGET_SLIDE_TT2}" && \
	  for I in examples/[1-9]*.gnuplot.txt; do \
	    echo "Plotting $$I ..."; \
	    TARGET_BASENAME="$$(basename "$$I" .gnuplot.txt)" && \
	    gnuplot -c "$$I" png "$${TARGET_DIR}/$${TARGET_PREFIX}$${TARGET_BASENAME}$${TARGET_SUFFIX}" || exit; \
	    echo "    '$${TARGET_BASENAME}'," >>"$${TARGET_SLIDE_TT2}"; \
	  done && \
	  ( \
	    echo "  ]" && \
	    cat "$(SLIDE_TEMPLATE_CALLSITE_TAIL)" \
	  ) >>"$${TARGET_SLIDE_TT2}" && \
	  echo && \
	  if ! which tpage >/dev/null; then \
	    echo "Can't generate slide HTML: Perl Template::Toolkit (TT2)'s command tpage not found" >&2; \
	  else \
	    echo "Generating slide HTML..." && \
	    tpage "$${TARGET_SLIDE_TT2}" >"$${TARGET_SLIDE}" || exit; \
	  fi

GNUPLOT_INCS = $(wildcard examples/*.gnuplot.inc.txt ../include/*.gnuplot.inc.txt)
GNUPLOT_SRCS = $(wildcard examples/*.gnuplot.txt)
GNUPLOT_PNGS = $(GNUPLOT_SRCS:.gnuplot.txt=.png)

plot-examples-inplace: $(GNUPLOT_PNGS)

examples/%.png: examples/%.gnuplot.txt $(GNUPLOT_INCS) full_data_for_gnuplot.csv
	gnuplot -c "$<" png "$@"

examples/slide-templated-demo.html: examples/slide-templated-demo.html.tt2 $(SLIDE_TEMPLATE)
	# Perl Template::Toolkit (TT2)
	@#tpage $+ >"$@"
	tpage "$<" >"$@"
