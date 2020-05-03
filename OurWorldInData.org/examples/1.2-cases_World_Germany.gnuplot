if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Confirmed cases World/Germany vs new cases"
}

set ytics nomirror
set y2tics
plot DataFile using (TC(1)):(SelectLocation("World", column("totalCases"))) title "confirmed cases World" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("totalCases"))) title "confirmed cases Germany" with lines, \
	'' using (TC(1)):(SelectLocation("World", column("newCases"))) axis x1y2 title "new cases World" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("newCases"))) axis x1y2 title "new cases Germany" with lines
