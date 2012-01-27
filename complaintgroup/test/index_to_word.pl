#!/usr/bin/perl -CS
use strict;
use lib qw( /home/pblair/lib /home/pblair/complaintgroup/lib );	# XXX: Change this for your environment
use ComplaintGroup::Tokenizer;

my $tok = ComplaintGroup::Tokenizer->new( backend => 'kyotocabinet' );

for my $token ( @ARGV ){

	eval {
		print $tok->word( $token )," ";
	};
	if( $@ ){
		print "Exception caught: $@";
	}
}
print "\n";
