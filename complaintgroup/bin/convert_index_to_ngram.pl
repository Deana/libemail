#!/usr/bin/perl
use strict;
use Redis;

use constant REDISDB => 5;

# Select to appropriate database
my $redis = Redis->new;
$redis->select( REDISDB );
my $index;

for( @ARGV ){
	my @a = split( /:/, $_ );
	for my $index( split( /:/, $_ ) ){
		print $redis->get( "id:word:$index" )," ";
	}
	print "\n";
}

