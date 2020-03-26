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
DAILY_REPORT_FILES = $(wildcard "$(DAILY_REPORT_DIR)/"*.csv)

time_series_covid19_generated_recovered_global.csv: $(DAILY_REPORT_FILES) generate_time_series.pl
	TZ=UTC ./generate_time_series.pl "$(DAILY_REPORT_DIR)" >"$@"
	mkdir -pv "archive/generated_data"
	cp -avi "$@" "archive/generated_data/$(basename $@)-$(TIMESTAMP)$(suffix $@)"

TIMESERIES_FILES = $(wildcard COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_*_global.csv) time_series_covid19_generated_recovered_global.csv

full_data_for_gnuplot.csv: $(TIMESERIES_FILES) convert_time_series.pl
	./convert_time_series.pl $(TIMESERIES_FILES) >"$@"
	mkdir -pv "archive/generated_data"
	cp -avi "$@" "archive/generated_data/$(basename $@)-$(TIMESTAMP)$(suffix $@)"


.PHONY: plot-examples

plot-examples: full_data_for_gnuplot.csv
	mkdir -pv "archive/plots"
	mkdir -v "archive/plots/$(TIMESTAMP)"  # It is an error if directory already existed...
	@SOURCEDATA_TIMESTAMP=$$(TZ=UTC date --date=@$$(grep World full_data_for_gnuplot.csv | tail -1 | cut -d, -f1) '+%Y%m%d') && \
	  for I in examples/[1-9]*.gnuplot.txt; do \
	    echo "Plotting $$I ..."; \
	    gnuplot -c "$$I" png "archive/plots/$(TIMESTAMP)/covid19-jhu-$${SOURCEDATA_TIMESTAMP}-$$(basename "$$I" .gnuplot.txt).png" || exit; \
	  done
