use lib "../lib";
use Email::ExtractURL;
use Data::Dumper;
use Test::More;

my @domains = qw/
	snickers.org
/;

my $text = 'this is a domain http://snickers.org/foobar ...';

my $aref = Email::ExtractURL::extract_domains( $text );

for my $test_domain ( @domains ){
	print "Testing match of [$test_domain].. ";
	ok( grep { /^$test_domain$/ } @$aref , $test_domain );
}

done_testing();
