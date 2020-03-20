export TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

all:
	@echo "Available targets are (at least): timestamp update plot-examples"


.PHONY: timestamp

timestamp:
	@echo "$(TIMESTAMP)"


# (Always try to download again if requested.)
.PHONY: update download-full_data.csv

update: download-full_data.csv full_data_for_gnuplot.csv

download-full_data.csv:
	./download.sh "$(subst download-,,$@)"

full_data_for_gnuplot.csv: full_data.csv convert_full_data.pl
	./convert_full_data.pl <"$<" >"$@"
	mkdir -pv "archive/generated_data"
	cp -avi "$@" "archive/generated_data/$(basename $@)-$(TIMESTAMP)$(suffix $@)"


.PHONY: plot-examples

plot-examples: full_data.csv full_data_for_gnuplot.csv
	mkdir -pv "archive/plots"
	mkdir -v "archive/plots/$(TIMESTAMP)"  # It is an error if directory already existed...
	@SOURCEDATA_TIMESTAMP=$$(date --date=$$(grep World full_data.csv | tail -1 | cut -d, -f1) '+%Y%m%d') && \
	  for I in examples/[1-9]*.gnuplot.txt; do \
	    echo "Plotting $$I ..."; \
	    gnuplot -c "$$I" png "archive/plots/$(TIMESTAMP)/covid19-owid-$${SOURCEDATA_TIMESTAMP}-$$(basename "$$I" .gnuplot.txt).png" || exit; \
	  done
