#!/usr/bin/perl
use strict;
use lib "/home/pblair/lib";	# XXX: Change this for your environment
use Email::ARF::Report;
use MIME::Decoder;
use Redis;
use Data::Dumper;
use HTML::Strip;

use constant REDISDB => 5;
my $NORMALIZEDDIR = $ENV{CGROOT} || die("You must set CGROOT environment variable\n");
$NORMALIZEDDIR .= "/var/normalized";

my $hs = HTML::Strip->new();
my $redis = Redis->new;

# Select to appropriate database
$redis->select( REDISDB );

FILENAME:for my $filename ( @ARGV ){

	# Find if this file has already been normalized or not
	next if( $redis->exists( "orig:fn:$filename" ) );

	open FD, "<$filename" or do { warn "$filename: $!\n"; next FILENAME };

	my $input = do { local $/; <FD>; };

	close FD;

	my $report = Email::ARF::Report->new( $input );

	my $original = $report->original_email()->body_raw();

	# Now, decode it...
	my @header_pairs = $report->original_email()->header_pairs();
	my @hvalues = $report->original_email()->header( 'Content-Transfer-Encoding' );

	# Check if it's multipart
	my @contenttype = $report->original_email()->header( 'Content-Type' );
	next FILENAME if $contenttype[0] =~ /multipart/;
	# if( $contenttype[0] =~ /multipart/ ){
	# 	my $email = $report->original_email();
	# 
	# 	my @parts = $email->parts();
	# 
	# 	PART:for my $part ( @parts ){
	# 		if( $part->header( 'Content-Transfer-Encoding' ) =~ /7bit/i ){
	# 			$original = $part->body_str();
	# 			last PART;
	# 		}
	# 	}
	# }

	if( join( " ", @hvalues ) =~ /quoted-printable/i ){
		my $output;
		open(my $fh, '<', \$original) or die "Could not open string for reading";
		open(my $o,  '>', \$output )  or die "Could not open string for writing";

		my $decoder = new MIME::Decoder 'quoted-printable' or die "unsupported";
		$decoder->decode($fh, $o);
		$original = $o;

	} elsif ( join( " ", @hvalues ) =~ /base64/i ){
		next FILENAME;
		### my $output;
		### open(my $fh, '<', \$original) or die "Could not open string for reading";
		### open(my $o,  '>', \$output )  or die "Could not open string for writing";

		### my $decoder = new MIME::Decoder 'base64' or die "unsupported";
		### $decoder->decode($fh, $o);
	} 


	# 	open(my $fh, '>', \$string) or die "Could not open string for writing";
	# 	print $fh "foo\n";
	# 	print $fh "bar\n";	# $string now contains "foo\nbar\n"
	# 	open(my $fh, '<', \$string) or die "Could not open string for reading";
	# 	my $x = <$fh>;	# $x now contains "foo\n"

	$original = $hs->parse( $original );

	$original =~ s/=\n//g;
	$original =~ s/[,\.\-_'\"]//g;
	$original =~ s/=20//g;
	$original =~ s/\s+/ /g;

	my $index;

	# Find if this file has already been normalized or not
	unless( $redis->exists( "orig:fn:$filename" ) ){
		$index = $redis->incr('orig:counter');
		$redis->set( "orig:fn:$filename" => $index );
		$redis->set( "orig:idx:$index" => $filename );
	} else {
		$index = $redis->get( "orig:fn:$filename" );
	}

	my $normalized_filename = $NORMALIZEDDIR . "/$index";

	next if -f $normalized_filename;

	#print "$filename has index $index\n";

	############################################################
	# Start going through all of the words, tokenizing them
	# into integers, using redis for the mapping
	############################################################

	my @words = split( /\s+/, $original );
	my @iwords;

	for( @words ){
		$_ = lc $_;
		# Get the index for this word
		next if length( $_ ) > 20;

		next if /^\</;
		next if /\>$/;

		my $word_idx = $redis->get( "words:map:$_" ) || do { $redis->set( "words:map:$_", $redis->incr('words:counter') ); $redis->get( "words:map:$_" ) };

		# Now, store the index => word mapping
		$redis->set( "words:idx:$word_idx", $_ );

		push( @iwords, $word_idx );
	}

	# now save @iwords as a set under the filename index
	$redis->del( "nor:$index" );

	for ( reverse @iwords ){
		$redis->lpush( "nor:$index", $_ );
	}

	# Now print it out, so that it can be saved to a file
	my @elements = $redis->lrange( "nor:$index", 0, -1 );

	open FD, ">$normalized_filename" || die( "Cannot write normalized file $normalized_filename: $!\n" );
	print "Writing normalized file to $normalized_filename\n";

	print FD join( " ", @elements), "\n";

	close FD;
}
