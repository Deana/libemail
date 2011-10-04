use strict;
use Test::More;
use lib "../lib/";

# Test that we can import the required libraries
require_ok( 'ComplaintDB' );
require_ok( 'Word' );

my $db = ComplaintDB->new;
$db->open_connection();

isnt( $db, undef, 'ComplaintDB instantiation' );

my $word = Word->new->copy_into( $db );

isnt( $word, undef, 'Word copy from ComplaintDB' );

my $test_word = "foobar";
my $foobar_index = $word->get( $test_word );

isnt( $foobar_index, undef, 'Create/Retrieve index against Redis word' );

#print "Index: $foobar_index\n";

my $stored_word = $word->get( $foobar_index );
is( $stored_word, $test_word, 'Comparing retreived word from reverse index' );

done_testing( 6 );
