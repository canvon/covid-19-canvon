if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
  set title "Confirmed cases vs change: Germany"
}

set ytics nomirror
set y2tics
set ylabel "Total affected [people]"
set y2label "Change of affected [people per day]"
plot DataFile using (TC(1)):(SelectLocation("Germany", column("totalCases"))) title "confirmed cases Germany" with lines, \
	'' using (TC(1)):(SelectLocation("Germany", column("newCases"))) axis x1y2 title "change to previous value" with lines
