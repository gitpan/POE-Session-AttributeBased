#!perl -T

use strict;
use warnings;
use Test::More 'no_plan' ;

use POE;
use POE::Session::AttributeBased;
use base 'POE::Session::AttributeBased';

POE::Session::AttributeBased->create(
    heap => { this => 1, in => 'the', 'heap' => 2 },
);

sub _start : state {
    my ( $h, $k, $s, @arg ) = @_[HEAP, KERNEL, SESSION, ARG0 .. $#_ ];
    my $x;

    is ($h->{this}, 1,   "hash passed1");
    is ($h->{in}, 'the', "hash passed2");
    is ($h->{heap}, 2,   "hash passed3");
}

POE::Kernel->run();
