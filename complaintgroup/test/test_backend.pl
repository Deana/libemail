#!/usr/bin/perl -CS
use strict;
use lib qw( /home/pblair/lib /home/pblair/complaintgroup/lib );	# XXX: Change this for your environment
use ComplaintGroup::Tokenizer::Backend;

# Create a Redis Backend
# my $redis = ComplaintGroup::Tokenizer::Backend->create( backend => 'redis' );
# 
# print "Storing 'foo => bar'\n";
# $redis->store( 'foo', 'bar' );
# 
# print "Fetching 'foo'\n";
# my $result = $redis->fetch( 'foo' );
# print "Result: $result\n";

my $kk = ComplaintGroup::Tokenizer::Backend->create( backend => 'kyotocabinet', filename => '/tmp/kk.kch' );
print "Storing 'foo => bar'\n";
$kk->store( 'foo', 'bar' );

print "Fetching 'foo'\n";
my $result = $kk->fetch( 'foo' );
print "Result: $result\n";



