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

# Ensure we'll always have one-week between xtics, and 7 days of mxtics.
#
# Sadly I don't know how to *generally* set Monday as the start of a week.
# I could pick a specific date, but then dates before that date will be missing.
# I could pick the first Monday after the epoch (1970-01-01 00:00:00 UTC),
# but won't that possibly take much time to compute/process? But maybe I should
# do that. For now I'll live with auto-chosen day of week, though, although
# it's bad that it's, e.g., Wednesday/Thursday, and I don't know how gnuplot
# makes that decision and whether I could simply guide it to choose Monday
# instead.
#
set xtics 7*24*60*60
set mxtics 7

# Have a grid. Default + one line for every day. Should help enormously
# reading data points out of the plots; but will make them a little harder
# to look at quantitatively(?), I think... Let's do it, though.
set grid
set grid mxtics

# Switch from key at the upper-right to upper-left,
# as the plots will usually end right there. ...
set key left

# General helpers.
#
# Removes one space from the argument if there is one.
# E.g., "United States" -> "UnitedStates".
# This may be necessary when giving output variable names
# (e.g., to the "stats" command).
Unspace(s) = (pos=strstrt(s, ' ')) == 0 ? s : s[1:pos-1].s[pos+1:]

# Predefine some helper functions, to make the actual plot commands shorter.
TC(I) = timecolumn(I,"%s")
SelectLocation(Location, Value) = stringcolumn("location") eq Location ? Value : NaN

# Selection of locations to plot on world comparison charts.
WorldLocations = "World China Japan Germany Italy France Spain 'United Kingdom' 'United States' Sweden Netherlands"

# Common text of attribution.
CommonAttribution = "Generator: gnuplot via https://github.com/canvon/covid-19-canvon"
