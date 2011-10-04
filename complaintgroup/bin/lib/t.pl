#!/usr/bin/perl
use strict;
use Data::Dumper;
use lib "./";
use ComplaintDB;
use Word;

my $db = ComplaintDB->new;
$db->open_connection();
my $word = Word->new;
$word->{r} = $db->{r};

print Dumper( $db ),"\n";
print Dumper( $word ),"\n";

print "Testing [foobar] against word object\n";

my $foobar_index = $word->get( "foobar" );

print "Index: $foobar_index\n";

$word->get( $foobar_index );
