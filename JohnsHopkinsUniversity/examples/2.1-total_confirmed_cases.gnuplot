if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

TitleBase = "Total confirmed cases"
set ylabel "Total affected [people]"
call 'include/plot_raw_column.gnuplot' 'column("totalConfirmed")'
