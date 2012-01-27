package ComplaintGroup::Tokenizer::Backend::Redis;
use strict;

use Redis;

use base qw( ComplaintGroup::Tokenizer::Backend );

sub new {
        my $invocant = shift;
        my $class = ref( $invocant ) || $invocant;

        my $self = {
                REDISDB => 6,
                @_,
        };

	$self->{redis} = Redis->new;
	$self->{redis}->select( $self->{REDISDB} );

        return bless $self, $class;
}

sub fetch ($$) {
	my ($self,$key) = @_;
	return $self->{redis}->get( $key );
}

sub store ($$$) {
	my ($self,$key,$value) = @_;
	return $self->{redis}->set( $key => $value );
}

1;
