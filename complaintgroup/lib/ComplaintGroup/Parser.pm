package ComplaintGroup::Parser;
use strict;

use Email::ARF::Report;
use MIME::Decoder;
use Redis;
use Data::Dumper;
use HTML::Strip;

sub new {
	my $invocant = shift;
	my $class = ref( $invocant ) || $invocant;

	my $self = {
		source_type => 'ARF',
		@_,
	};

	return bless $self, $class;
}

sub parse_arf {
	my ($self,$emailfilename) = @_;

	open FD, "<$emailfilename" or die "$emailfilename: $!\n";
	my $input = do { local $/; <FD>; };

	close FD;

	my $report = Email::ARF::Report->new( $input );
	$self->{original} = $report->original_email();
	$self->{body_raw} = $report->original_email()->body_raw();
}

sub parse_original {
	my $self = shift;
	my $filename = shift;
	my $original = undef;
	my $encoding = undef;

	unless( defined $self->{original} ){
		die "Source type not defined, cannot parse\n"
			unless defined $self->{source_type};

		$self->parse_arf( $filename )
			if $self->{source_type} eq 'ARF';

		die "Could not parse original\n"
			unless defined $self->{original};
	}

	my @header_pairs = $self->{original}->header_pairs();
	my @hvalues = $self->{original}->header( 'Content-Transfer-Encoding' );
	my @contenttype = $self->{original}->header( 'Content-Type' );

	die "multipart emails not currently supported\n"
		if( $contenttype[0] =~ /multipart/ );

	if( join( " ", @hvalues ) =~ /quoted-printable/i ){
		my $encoding = 'quoted-printable';
	}

	if( join( " ", @hvalues ) =~ /base64/i ){
		my $encoding = 'base64';
	}

	if( $encoding ){
		warn "Encoding: $encoding\n";
		my $output;
		open(my $fh, '<', \$original) or die "Could not open string for reading";
		open(my $o,  '>', \$output )  or die "Could not open string for writing";

		my $decoder = new MIME::Decoder $encoding or die "unsupported: $encoding\n";
		$decoder->decode($fh, $o);
		$original = $o;
	}

	$original = $self->{body_raw};

	$original = HTML::Strip->new->parse( $original );

        $original =~ s/=\n//g;
        $original =~ s/[,\.\-_'\"]//g;
        $original =~ s/=20//g;
        $original =~ s/\s+/ /g;

	$original = join( " ", split( /\s+/, $original ) );

	$self->{parsed} = lc $original;

	return $self->{parsed};
}

1;
