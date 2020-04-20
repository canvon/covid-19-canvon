#!/usr/bin/perl

use strict;
use warnings;

# Enable UTF-8 mode.
use open qw(:locale);

use Text::CSV;

my $csv = Text::CSV->new({ binary => 1, blank_is_undef => 1 })
  or die("Cannot use CSV (for input): " . Text::CSV->error_diag());
my $csv_out = Text::CSV->new({ binary => 1, blank_is_undef => 1 })
  or die("Cannot use CSV (for output): " . Text::CSV->error_diag());

$csv_out->eol("\n");

scalar(@ARGV) == 1 or die("Usage: $0 UID_ISO_FIPS_LookUp_Table.csv\n");
my ($fileName) = @ARGV;

open(my $fh, '<', $fileName)
  or die("Can't open input file \"$fileName\": $!\n");

# UID,iso2,iso3,code3,FIPS,Admin2,Province_State,Country_Region,Lat,Long_,Combined_Key,Population
my $header_row = $csv->getline($fh)
  or die("Can't read header row from input file \"$fileName\": " . $csv->error_diag());

for my $key (qw(Province_State Country_Region Population)) {
  die("Required key \"$key\" missing from header row of CSV input file \"$fileName\"\n")
    unless scalar(grep { $_ eq $key } (@$header_row));
}

$csv->column_names($header_row);

my $header_row_out = [qw(location population)];
$csv_out->print(\*STDOUT, $header_row_out);
$csv_out->column_names($header_row_out);

my $world_population = 0;
while (my $row_hr = $csv->getline_hr($fh)) {
  # Skip per-state entries. (Here, we seem to not need to sum up things ourselves except for World.)
  next if defined($row_hr->{Province_State});

  my $location   = $row_hr->{Country_Region};
  my $population = $row_hr->{Population};

  die("Error: Location missing") unless defined($location);
  unless (defined($population)) {
    warn("Warning: No population for location \"$location\"")
      unless $location =~ /^(?:Diamond Princess|MS Zaandam)$/;
    next;
  }

  # Fix-ups:
  $location =~ s/US/United States/;

  $csv_out->print_hr(\*STDOUT, { location => $location, population => $population });

  $world_population += $population;
}
$csv->eof or die("Error reading/parsing CSV from input file \"$fileName\": " . $csv->error_diag());
close($fh) or die("Couldn't close input file \"$fileName\": $!\n");

$csv_out->print_hr(\*STDOUT, { location => 'World', population => $world_population });

exit(0);
