#!/usr/bin/perl

use strict;
use warnings;

use DateTime;

# Input:  Province/State,Country/Region,Lat,Long,1/22/20,1/23/20,1/24/20,...
# Output: date,location,new,total

my $head;
defined($head = <>) or die("Head line missing: $!\n");
# CR/LF
chomp($head);
$head =~ s/\r$//;

my $delim = ',';
my ($head_state, $head_region, $head_lat, $head_long, @head_dates) = split(/$delim/, $head);

die("Unrecognized head line!\n") unless
  $head_state  eq 'Province/State' &&
  $head_region eq 'Country/Region' &&
  $head_lat    eq 'Lat'            &&
  $head_long   eq 'Long';

my @unix_dates = map {
	m#^(\d+)/(\d+)/(\d+)$# or die("Invalid date \"$_\".\n");
	my $date = DateTime->new(month => $1, day => $2, year => 2000+$3);
	$date->epoch;
} (@head_dates);

my %locations;
while (<>) {
	# CR/LF
	chomp;
	s/\r$//;

	# Try to invert "Korea, South" and friends, to get rid of commas in quoted strings.
	s/"([^"]+), ([^"]+)"/"$2 $1"/;
	print STDERR "Problem line: $_\n" if /,"[^"]*,/;

	my ($state, $region, $lat, $long, @data_points) = split(/$delim/, $_, -1);
	$region =~ s/^"(.*)"$/$1/;  # Un-quote, the more-probably-not-needed-here way. ...
	print STDERR "Problem region: $region\n" if $region =~ /"/;

	if (exists($locations{$region})) {
		# Merge multiple states of the same region.
		my $loc_ref = $locations{$region};
		my $loc_dp_ref = $loc_ref->{data_points};
		my $i = 0;
		while ($i < scalar(@data_points) &&
		       $i < scalar(@$loc_dp_ref))
		{
			$loc_dp_ref->[$i] = 0 unless defined($loc_dp_ref->[$i]);
			$loc_dp_ref->[$i] += $data_points[$i];
			$i++;
		}
	}
	else {
		$locations{$region} = {
			data_points => \@data_points,
		};
	}
}


# Output head line.
print("date,location,new,total\n");

for my $location (sort keys %locations) {
	my $loc_ref = $locations{$location};
	my $loc_dp_ref = $loc_ref->{data_points};

	for my $i (0 .. scalar(@$loc_dp_ref) - 1) {
		my $x = $unix_dates[$i];
		my $y = $loc_dp_ref->[$i];
		my $yPrev;
		$yPrev = $loc_dp_ref->[$i - 1] if $i >= 1;

		my $new = defined($yPrev) ? $y - $yPrev : '';

		print(join($delim, $x, '"'.$location.'"', $new, $y) . "\n");
	}
}

exit(0);
