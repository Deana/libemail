#!/usr/bin/perl
use strict;
use Data::Dumper;

my $map={};
while ( <> ){
	chomp;
	my @a = split( /\s+/, $_ );
	$map->{$a[1]}->{"$a[0]"}++;
}

use Redis;
use constant REDISDB => 5;

# Select to appropriate database
my $redis = Redis->new;
$redis->select( REDISDB );
my $index;

# What we need to accomplish:
#
# 1) Create an index for each "word"
#
# 2) Get the index for each filename
#
# 3) Add all word indexes to the set of filename indexes

# Store the word->filename mapping in redis
print "Processing words into redis DB\n";
for my $word ( keys %$map ){
	my $word_index = $redis->get( "ndx:word:$word" ) || do { $redis->set( "ndx:word:$word", $redis->incr( "incr:word" ) ); $redis->get( "ndx:word:$word" ); };
	$redis->set( "id:word:$word_index", $word );
	FILENAME:for my $filename ( keys %{$map->{"$word"}} ){
		my @a = split( /\//, $filename );
		my $index = $a[-1];

		next unless $index =~ /^\d+$/;
	
		my $filename_index = $redis->get( "ndx:filename:$filename" ) || do {
			$redis->set( "ndx:filename:$filename",
				     $redis->incr( "incr:filename" ) );
			$redis->get( "ndx:filename:$filename" ); 
		};
	
		# Add the word_index to the set of words, keyed by
		# filename index
		$redis->sadd( "file:words:$index", $word_index );

		# Create a set of files that have each n-gram
		#
		my $ngram_id = $word_index;
		$redis->sadd( "set:ngram:$ngram_id", $index );
	}
}

# vim: set nu ts=2:
