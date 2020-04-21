if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

if (!(ARGC == 1)) { exit error "Usage: call '...' Location" }
Location = ARG1

WrapLoc(Macro) = sprintf("SelectLocation(Location, %s)", Macro)
ActiveCasesMacro    = WrapLoc('column("totalConfirmed") - column("totalDeaths") - column("totalRecovered")')
TotalConfirmedMacro = WrapLoc('column("totalConfirmed")')
TotalRecoveredMacro = WrapLoc('column("totalRecovered")')
TotalDeathsMacro    = WrapLoc('column("totalDeaths")')

TitlePrefix = "Active/confirmed/recovered/deaths: "
TitleBase = Location
set ylabel "Total affected [people]"
call '../common/include/title.gnuplot'
call '../common/include/hook.gnuplot' 'run' 'PreplotHook'
plot DataFile using (TC(1)):(@ActiveCasesMacro) title "active cases" with lines, \
	'' using (TC(1)):(@TotalConfirmedMacro) title "total confirmed" with lines, \
	'' using (TC(1)):(@TotalRecoveredMacro) title "total recovered" with lines, \
	'' using (TC(1)):(@TotalDeathsMacro) title "total deaths" with lines
