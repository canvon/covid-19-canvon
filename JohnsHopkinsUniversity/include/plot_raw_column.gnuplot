# Based on: ../OurWorldInData.org/examples/3.1-total_confirmed_cases_in_logarithmic_scale.gnuplot.txt

if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

if (!(ARGC == 1)) { exit error "Usage: call '...' ColumnSpec" }

ColumnMacro = sprintf("SelectLocation(Location, %s)", ARG1)
do for [Location in WorldLocations] {
	call '../common/include/read_final_value.gnuplot' (WorldDateEnd) Unspace(Location).'Column' ColumnMacro
}

# Let the World curve be dashed, so it will differ from United States
# (or whatever duplicates arise from having more than 8 curves on the plot).
DashtypeFromLocation(s) = (s eq "World" || s eq "China" || s eq "Japan") ? 2 : 1

#set title ARG2
call '../common/include/title.gnuplot'
call '../common/include/hook.gnuplot' 'run' 'PreplotHook'
plot for [Location in WorldLocations] DataFile using (TC(1)):(@ColumnMacro) title Location.value(Unspace(Location).'ColumnAddendum') with lines dashtype DashtypeFromLocation(Location)
