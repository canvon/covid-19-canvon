export TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

all:
	@echo "Available targets are (at least): timestamp update"

timestamp:
	@echo "$(TIMESTAMP)"

# (Always try to download again if requested.)
.PHONY: update download-full_data.csv

update: download-full_data.csv full_data_for_gnuplot.csv

download-full_data.csv:
	./download.sh "$(subst download-,,$@)"

full_data_for_gnuplot.csv: full_data.csv
	./convert_full_data.pl <"$<" >"$@"
	mkdir -pv "archive/generated_data"
	cp -avi "$@" "archive/generated_data/$(basename $@)-$(TIMESTAMP)$(suffix $@)"
