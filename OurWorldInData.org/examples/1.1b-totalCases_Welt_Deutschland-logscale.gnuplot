if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Gesamtzahl Fälle: Welt gegenüber Deutschland (logarithmische Skala)"
}

set logscale y
call "examples/1.1-totalCases_Welt_Deutschland.gnuplot" ARG1 ARG2 ARG3 ARG4 ARG5 ARG6 ARG7 ARG8 ARG9
