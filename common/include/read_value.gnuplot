# read_value.gnuplot - This gnuplot include file is used to
# read single data points into variables, like population data.

ReadValueUsage = "Usage: call 'read_value.gnuplot' FileName VariablePrefix Expression"

if (!(ARGC == 3)) { exit error "Number of arguments must be 3.\n".ReadValueUsage }

unset xdata
stats ARG1 using (@ARG3) name ARG2 nooutput
set xdata time
