#!/usr/bin/perl

use strict;
use warnings;

# Enable UTF-8 mode.
use open qw(:locale);

use DateTime;

# Input headers supported:
#
#   Province/State,Country/Region,Last Update,Confirmed,Deaths,Recovered
#   Province/State,Country/Region,Last Update,Confirmed,Deaths,Recovered,Latitude,Longitude
#   FIPS,Admin2,Province_State,Country_Region,Last_Update,Lat,Long_,Confirmed,Deaths,Recovered,Active,Combined_Key
#
# Output:
#
#   Province/State,Country/Region,Lat,Long,1/22/20,1/23/20,1/24/20,...
#

our $delim = ',';

our $target_field = 'Recovered';

scalar(@ARGV) == 1 or die("Usage: $0 BASE_DIR\n");

our $base_dir = shift;

our $date_end = time;


for (
	my $date = DateTime->new(month => 1, day => 22, year => 2020);
	$date->epoch < $date_end;
	$date->add(days => 1)
) {
	my $filename = $base_dir . '/' . $date->mdy . '.csv';

	unless (-f $filename) {
		warn("Warning: Daily report missing for " . $date->ymd . ": $filename\n");
		next;
	}

	open(my $fh, '<', $filename) or die("Cannot open input file \"$filename\": $!\n");


	my $head;
	defined($head = <$fh>) or die("Head line missing: $!\n");
	# UTF-8 BOM
	$head =~ s/^\x{FEFF}//;
	# CR/LF
	chomp($head);
	$head =~ s/\r$//;

	my @requiredFields = (qw(Province Country), $target_field);
	my %fieldColumn;
	my @head_fields = split(/$delim/, $head);
	for my $i (0 .. $#head_fields) {
		my $head_field = $head_fields[$i];
		for my $requiredField (@requiredFields) {
			if ($head_field =~ /^$requiredField/) {
				$fieldColumn{$requiredField} = $i;
			}
		}
	}
	for my $requiredField (@requiredFields) {
		exists($fieldColumn{$requiredField}) or die("Required field \"$requiredField\" missing for date " . $date->ymd . ", file \"$filename\"\n");
	}


	close($fh) or die("Cannot close input file \"$filename\": $!\n");
}

exit(0);
