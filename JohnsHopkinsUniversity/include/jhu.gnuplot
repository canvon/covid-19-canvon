# jhu.gnuplot - This gnuplot include file is used for
# JohnsHopkinsUniversity data source specific settings.

# Avoid duplicating what this file set up.
JHULoaded = 1

DataFile = 'full_data_for_gnuplot.csv'

# Place credit on the bottom of the graph.
set bmargin 5
set label 1 "Plot based on public data from JHU (Johns Hopkins University, USA).\nThe data was collected from their GitHub repository at: https://github.com/CSSEGISandData/COVID-19" at character 1,2

# Place "Data current as of:" box at the lower-right hand corner of the screen.
call '../common/include/data_current.gnuplot' 2 "World" 'column("totalConfirmed")'