#!/usr/bin/perl

use strict;
use warnings;

# Enable UTF-8 mode.
use open qw(:locale);

use DateTime;

# Input:  Province/State,Country/Region,Lat,Long,1/22/20,1/23/20,1/24/20,...
# Output: date,location,new,total

our $delim = ',';


sub loadData($)
{
	my ($fh) = @_;

	my $head;
	defined($head = <$fh>) or die("Head line missing: $!\n");
	# CR/LF
	chomp($head);
	$head =~ s/\r$//;

	my ($head_state, $head_region, $head_lat, $head_long, @head_dates) = split(/$delim/, $head);

	die("Unrecognized head line!\n") unless
	  $head_state  eq 'Province/State' &&
	  $head_region eq 'Country/Region' &&
	  $head_lat    eq 'Lat'            &&
	  $head_long   eq 'Long';

	my @unix_dates = map {
		m#^(\d+)/(\d+)/(\d+)$# or die("Invalid date \"$_\".\n");
		my $date = DateTime->new(month => $1, day => $2, year => 2000+$3,
		                         hour => 23, minute => 59, second => 59,
		                         time_zone => 'UTC');
		$date->epoch;
	} (@head_dates);

	my %locations;
	while (<$fh>) {
		# CR/LF
		chomp;
		s/\r$//;

		# Try to invert "Korea, South" and friends, to get rid of commas in quoted strings.
		s/"([^"]+), ([^"]+)"/"$2 $1"/;
		print STDERR "Problem line: $_\n" if /,"[^"]*,/;

		my ($state, $region, $lat, $long, @data_points) = split(/$delim/, $_, -1);
		$region =~ s/^"(.*)"$/$1/;  # Un-quote, the more-probably-not-needed-here way. ...
		print STDERR "Problem region: $region\n" if $region =~ /"/;

		# Interpret empty values as undef. Important for avoiding warnings, later!
		for my $data_point (@data_points) {
			$data_point = undef if $data_point eq '';
		}

		if (exists($locations{$region})) {
			# Merge multiple states of the same region.
			my $loc_ref = $locations{$region};
			my $loc_dp_ref = $loc_ref->{data_points};
			my $i = 0;
			while ($i < scalar(@data_points) ||
			       $i < scalar(@$loc_dp_ref))
			{
				$loc_dp_ref->[$i] = 0 unless defined($loc_dp_ref->[$i]);
				$loc_dp_ref->[$i] += $data_points[$i] if defined($data_points[$i]);
				$i++;
			}
		}
		else {
			$locations{$region} = {
				data_points => \@data_points,
			};
		}
	}


	# Post-process.

	my @world_data_points;

	for my $location (sort keys %locations) {
		my $loc_ref = $locations{$location};
		my $loc_dp_ref = $loc_ref->{data_points};
		my $i = 0;
		while ($i < scalar(@world_data_points) ||
		       $i < scalar(@$loc_dp_ref))
		{
			$world_data_points[$i] = 0 unless defined($world_data_points[$i]);
			$world_data_points[$i] += $loc_dp_ref->[$i] if defined($loc_dp_ref->[$i]);
			$i++;
		}
	}

	$locations{"World"} = {
		data_points => \@world_data_points,
	};

	return (\@unix_dates, \%locations);
}


sub outputDataGlobal($$)
{
	my ($unix_dates, $locations) = @_;

	# Output head line.
	my $world_ref = $locations->{"World"};
	my @keys = sort keys %$world_ref;
	local $_;
	print("date,location");
	print(",new$_")   for (@keys);
	print(",total$_") for (@keys);
	print("\n");

	for my $location (sort keys %$locations) {
		my $loc_ref = $locations->{$location};

		for my $i (0 .. scalar(@$unix_dates) - 1) {
			my $x = $unix_dates->[$i];

			my (@newValues, @yValues);
			for my $key (@keys) {
				my $y = $loc_ref->{$key}[$i];
				my $yPrev;
				$yPrev = $loc_ref->{$key}[$i - 1] if $i >= 1;

				my $newOrEmpty = (defined($y) && defined($yPrev)) ? $y - $yPrev : '';
				my $yOrEmpty = $y // '';

				push(@newValues, $newOrEmpty);
				push(@yValues, $yOrEmpty);
			}

			print(join($delim, $x, '"'.$location.'"', @newValues, @yValues) . "\n");
		}
	}
}


scalar(@ARGV) >= 1 or die("Usage: $0 input-foo.csv input-bar.csv [...] >output.csv\n");

my $unix_dates_global;
my $locations_global = {};

for my $filename (@ARGV) {

	#$filename =~ m#-([^-/]+)\.csv$#
	$filename =~ m#_([^_/]+)_global\.csv$#
	  or die("Cannot grok input file name \"$filename\"\n");
	my $key = $1;
	$key =~ s/^([a-z])/\U$1/;  # Up-case first character.

	open(my $fh, '<', $filename) or die("Cannot open input file \"$filename\": $!\n");

	my ($unix_dates, $locations) = loadData($fh);

	if (defined($unix_dates_global)) {
		die("Non-matching input dates!\n") unless scalar(@$unix_dates_global) == scalar(@$unix_dates);
		for my $i (0 .. scalar(@$unix_dates) - 1) {
			die("Non-matching input date #$i\n") unless $unix_dates_global->[$i] == $unix_dates->[$i];
		}
	}
	else {
		$unix_dates_global = $unix_dates;
	}

	# Merge.
	for my $location (keys %$locations) {
		my $loc_ref = $locations->{$location};
		$locations_global->{$location}{$key} = $loc_ref->{data_points};
	}

	close($fh) or die("Cannot close input file \"$filename\": $!\n");
}

outputDataGlobal($unix_dates_global, $locations_global);


exit(0);
