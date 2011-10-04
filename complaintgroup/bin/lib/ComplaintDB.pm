package ComplaintDB;
use Redis;

use constant DEFAULTDB => 5;

sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
	self->{r} = undef;
  return $self;
}

sub open_connection {
	my $self = shift;
  my $dbnum = shift || DEFAULTDB;
	$self->{r} = Redis->new;
	$self->{r}->select( $dbnum );
	$self->{dbnum} = $dbnum;
  return $self;
}

sub copy {
	my $copy = ComplaintDB->new;
	$copy->{r} = $self->{r};
	$copy->{dbnum} = $self->{dbnum};
	return $copy;
}

1;

# vim: set nu ts=2:
