#!/usr/bin/perl
use strict;
use Redis;

use constant REDISDB => 5;

# Select to appropriate database
my $redis = Redis->new;
$redis->select( REDISDB );
my $index;

for( @ARGV ){
	chomp;
	my $id = $redis->get( "orig:fn:$_" ) || next;
	print $_," => ", $id ,"\n";
}

