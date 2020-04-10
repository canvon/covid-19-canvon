# Based on: ../OurWorldInData.org/examples/2.2-bestaetigte_Faelle_neue_bestaetigte_Faelle_Deutschland-zoom.gnuplot.txt

if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
  set title "Bestätigte gegenüber neuen Fällen Deutschland (Zoom)"
}

set ytics nomirror
set y2tics
plot ["2020-02-27":] DataFile using (TC(1)):(SelectLocation("Germany", column("totalConfirmed"))) title "bestätigte Fälle Deutschland" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("newConfirmed"))) axis x1y2 title "neue bestätigte Fälle Deutschland" with lines
