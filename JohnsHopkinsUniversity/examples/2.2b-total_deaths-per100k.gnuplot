if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

TitleBase = "Deaths per 100,000 population"
set ylabel "Affected if population was 100,000 [people]"
call 'include/read_population.gnuplot'
call 'include/plot_raw_column.gnuplot' 'column("totalDeaths")*PerPopulation(Location)'
