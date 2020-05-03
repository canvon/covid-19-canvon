if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Confirmed cases vs change: Germany (Zoom)"
}

set xrange ["2020-02-27":*]
call "examples/2.1-confirmed_cases_vs_change_Germany.gnuplot"
