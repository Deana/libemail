package ComplaintDB;
use Redis;

use constant DEFAULTDB => 5;

sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}

sub open_connection {
	my $self = shift;
  my $dbnum = shift || DEFAULTDB;
	my $r = Redis->new;
	$r->select( $dbnum );
	$self->{r} = $r;
  return $self;
}

1;

# vim: set nu ts=2:
