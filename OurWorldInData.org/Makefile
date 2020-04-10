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


.PHONY: plot-examples clean-examples-inplace plot-examples-inplace

export SLIDE_TEMPLATE := ../include/slide-templated.html.tt2
export SLIDE_TEMPLATE_CALLSITE_HEAD := examples/slide-templated-callsite-head.txt
export SLIDE_TEMPLATE_CALLSITE_TAIL := examples/slide-templated-callsite-tail.txt

GNUPLOT_INCS = $(sort $(wildcard examples/*.gnuplot.inc.txt ../include/*.gnuplot.inc.txt))
GNUPLOT_SRCS = $(sort $(wildcard examples/*.gnuplot.txt))
GNUPLOT_PNGS = $(GNUPLOT_SRCS:.gnuplot.txt=.png)

plot-examples: full_data_for_gnuplot.csv full_data.csv $(SLIDE_TEMPLATE) $(SLIDE_TEMPLATE_CALLSITE_HEAD) $(SLIDE_TEMPLATE_CALLSITE_TAIL)
	# Uses TIMESTAMP, SLIDE_*.
	../include/plot_examples.sh owid "$<" $(GNUPLOT_SRCS)

clean-examples-inplace:
	-rm -f $(GNUPLOT_PNGS)

plot-examples-inplace: $(GNUPLOT_PNGS)

examples/%.png: examples/%.gnuplot.txt $(GNUPLOT_INCS) full_data_for_gnuplot.csv full_data.csv
	gnuplot -e "call '../include/terminal.gnuplot' 'png' '$@'" "$<"
