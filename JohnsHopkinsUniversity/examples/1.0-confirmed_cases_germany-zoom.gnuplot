# Based on: ../OurWorldInData.org/examples/2.2-bestaetigte_Faelle_neue_bestaetigte_Faelle_Deutschland-zoom.gnuplot.txt

if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
  set title "Total confirmed cases \\& change, Germany (zoom)"
}

Location = "Germany"

unset xdata
stats DataFile using (SelectLocation(Location, column("date"))) name Location.'Date' nooutput
DateEnd = value(Location.'Date_max')
DateBeforeEnd = DateEnd - 26*60*60
yPrev = NaN
yFinal = NaN
stats [DateBeforeEnd:DateEnd] DataFile using ( \
	(yWork=SelectLocation(Location, column("totalConfirmed"))) == yWork ? (yPrev=yFinal, yFinal=yWork) : NaN \
) name 'Dummy' nooutput
set xdata time

Addendum = ""
if (yFinal == yFinal) {
	Addendum = Addendum.sprintf(": %d", yFinal)
	if (yPrev == yPrev) {
		Addendum = Addendum.sprintf(" (%+d)", yFinal - yPrev)
	}
}

set ytics nomirror
set y2tics
set ylabel "Total affected [people]"
set y2label "Change of affected [people per day]"
plot ["2020-02-27":] DataFile using (TC(1)):(SelectLocation(Location, column("totalConfirmed"))) title "total confirmed cases".Addendum with lines, \
	'' using (TC(1)):(SelectLocation(Location, column("newConfirmed"))) axis x1y2 title "change to previous value" with fsteps
