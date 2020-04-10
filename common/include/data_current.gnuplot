
#
# Provides a "Data current as of:" box at the lower-right hand corner of the screen.
#
# Usage: call "..." LabelTag Location Column
# Environment: DataFile
#

# Compute statistics, to be able to get at higherst time stamp (for, e.g., "World").
#
# It seems my gnuplot is giving me an error when in timedata mode,
# whereas everything works as expected without. So temporarily
# disable it.
unset xdata
stats DataFile using (TC(0)):(SelectLocation(ARG2, @ARG3)) name ARG2 nooutput
set xdata time

set label @ARG1 strftime("Data current as of: %a,\n%Y-%m-%d %H:%M UTC", value(ARG2."_max_x")) \
	at screen 1,0 right offset character -1,2 boxed
