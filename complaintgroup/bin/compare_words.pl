#!/usr/bin/perl
use strict;
use Data::Dumper;
use Redis;

# This function takes two file ids, and does an interset on
# the set of words within them.  It also sums the set size
# of each file, and returns a value containing how simillar
# the files are
sub compare( $$$ ){
	my ($r,$id1,$id2) = @_;
	my @intersect = $r->sinter( "file:words:$id1", "file:words:$id2" );
	#print "Intersect: ", join( ", ", @intersect ), "\n"
	#	if scalar @intersect > 0;
	return -1 if scalar @intersect == 0;
	my $s1 = $r->smembers( "file:words:$id1" ) * 1.0;
	my $s2 = $r->smembers( "file:words:$id2" ) * 1.0;
	my $c = scalar @intersect;
	$c *= 1.0;
	return ($c) / ( ( $s1 + $s2 ) / 2.0 );
}

my $r = Redis->new;
$r->select( 5 );

for my $fileindex ( @ARGV ){
	# Get all of the words in $fileindex
	my @words = $r->smembers( "file:words:$fileindex" );

	my $seen = {};

	# get all files
	for my $ngram_id ( @words ){
		my @files = $r->smembers( "set:ngram:$ngram_id" );
		for ( @files ){
      next if defined $seen->{$_};
      next if $_ == $fileindex;  # Don't compare to yourself
      $seen->{$_}++;
      my $thesame = compare( $r, $fileindex, $_ );
      next if $thesame < 0;
      $thesame *= 100.0;
      printf "%s / %s == %.4f\n", $fileindex, $_, $thesame;
		}
	}
}

# vim: set nu ts=2:
