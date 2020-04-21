# jhu.gnuplot - This gnuplot include file is used for
# JohnsHopkinsUniversity data source specific settings.

# Avoid duplicating what this file set up.
JHULoaded = 1

DataFile = 'full_data_for_gnuplot.csv'

# Place credit on the bottom of the graph.
set bmargin 6
set label 100 CommonAttribution at character 1,3.5
set label 101 "Plot based on public data from JHU (Johns Hopkins University, USA).\nThe data was collected from their GitHub repository at: https://github.com/CSSEGISandData/COVID-19" at character 1,2

# Place "Data current as of:" box at the lower-right hand corner of the screen.
call '../common/include/data_current.gnuplot' 102 "World" 'column("totalConfirmed")'
WorldDateEnd = World_max_x

# Have an x axis label, below the right end (graph 1,0) of the graph,
# then go down 2 lines to end up below the xtics labels.
#
# We could be going from screen some lines up, too:
#set label 103 "Time [days]" at screen 1,0 right offset character 0,4
set label 103 "Time [days]" at graph 1,0 right offset character 0,-2.5
