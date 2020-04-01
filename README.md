# covid-19-canvon

Make plots from publically available data
about covid-19 (Corona Virus Disease started 2019).

*Makefile/Perl/gnuplot* *CSV-to-PNG* solution by *Fabian "canvon" Pietsch*.
Also builds `slide.html` files (via Perl `Template::Toolkit` "*TT2*")
which are HTML/CSS/JavaScript using the Bootstrap & jQuery libraries.

`git clone` from <https://github.com/canvon/covid-19-canvon>,
then fill with data & plots via `make` invocations,
see [below (overview)](#overview).

Plot runs are sometimes uploaded to some sub-directory of
<https://files.canvon.de/covid-19-canvon/plots/>; there,
the `slide.html` (mentioned above) can be browsed/linked
for easy swiping through all slides (of a plot run) --
especially on smartphone/touch devices like Android --, e.g.,
[JHU 20200331 plotted 20200401\_021214](https://files.canvon.de/covid-19-canvon/plots/jhu/20200401_021214/slide.html).


## Overview

To get data for a data source `Foo` and make some plots,
do the following (on a *Linux* machine, e.g., *Debian 9*,
with *GNU Make*, *Perl* (+ `Template::Toolkit` "*TT2*") &
*gnuplot* installed):

(For valid values of `Foo`,
see [Supported data sources](#supported-data-sources).)

    covid-19-canvon$ cd Foo
    covid-19-canvon/Foo$ make update
    [...]
    covid-19-canvon/Foo$ make update  # A second time if it failed expectedly.
    [...]
    covid-19-canvon/Foo$ make plot-examples
    [...]

This should [get the source data](#get-source-data)
and [make some plots](#make-plots). See the in-terminal output
for where things will have been created, or follow the previous
sentence's links for details.


## Get source data

As mentioned [above (overview)](#overview), choose
a [supported data source](#supported-data-sources),
enter its sub-directory and run `make update` (possibly two times).
This should download the source `.csv` file, or clone the
*git* repository containing the source data files with history,
as appropriate.

You would also run `make update` again every day (or so), to update to
the newest data.

**In the data source's sub-directory**, you should then have data to plot,
usually converted to a file `full_data_for_gnuplot.csv`; every such
generated file will also be held as a copy in `archive/generated_data/`
(including a time stamp, e.g., `full_data_for_gnuplot-20200331_135019.csv`
for a file generated 31st March, 2020, at 13:50:19 (PM)).

The original source data will also be archived,
either in `archive/source_data/` or as part of a (e.g., git) repository
cloned to get the source data (so it'll already track its own history).


## Make plots

You could do your own plotting, now, using the CSV (Comma-Separated Values)
file(s) from a data source, or the pre-processed CSV for use with *gnuplot*.
There are ready-made gnuplot scripts, though, with a build system integration,
in a data source's sub-directory's `examples/` sub-directory. They are supposed
to be gnuplot-`load`ed or `call`ed from the `Makefile` directory.

As mentioned [above (overview)](#overview), choose
a [supported data source](#supported-data-sources),
enter its sub-directory and run: `make plot-examples`
This should plot the previously prepared data
from `full_data_for_gnuplot.csv` into several output files,
in a per-plot-run archive sub-directory.

**In the data source's sub-directory**, you should then have
the plot run's output `.png` image and `slide.html` web page
files in `archive/plots/YYYYMMDD_HHMMSS/`,
e.g., `JohnsHopkinsUniversity/archive/plots/20200331_135027/`,
ready-to-upload as a bulk directory to your own web-space
(or for simple local browsing).


## Supported data sources

* [Johns Hopkins University](JohnsHopkinsUniversity/README.md)
* [OurWorldInData.org](OurWorldInData.org/README.md)


