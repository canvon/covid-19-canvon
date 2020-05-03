if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Total confirmed cases: World vs Germany"
}

plot DataFile using (TC(1)):(SelectLocation("World", column("totalCases"))) title "World" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("totalCases"))) title "Germany" with lines
