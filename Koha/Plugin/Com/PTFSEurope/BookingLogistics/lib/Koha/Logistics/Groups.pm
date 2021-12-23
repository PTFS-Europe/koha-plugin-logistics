package Koha::Logistics::Groups;

use Modern::Perl;

use base qw(Koha::Objects);

=head1 NAME

Koha::Logistics::Groups - Koha Logistics Groups Object class

=head1 API

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsGroup';
}

=head3 object_class

=cut

sub object_class {
    return 'Koha::Logistics::Group';
}

1;
