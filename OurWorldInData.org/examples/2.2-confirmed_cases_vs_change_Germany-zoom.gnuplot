if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Confirmed cases vs change: Germany (Zoom)"
}

set xrange ["2020-02-27":*]
# (Override back from `owid.gnuplot`.)
#set xtics 7*24*60*60
#set mxtics 7
# ^ In 2020-08-23, the zoom isn't cutting off enough time anymore
#   that we can sensibly have a more detailed scale...
#
call "examples/2.1-confirmed_cases_vs_change_Germany.gnuplot"
