if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

set title "Currently active cases"
plot for [Location in WorldLocations] DataFile using (TC(1)):(SelectLocation(Location, column("totalConfirmed") - column("totalDeaths") - column("totalRecovered"))) title Location with lines
