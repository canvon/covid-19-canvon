# owid.gnuplot - This gnuplot include file is used for
# OurWorldInData.org data source specific settings.

# Avoid duplicating what this file set up.
OWIDLoaded = 1

DataFile = 'full_data_for_gnuplot.csv'

# Place credit on the bottom of the graph.
set bmargin 6
set label 100 CommonAttribution at character 1,3.5
set label 101 "Plot based on public data from ECDC (European Centre for Disease Prevention and Control).\nThe data was collected from https://ourworldindata.org/coronavirus which provided it in a more accessible way." at character 1,2

# Place "Data current as of:" box at the lower-right hand corner of the screen.
call '../common/include/data_current.gnuplot' 102 "World" 'column("totalCases")'

# Have an x axis label, below the right end (graph 1,0) of the graph,
# then go down 2 lines to end up below the xtics labels.
set label 103 "Time [days]" at graph 1,0 right offset character 0,-2.5
