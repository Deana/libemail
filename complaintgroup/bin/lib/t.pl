#!/usr/bin/perl
use strict;
use Data::Dumper;
use lib "./";
use ComplaintDB;
use Word;
use NGram;
use Filename;

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

print "Creating NGram object..\n";
my $ng = NGram->new->copy_into( $db );
print Dumper( $ng ),"\n";

my @a = split /\s+/, "this is the best ngram ever";
my $a_ref =  $ng->create_ngram( \@a );

print Dumper( $a_ref ),"\n";

print Dumper( $ng->get( $a_ref->[0] ) ),"\n";

###
# Filename testing
my $FN = Filename->new->copy_into( $db );

print "Converting filename [/foo/bar] to index\n";
my $id = $FN->get( "/foo/bar" );
print Dumper( $id ), "\n";

print "Converting $id to a filename\n";
my $filename = $FN->get( $id );
print Dumper( $filename ), "\n";
