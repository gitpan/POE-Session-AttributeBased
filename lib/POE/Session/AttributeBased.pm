package POE::Session::AttributeBased;

use warnings;
use strict;
use POE;
use Attribute::Handlers;
use YAML;

=head1 NAME

POE::Session::AttributeBased - POE::Session using attributes marking state handlers

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

    use POE;
    use base 'POE::Session::AttributeBased';

    my $foo = POE::Session::AttributeBased->create(
	    heap => {...},
	    args => [....],
	    options => {....},
	);
    ...

    sub _start : state {
	...
    }

=head1 DESCRIPTION

This is early alpha code.  This package wraps POE::Session and permits
use of a 'state' attributes to designate state handlers.

=head1 FUNCTIONS

=head2 create

This is the wrapper around POE::Session.  It takes 'args', 'heap' an
'options' arguments and passes them on to POE::Session. It will 
 ignore 'inline_states', 'package_states', and 'object_states' arguments
and output an anoying warning when it sees these.  
The session it creates gets it's state handlers from the package where it
was called. Or from a 'package=>' option.  It'll throw a lethal exception
if package=>arg has no state attribute subroutines.

=cut

# a place to keep handlers for each package using this
my %State;

BEGIN {
    %State = (
    );
}

sub create {
    my $class = shift;

    my %passed = @_;
    my %arg;

    my $package = $passed{package};
    $package ||= (caller)[0];

    # make arg list to be passed to create
    for (qw(args heap options)) {
        $arg{$_} = $passed{$_} if ( exists $passed{$_} );
    }

    # warn about using traditional POE::Session state table
    for (qw(inline_states package_states object_states)) {
	warn "$package ignores $_" if (exists $passed{$_});
    }

    if ( not exists $State{$package} ) {
        die "no states for package $package";
    }

    POE::Session->create( %arg, inline_states => $State{$package} );
}


=head2 state 

The attribute handler

=cut

sub state : ATTR(CODE) {
    my ( $package, $symbol, $code, $attribute, $data ) = @_;

    $State{$package}{ *{$symbol}{NAME} } = $code;
}

=head1 AUTHOR

Chris Fedde, C<< <cfedde at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-poe-session-attributes at rt.cpan.org>, or through the web interface at
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

Copyright 2006 Chris Fedde, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of POE::Session::AttributeBased
