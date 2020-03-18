#!/usr/bin/perl

use strict;
use warnings;

use DateTime;

defined($_ = <>) or die("Head line missing: $!\n");
#my $delim = ' ';
#s/,/$delim/g;
my $delim = ',';
s/_([a-z])/\U$1/g;
print;

while (<>) {
	chomp;
	my ($date_raw, $location, @data) = split(/,/, $_, -1);

	$date_raw =~ /^(\d+)-(\d+)-(\d+)$/ or die("Invalid date \"$date_raw\".\n");
	my $date = DateTime->new(year => $1, month => $2, day => $3);
	my $date_out = $date->epoch;

	print($date_out . $delim . '"'.$location.'"' . $delim . join($delim, @data) . "\n");
}

exit(0);
