if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Total confirmed cases: World vs Germany (logarithmic scale)"
}

set logscale y
call "examples/1.1-total_cases_World_Germany.gnuplot"
