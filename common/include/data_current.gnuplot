# data_current.gnuplot - This gnuplot include file is used to
# provide a "Data current as of:" box at the lower-right hand corner of the screen.

DataCurrentUsage = "Usage: call 'data_current.gnuplot' LabelTag Location Column"

if (!(ARGC == 3)) { exit error "Number of arguments must be 3.\n".DataCurrentUsage }
if (!exists("DataFile")) { exit error "Missing DataFile in environment." }

# Compute statistics, to be able to get at higherst time stamp (for, e.g., "World").
#
# It seems my gnuplot is giving me an error when in timedata mode,
# whereas everything works as expected without. So temporarily
# disable it.
unset xdata
stats DataFile using (TC(1)):(SelectLocation(ARG2, @ARG3)) name ARG2 nooutput
set xdata time

set label @ARG1 strftime("Data current as of: %a,\n%Y-%m-%d %H:%M UTC", value(ARG2."_max_x")) \
	at screen 1,0 right offset character -1,2 boxed
