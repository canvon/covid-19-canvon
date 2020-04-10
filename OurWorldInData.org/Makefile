all:
	@echo "Available targets are (at least): timestamp update plot-examples"


include ../common/include/config.mk


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

export SLIDE_TEMPLATE := ../common/include/slide-templated.html.tt2
export SLIDE_TEMPLATE_CALLSITE_HEAD := examples/slide-templated-callsite-head.txt
export SLIDE_TEMPLATE_CALLSITE_TAIL := examples/slide-templated-callsite-tail.txt

GNUPLOT_INCS = $(sort $(wildcard include/*.gnuplot ../common/include/*.gnuplot))
GNUPLOT_SRCS = $(sort $(wildcard examples/*.gnuplot))
GNUPLOT_PNGS = $(GNUPLOT_SRCS:.gnuplot=.png)

plot-examples: full_data_for_gnuplot.csv full_data.csv $(SLIDE_TEMPLATE) $(SLIDE_TEMPLATE_CALLSITE_HEAD) $(SLIDE_TEMPLATE_CALLSITE_TAIL)
	# Uses TIMESTAMP, SLIDE_*, C19C_GNUPLOT_TERMINAL.
	../common/plot_examples.sh owid "$<" $(GNUPLOT_SRCS)

clean-examples-inplace:
	-rm -f $(GNUPLOT_PNGS)

plot-examples-inplace: $(GNUPLOT_PNGS)

examples/%.png: examples/%.gnuplot $(GNUPLOT_INCS) full_data_for_gnuplot.csv full_data.csv
	gnuplot -e "call '../common/include/terminal.gnuplot' '$(C19C_GNUPLOT_TERMINAL)' '$@'" "$<"
