#!/usr/bin/perl -CS
use strict;
use lib qw( /home/pblair/lib /home/pblair/complaintgroup/lib );
use ComplaintGroup::Parser;
use ComplaintGroup::Tokenizer;

my $tok = ComplaintGroup::Tokenizer->new( backend => 'kyotocabinet' );

FILENAME:for my $filename ( @ARGV ){

	my $parser = ComplaintGroup::Parser->new(
		source_type => 'ARF',
	);

	eval {
		my $email_text = $parser->parse_original( $filename );
		my @tokens = $tok->tokenize( $email_text );

		next FILENAME unless scalar @tokens > 0;

		print "$filename tokenized: " . join( " ", @tokens ) . "\n";
	};
	if( $@ ){
		next FILENAME if $@ =~ /multipart emails not currently supported/;
		print "Exception caught [$filename]: $@";
	}
}
