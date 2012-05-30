#!/usr/bin/perl -slw
use strict;

sub bin2dd{ join '.', unpack 'C4', pack 'N', $_[0] }
sub dd2bin{ unpack 'N', pack'C4', split'\.', $_[0] }

sub CIDRList{
    my $iter = 0xffffffff >> $_[0];
    my $mask = ~$iter;
    my $lo = dd2bin( $_[1] ) & $mask;
    map{ bin2dd $lo++ } 0 .. $iter;
}

while( <> ){
	next unless /^\d+\.\d+\.\d+\.\d+/;

	if( /^(\d+\.\d+\.\d+\.\d+)\/(\d+)\s*$/ ){
		print for CIDRList $2, $1;
	}
}

__END__
