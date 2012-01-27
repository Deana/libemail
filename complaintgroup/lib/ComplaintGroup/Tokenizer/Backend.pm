package ComplaintGroup::Tokenizer::Backend;

use ComplaintGroup::Tokenizer::Backend::KyotoCabinet; 
use ComplaintGroup::Tokenizer::Backend::Redis;

sub new {
	my $invocant = shift;
	my $class = ref( $invocant ) || $invocant;

	my $self = {
		@_,
	};

	return bless $self, $class;
}

sub store ($$$) {
	my ($self,$key,$value) = @_;
	warn "Calling store from interface\n";
}

sub fetch ($$) {
	my ($self,$key) = @_;
	warn "Calling fetch from interface\n";

}

# a class method
sub create {
	my $class = shift;
	my $options = {
		backend => 'redis',
		@_,
	};

	use Data::Dumper;

	if( $options->{backend} eq 'redis' ){
		return ComplaintGroup::Tokenizer::Backend::Redis->new( %$options );
	} elsif ( $options->{backend} eq 'kyotocabinet' ){
		return ComplaintGroup::Tokenizer::Backend::KyotoCabinet->new( %$options );
	}
	return undef;
}

1;
