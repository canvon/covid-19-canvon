# Based on: ../OurWorldInData.org/examples/2.2-bestaetigte_Faelle_neue_bestaetigte_Faelle_Deutschland-zoom.gnuplot.txt

if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
  set title "Total confirmed cases vs new confirmed, Germany (zoom)"
}

set ytics nomirror
set y2tics
set ylabel "Total [people]"
set y2label "Change [people per day]"
plot ["2020-02-27":] DataFile using (TC(1)):(SelectLocation("Germany", column("totalConfirmed"))) title "total confirmed cases" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("newConfirmed"))) axis x1y2 title "change to previous value" with lines
