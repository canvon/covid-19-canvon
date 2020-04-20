if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

TitleBase = "Total confirmed cases per 100,000"
do for [Location in WorldLocations] {
  call '../common/include/read_value.gnuplot' 'population_for_gnuplot.csv' 'Population'.Unspace(Location) 'SelectLocation(Location, column("population"))'
}
call 'include/plot_raw_column.gnuplot' 'column("totalConfirmed")*100000./value("Population".Unspace(Location)."_max")
