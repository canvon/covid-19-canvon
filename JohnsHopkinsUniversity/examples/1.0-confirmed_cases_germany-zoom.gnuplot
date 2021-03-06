# Based on: ../OurWorldInData.org/examples/2.2-bestaetigte_Faelle_neue_bestaetigte_Faelle_Deutschland-zoom.gnuplot.txt

if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
  set title "Total confirmed cases \\& change, Germany (zoom)"
}

Location = "Germany"

call '../common/include/read_final_value.gnuplot' (WorldDateEnd) Location.'TotalConfirmed' 'SelectLocation(Location, column("totalConfirmed"))'

set ytics nomirror
set y2tics
set ylabel "Total affected [people]"
set y2label "Change of affected [people per day]"
plot ["2020-02-27":] DataFile using (TC(1)):(SelectLocation(Location, column("totalConfirmed"))) title "total confirmed cases".value(Location.'TotalConfirmedAddendum') with lines, \
	'' using (TC(1)):(SelectLocation(Location, column("newConfirmed"))) axis x1y2 title "change to previous value" with fsteps
