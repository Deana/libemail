package ComplaintGroup::Tokenizer::Backend::KyotoCabinet;
use strict;

use KyotoCabinet;

use base qw( ComplaintGroup::Tokenizer::Backend );



sub new {
        my $invocant = shift;
        my $class = ref( $invocant ) || $invocant;

        my $self = {
		filename => '/tmp/kyoto.kch',
                @_,
        };

        my $o = bless $self, $class;
	$o->{store} = new KyotoCabinet::DB;

	unless ($o->{store}->open( $self->{filename}, $o->{store}->OWRITER | $o->{store}->OCREATE)) {
		my $error = sprintf ("open error: %s\n", $self->{store}->error);
		die( $error );
	}

	return $o;
}

sub fetch ($$){
	my ($self,$key) = @_;

	return $self->{store}->get( $key );
}

sub store ($$$) {
	my ($self,$key,$value) = @_;
	return $self->{store}->set( $key, $value );
}

sub incr {
	my ($self,$key) = @_;
	return $self->{store}->increment( $key, 1 );
}

1;
