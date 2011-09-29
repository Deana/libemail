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
	print $_," => ",$redis->get( "orig:idx:$_" ),"\n";
}

