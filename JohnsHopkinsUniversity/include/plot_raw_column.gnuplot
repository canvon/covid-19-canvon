# Based on: ../OurWorldInData.org/examples/3.1-total_confirmed_cases_in_logarithmic_scale.gnuplot.txt

if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

if (!(ARGC == 1)) { exit error "Usage: call '...' ColumnSpec" }

# Let the World curve be dashed, so it will differ from United States
# (or whatever duplicates arise from having more than 8 curves on the plot).
DashtypeFromLocation(s) = s eq "World" ? 2 : 1

#set title ARG2
call '../common/include/title.gnuplot'
call '../common/include/hook.gnuplot' 'run' 'PreplotHook'
plot for [Location in WorldLocations] DataFile using (TC(1)):(SelectLocation(Location, @ARG1)) title Location with lines dashtype DashtypeFromLocation(Location)
