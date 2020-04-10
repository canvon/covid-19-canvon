if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Bestätigte gegenüber neuen Fällen Deutschland (Zoom)"
}

set xrange ["2020-02-27":*]
call "examples/2.1-bestaetigte_Faelle_neue_bestaetigte_Faelle_Deutschland.gnuplot" ARG1 ARG2 ARG3 ARG4 ARG5 ARG6 ARG7 ARG8 ARG9
