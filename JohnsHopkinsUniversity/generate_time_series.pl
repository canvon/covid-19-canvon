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

our $target_field_name = 'Recovered';

scalar(@ARGV) == 1 or die("Usage: $0 BASE_DIR\n");

our $base_dir = shift;

our $date_end = time;
our %locations;
our @dates;


# Open input files, read input, parse, merge.
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

	push(@dates, $date->clone);

	open(my $fh, '<', $filename) or die("Cannot open input file \"$filename\": $!\n");


	my $head;
	defined($head = <$fh>) or die("Head line missing: $!\n");
	# UTF-8 BOM
	$head =~ s/^\x{FEFF}//;
	# CR/LF
	chomp($head);
	$head =~ s/\r$//;

	my @requiredFields = (qw(Province Country), $target_field_name);
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
		exists($fieldColumn{$requiredField}) or die("Required header field \"$requiredField\" missing for date " . $date->ymd . ", file \"$filename\"\n");
	}


	while (<$fh>) {
		# CR/LF
		chomp;
		s/\r$//;

		# Try to invert "Korea, South" and friends, to get rid of commas in quoted strings.
		s/"([^",]+), *([^",]+), *([^",]+)"/"$3: $2: $1"/g;  # "Somerset, Maine, US" -> "US: Maine: Somerset"
		s/"([^",]+), *([^",]+)"/"$2 $1"/g;  # "Korea, South" -> "South Korea"
		warn("Warning: Problem line for date " . $date->ymd . ", file \"$filename\": $_\n")
		  if /,"[^"]*,/;

		my @fields = split(/$delim/, $_, -1);

		my $state = $fields[$fieldColumn{Province}];
		my $region = $fields[$fieldColumn{Country}];
		my $target = $fields[$fieldColumn{$target_field_name}];

		# Skip missing values, so that they can be treated as undefined
		# in the rest of the code to avoid warnings!
		next unless defined($target) && $target ne '';


		# Un-quote, the more-probably-not-needed-here way. ...

		$state =~ s/^"(.*)"$/$1/;
		warn("Warning: Problem state for date " . $date->ymd . ", file \"$filename\": $state\n")
		  if $state =~ /"/;

		$region =~ s/^"(.*)"$/$1/;
		warn("Warning: Problem region for date " . $date->ymd . ", file \"$filename\": $region\n")
		  if $region =~ /"/;


		# Overrides, to re-gain overal data consistency.
		$region =~ s/^Mainland (China)$/$1/;


		my $key = $region . $delim . $state;

		$locations{$key} = [] unless defined($locations{$key});
		push(@{$locations{$key}}, { date => $date->clone, target => $target });
	}


	close($fh) or die("Cannot close input file \"$filename\": $!\n");
}


# Output extracted & merged data.

# Head. (Field names.)
print("Province/State,Country/Region,Lat,Long,", join($delim, map {
	my $tmp = $_->mdy('/');
	$tmp =~ s#(^|/)0#$1#;  # Remove leading zeroes.
	$tmp =~ s#/20(\d\d)$#/$1#;  # Make a 2-digit year.
	$tmp
} (@dates)), "\n");

# Data.
for my $key (sort keys %locations) {
	my ($region, $state) = split(/$delim/, $key);
	my @dataPoints = @{$locations{$key}};

	my $found = 0;
	for my $dataPoint (@dataPoints) {
		my $dp_target = $dataPoint->{target};
		if (defined($dp_target) && $dp_target > 0) {
			$found++;
			last;
		}
	}
	next unless $found;

	# State,Region,Lat,Long
	print($state . $delim . $region . $delim . $delim);

	# ,1/22/20,1/23/20,1/24/20,...
	dates: for my $date (@dates) {
		while (scalar(@dataPoints) > 0) {
			my $dataPoint = shift(@dataPoints);
			my $dp_date   = $dataPoint->{date};
			my $dp_target = $dataPoint->{target};

			my $comp = DateTime->compare($dp_date, $date);
			next if ($comp < 0);  # Skip earlier values.

			# Date matches? Output field & go on.
			if ($comp == 0) {
				print($delim . $dp_target);
				next dates;
			}

			# Date in the future? Restore data point to list,
			# then drop out of the inner loop.
			unshift(@dataPoints, $dataPoint);
			last;
		}

		# Run out of potential data points? Skip value.
		print($delim);
	}
	print("\n");
}


exit(0);
