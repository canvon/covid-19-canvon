if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("OWIDLoaded") || OWIDLoaded == 0) {
  load 'include/owid.gnuplot'
}

set logscale y
set title "Total confirmed deaths in logarithmic scale"
plot for [Location in WorldLocations." International"] DataFile using (TC(1)):(SelectLocation(Location, column("totalDeaths"))) title Location with lines