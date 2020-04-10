if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Gesamtzahl Fälle: Welt gegenüber Deutschland"
}

plot DataFile using (TC(1)):(SelectLocation("World", column("totalCases"))) title "Welt" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("totalCases"))) title "Deutschland" with lines