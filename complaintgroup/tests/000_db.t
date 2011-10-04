use strict;
use Test::More;
use lib "../lib/";

# Test that we can import the required libraries
require_ok( 'ComplaintDB' );

my $db = ComplaintDB->new->open_connection();

isnt( $db, undef, 'ComplaintDB instantiation' );

done_testing( 2 );
