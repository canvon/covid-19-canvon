# Initialize PopulationFoo_max variables that hold each Location Foo's population count.
do for [Location in WorldLocations] {
  call '../common/include/read_value.gnuplot' 'population_for_gnuplot.csv' 'Population'.Unspace(Location) 'SelectLocation(Location, column("population"))'
}
