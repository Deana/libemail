package Word;
use ComplaintDB;

@ISA = ("ComplaintDB");

use constant INDEXWORDPREFIX => 'ndx:word:';
use constant INCRWORD => 'incr:word';

sub copyinto {
	my ($self,$copy) = @_;
	$self->{r} = $copy->{r};
	return $self;
}

sub get {
	my ($self,$word) = @_;
	if( $word =~ /^\d+$/ ){
		my $word_index = $self->{r}->get( INDEXWORDPREFIX . $word ) || do { $self->{r}->set( INDEXWORDPREFIX . $word, $self->{r}->incr( INCRWORD ) ); $self->{r}->get( INDXWORDPREFIX . $word ); };
		return $word_index;
	}
	
	# Looks like a word that we want to get the index number of
	die( "Getting the word by index isn't currently supported\n" );
}

1;
