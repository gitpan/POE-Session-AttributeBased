#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'POE::Session::AttributeBased' );
}

diag( "Testing POE::Session::AttributeBase $POE::Session::AttributeBased::VERSION, Perl $], $^X" );
