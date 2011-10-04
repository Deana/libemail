package Filename;
use ComplaintDB;

@ISA = ("ComplaintDB");

use strict;

use constant INDEXFILENAME => 'ndx:fn:';
use constant FILENAMEID => 'orig:idx:';
use constant INCRFILENAME => 'incr:word';

sub get {
	my ($self,$filename) = @_;
	unless ( $filename =~ /^\d+$/ ){
		my $filename_index = $self->{r}->get( INDEXFILENAME . $filename ) || do { 
			$self->{r}->set( INDEXFILENAME . $filename, $self->{r}->incr( INCRFILENAME ) ); 
			$self->{r}->get( INDEXFILENAME . $filename ); 
		};
		$self->{r}->set( FILENAMEID . $filename_index, $filename ) if $filename_index;
		return $filename_index;
	}
	return $self->{r}->get( FILENAMEID . $filename );
}

1;
