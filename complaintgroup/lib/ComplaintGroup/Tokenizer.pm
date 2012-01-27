package ComplaintGroup::Tokenizer;

use ComplaintGroup::Tokenizer::Backend;

use constant COUNTER => 'cnt:';

sub new {
        my $invocant = shift;
        my $class = ref( $invocant ) || $invocant;

        my $self = {
                backend => 'redis',
                @_,
        };

        my $obj = bless $self, $class;

	if( $self->{backend} eq 'redis' ){
		$self->{store} = ComplaintGroup::Tokenizer::Backend->create( backend => 'redis' );
	} elsif ( $self->{backend} eq 'kyotocabinet' ){
		$self->{store} = ComplaintGroup::Tokenizer::Backend->create( backend => 'kyotocabinet' );
	}

	return $obj;
}

sub tokenize {
	my $self = shift;
	my $string = shift;
	my $prefix = shift || "word:";

	my @a = split( /\s+/, $string );

	my @tokens;

	for( @a ){
		unless( $self->{store}->fetch( $prefix . $_ ) ){
			# Umm, somehow create a counter here
			my $counter = $self->{store}->incr( COUNTER . "tokens" );
			$self->{store}->store( $prefix . $_, $counter );

			# store the reverse index
			$self->{store}->store( $prefix . "index:" . $counter, $_);
		}
		#print "$prefix$_ => ",$self->{store}->fetch( $prefix . $_ ),"\n";
		push( @tokens, $self->{store}->fetch( $prefix . $_ ) );
	}

	return @tokens;
}

sub word {
	my ($self,$index) = @_;

	return $self->{store}->fetch( "word:index:$index" );
}

sub index {
	my ($self,$word) = @_;
	return $self->{store}->fetch( "word:$word" );
}

1;
