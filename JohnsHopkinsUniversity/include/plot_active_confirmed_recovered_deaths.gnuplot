if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

if (!(ARGC == 1)) { exit error "Usage: call '...' Location" }
Location = ARG1

TitlePrefix = "Active/confirmed/recovered/deaths: "
TitleBase = Location
set ylabel "Total affected [people]"
call '../common/include/title.gnuplot'
call '../common/include/hook.gnuplot' 'run' 'PreplotHook'
plot DataFile using (TC(1)):(SelectLocation(Location, column("totalConfirmed") - column("totalDeaths") - column("totalRecovered"))) title "active cases" with lines, \
	'' using (TC(1)):(SelectLocation(Location, column("totalConfirmed"))) title "total confirmed" with lines, \
	'' using (TC(1)):(SelectLocation(Location, column("totalRecovered"))) title "total recovered" with lines, \
	'' using (TC(1)):(SelectLocation(Location, column("totalDeaths"))) title "total deaths" with lines
