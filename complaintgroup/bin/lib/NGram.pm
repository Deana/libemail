package NGram;
use ComplaintDB;

@ISA = ("ComplaintDB");

use Word;

sub get( $$ ){
	my ($self, $ngram) = @_;

	my $W = Word->new->copy_into( $self->copy );

	my @b;

	if( $ngram =~ /\d+(?::\d+)?/ ){
		my @a = split /:/, $ngram ;

		for ( @a ){
			push( @b, $W->get( $_ ) );
		}

	} else { die ("Unsupported input:[$ngram]\n"); }
	return \@b;

}

sub create_ngram( $$ ){
	my ( $self, $a_ref ) = @_;
	
	my $W = Word->new;
	$W->copy_into( $self->copy() );

	my @a;

	# Iterate over the array, creating words by these,
	for my $word ( @$a_ref ){
		my $id = $W->get( $word );
		push( @a, $id );
	}

	my @ngram = join( ":", @a );
	return \@ngram;
}

1;
