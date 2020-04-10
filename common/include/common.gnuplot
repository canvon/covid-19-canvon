# common.gnuplot - This gnuplot include file is used for
# common settings used by the examples of all data sources.

# Avoid duplicating what this file set up.
CommonLoaded = 1

# General preparation for our data environment.
set datafile separator comma
set timefmt      "%Y-%m-%d"  # Reading, e.g., from plot range strings.
#set xtics format "%Y-%m-%d"  # Writing to output.
set xtics format "%b %d"     # "Mar 26", to save room against "2020-03-26".
                             # Besides, the 2020 is redundant, most of the time.
set xdata time

# Switch from key at the upper-right to upper-left,
# as the plots will usually end right there. ...
set key left

# Predefine some helper functions, to make the actual plot commands shorter.
TC(I) = timecolumn(I,"%s")
SelectLocation(Location, Value) = stringcolumn("location") eq Location ? Value : NaN

# Selection of locations to plot on world comparison charts.
WorldLocations = "World China Japan Germany Italy France Spain 'United Kingdom' 'United States'"
