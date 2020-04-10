if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Bestätigte Fälle Welt/Deutschland gegenüber neuen Fällen"
}

set ytics nomirror
set y2tics
plot DataFile using (TC(1)):(SelectLocation("World", column("totalCases"))) title "bestätigte Fälle Welt" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("totalCases"))) title "bestätigte Fälle Deutschland" with lines, \
	'' using (TC(1)):(SelectLocation("World", column("newCases"))) axis x1y2 title "neue Fälle Welt" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("newCases"))) axis x1y2 title "neue Fälle Deutschland" with lines