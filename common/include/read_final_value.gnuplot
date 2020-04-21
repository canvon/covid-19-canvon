# read_final_value.gnuplot - This gnuplot include file is used to
# read a final value & previous value into a variable.

ReadFinalValueUsage = "Usage: call 'read_final_value.gnuplot' DateEnd VariablePrefix Expression"

if (!(ARGC == 3)) { exit error "Number of arguments must be 3.\n".ReadFinalValueUsage }

DateEnd = ARG1
DateBeforeEnd = DateEnd - 26*60*60

yPrev = NaN
yFinal = NaN

unset xdata
stats [DateBeforeEnd:DateEnd] DataFile using ( \
	(yWork=@ARG3) == yWork ? (yPrev=yFinal, yFinal=yWork) : NaN \
) name 'Dummy' nooutput
set xdata time

Addendum = ""
if (yFinal == yFinal) {
	Addendum = Addendum.sprintf(": %d", yFinal)
	if (yPrev == yPrev) {
		Addendum = Addendum.sprintf(" (%+d)", yFinal - yPrev)
	}
}

VarName = ARG2.'Prev'
@VarName = yPrev
VarName = ARG2.'Final'
@VarName = yFinal
VarName = ARG2.'Addendum'
@VarName = Addendum
