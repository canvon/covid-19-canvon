# Based on: ../OurWorldInData.org/examples/3.1-total_confirmed_cases_in_logarithmic_scale.gnuplot.txt

if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

if (!(ARGC == 1)) { exit error "Usage: call '...' ColumnSpec" }

#set title ARG2
call '../common/include/title.gnuplot'
call '../common/include/hook.gnuplot' 'run' 'PreplotHook'
plot for [Location in WorldLocations] DataFile using (TC(1)):(SelectLocation(Location, @ARG1)) title Location with lines
