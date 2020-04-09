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


.PHONY: plot-examples clean-examples-inplace plot-examples-inplace

export SLIDE_TEMPLATE := examples/slide-templated.html.tt2
export SLIDE_TEMPLATE_CALLSITE_HEAD := examples/slide-templated-callsite-head.txt
export SLIDE_TEMPLATE_CALLSITE_TAIL := examples/slide-templated-callsite-tail.txt

GNUPLOT_INCS = $(sort $(wildcard examples/*.gnuplot.inc.txt ../include/*.gnuplot.inc.txt))
GNUPLOT_SRCS = $(sort $(wildcard examples/*.gnuplot.txt))
GNUPLOT_PNGS = $(GNUPLOT_SRCS:.gnuplot.txt=.png)

plot-examples: full_data_for_gnuplot.csv $(SLIDE_TEMPLATE) $(SLIDE_TEMPLATE_CALLSITE_HEAD) $(SLIDE_TEMPLATE_CALLSITE_TAIL)
	# Uses TIMESTAMP, SLIDE_*.
	../include/plot_examples.sh jhu "$<" $(GNUPLOT_SRCS)

clean-examples-inplace:
	-rm -f $(GNUPLOT_PNGS)

plot-examples-inplace: $(GNUPLOT_PNGS)

examples/%.png: examples/%.gnuplot.txt $(GNUPLOT_INCS) full_data_for_gnuplot.csv
	gnuplot -c "$<" png "$@"

examples/slide-templated-demo.html: examples/slide-templated-demo.html.tt2 $(SLIDE_TEMPLATE)
	# Perl Template::Toolkit (TT2)
	@#tpage $+ >"$@"
	tpage "$<" >"$@"
