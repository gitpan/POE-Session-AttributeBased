package POE::Session::AttributeBased;
use Attribute::Handlers;
require POE::Session;    # for the offset constants

use warnings;
use strict;

=head1 NAME

POE::Session::AttributeBased - POE::Session syntax sweetener

=head1 VERSION

Version 0.06

=cut

our $VERSION = '0.06';

=head1 SYNOPSIS

    #!perl

    package Foo;

    use Test::More tests => 7;

    use POE;
    use base 'POE::Session::AttributeBased';

    sub _start : State {
	my $k : KERNEL;
	my $h : HEAP;

	ok( 1, "in _start" );

	$k->yield( tick => 5 );
    }

    sub tick : State {
	my $k     : KERNEL;
	my $count : ARG0;

	ok( 1, "in tick" );
	return 0 unless $count;

	$k->yield( tick => $count - 1 );
	return 1;
    }

    POE::Session->create(
	Foo->inline_states(),
    );

    POE::Kernel->run();
    exit;

=head1 ABSTRACT

A simple mixin that sprinkles sugar all over event handlers.

=head1 DESCRIPTION

Provides an attribute handler that does some bookkeeping for state handlers.
There have been a few of these classes for POE.
This is probably the most minimal.

=head1 FUNCTIONS

=head2 State

The state hander attribute.  Never called directly.

=cut

my %State;

sub State : ATTR(CODE) {
    my ( $package, $symbol, $code, $attribute, $data ) = @_;

    $State{$package}{ *{$symbol}{NAME} } = $code;
}

=head2 Offset

POE::Session Offsets each have their own packet of sugar

=cut

sub Offset {
    my $ref       = $_[2];
    my $attribute = $_[3];

    package DB;
    my @x = caller(5);
    $$ref = $DB::args[ POE::Session->$attribute() ];
}

=head2 OBJECT
=head2 SESSION
=head2 KERNEL
=head2 HEAP
=head2 STATE
=head2 SENDER
=head2 CALLER_FILE
=head2 CALLER_LINE
=head2 CALLER_STATE
=head2 ARG0
=head2 ARG1
=head2 ARG2
=head2 ARG3
=head2 ARG4
=head2 ARG5
=head2 ARG6
=head2 ARG7
=head2 ARG8
=head2 ARG9

=cut

sub OBJECT       : ATTR(SCALAR) { Offset @_; }
sub SESSION      : ATTR(SCALAR) { Offset @_; }
sub KERNEL       : ATTR(SCALAR) { Offset @_; }
sub HEAP         : ATTR(SCALAR) { Offset @_; }
sub STATE        : ATTR(SCALAR) { Offset @_; }
sub SENDER       : ATTR(SCALAR) { Offset @_; }
sub CALLER_FILE  : ATTR(SCALAR) { Offset @_; }
sub CALLER_LINE  : ATTR(SCALAR) { Offset @_; }
sub CALLER_STATE : ATTR(SCALAR) { Offset @_; }
sub ARG0         : ATTR(SCALAR) { Offset @_; }
sub ARG1         : ATTR(SCALAR) { Offset @_; }
sub ARG2         : ATTR(SCALAR) { Offset @_; }
sub ARG3         : ATTR(SCALAR) { Offset @_; }
sub ARG4         : ATTR(SCALAR) { Offset @_; }
sub ARG5         : ATTR(SCALAR) { Offset @_; }
sub ARG6         : ATTR(SCALAR) { Offset @_; }
sub ARG7         : ATTR(SCALAR) { Offset @_; }
sub ARG8         : ATTR(SCALAR) { Offset @_; }
sub ARG9         : ATTR(SCALAR) { Offset @_; }

=head2 inline_states

Returns the list of states in a syntax that is usable by POE::Session->create.
Can also specify what to return as the hash key so that it is useful in
packages like POE::Component::Server::TCP where the state list has a 
different tag.

=cut

sub inline_states {
    my $tag = $_[1] || 'inline_states';

    return ( $tag => $State{ ( caller() )[0] } );
}

=head1 AUTHOR

Chris Fedde, C<< <cfedde at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-poe-attr at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=POE-Session-AttributeBased>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc POE::Session::AttributeBased

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/POE-Session-AttributeBased>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/POE-Session-AttributeBased>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=POE-Session-AttributeBased>

=item * Search CPAN

L<http://search.cpan.org/dist/POE-Session-AttributeBased>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Chris Fedde, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of POE::Session::AttributeBased
