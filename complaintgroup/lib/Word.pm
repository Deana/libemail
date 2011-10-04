package Word;
use ComplaintDB;

@ISA = ("ComplaintDB");

use strict;

use constant INDEXWORDPREFIX => 'ndx:word:';
use constant INCRWORD => 'incr:word';

use constant WORDID => 'id:word:';

sub get {
	my ($self,$word) = @_;
	unless ( $word =~ /^\d+$/ ){
		my $word_index = $self->{r}->get( INDEXWORDPREFIX . $word ) || do { 
			$self->{r}->set( INDEXWORDPREFIX . $word, $self->{r}->incr( INCRWORD ) ); 
			$self->{r}->get( INDEXWORDPREFIX . $word ); 
		};
		$self->{r}->set( WORDID . $word_index, $word ) if $word_index;
		return $word_index;
	}
	

	# figure out which word is associated to this
	return $self->{r}->get( WORDID . $word);
}

1;
