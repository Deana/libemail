#!/usr/bin/perl
use strict;
use Data::Dumper;

# get all of the files to compare
my @filenames = @ARGV;

my $k = 6;

my %m;

for my $filename ( @filenames ){
	open FD, "<$filename" or die("Cannot open $filename: $!\n" );

	my $input = do { local $/; <FD>; };
	my @w = split( /\s+/, $input );
	$m{$filename} = \@w;

	close FD;
}

my $bwords = {};

for my $filename ( sort keys %m ){
	my $words = $m{$filename};

	my $buckets = [];

	my $wcount = scalar @$words;

	my $i;
	for( $i = 0; $i < ($wcount - $k); $i++ ){
		my $b = [];
		for( my $x = $i; $x < ($i + $k); $x++ ){
			push( @{$b}, $words->[$x] );
		}
		push( @$buckets, $b );
		#print $words->[$i,($i+$k)], "\n";
	}
	
	$bwords->{$filename} = $buckets;
}

for my $filename ( sort keys %$bwords ){
	my $buckets = $bwords->{$filename};

	for ( @$buckets ){
		my $out = join( ":", @$_ );
		print $filename," ",$out,"\n";
	}

}

