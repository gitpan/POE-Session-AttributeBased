#!perl -T
# vim: filetype=perl


use strict;
use warnings;
use Test::More 'no_plan';

#
# Test Package
#
{
    package Testing1;
    use POE;
    use base 'POE::Session::AttributeBased';
    use Test::More;

    my $package = __PACKAGE__;
    POE::Session::AttributeBased->create(
	heap => \$package
    );

    sub _start : state {
	my ( $h, $k, $s, @arg ) = @_[HEAP, KERNEL, SESSION, ARG0 .. $#_ ];

	ok($$h eq __PACKAGE__, "_start in $$h");

	$k->post($s, 'this');
    }

    sub this : state {
	my $h = $_[HEAP];

	ok($$h eq __PACKAGE__, "this in $$h");
    }
}
#
# Test Package
#
{
    package Testing2;
    use POE;
    use base 'POE::Session::AttributeBased';
    use Test::More;

    my $package = __PACKAGE__;
    POE::Session::AttributeBased->create(
	heap => \$package
    );

    sub _start : state {
	my ( $h, $k, $s, @arg ) = @_[HEAP, KERNEL, SESSION, ARG0 .. $#_ ];

	ok($$h eq __PACKAGE__, "_start in $$h");
	$k->post($s, 'this');
    }

    sub this : state {
	my $h = $_[HEAP];

	ok($$h eq __PACKAGE__, "this in $$h");
    }
}
#
# Test Package
#
{
    package Component1;
    use POE;
    use base 'POE::Session::AttributeBased';
    use Test::More;

    sub spawn {
	my $package = __PACKAGE__;
	POE::Session::AttributeBased->create(
	    heap => \$package
	);
    }

    sub _start : state {
	my ( $h, $k, $s, @arg ) = @_[HEAP, KERNEL, SESSION, ARG0 .. $#_ ];

	ok($$h eq __PACKAGE__, "_start in $$h");
	$k->post($s, 'this');
    }

    sub this : state {
	my $h = $_[HEAP];

	ok($$h eq __PACKAGE__, "this in $$h");
    }
}
package main;

Component1->spawn();

POE::Kernel->run();
