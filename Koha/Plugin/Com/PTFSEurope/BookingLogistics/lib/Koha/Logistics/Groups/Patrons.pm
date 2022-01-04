package Koha::Logistics::Groups::Patrons;

use Modern::Perl;

use base qw(Koha::Objects);

=head1 NAME

Koha::Logistics::Groups::Patron - Koha Logistics Groups Patron Object class

=head1 API

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsGroupPatron';
}

=head3 object_class

=cut

sub object_class {
    return 'Koha::Logistics::Groups::Patron';
}

1;
