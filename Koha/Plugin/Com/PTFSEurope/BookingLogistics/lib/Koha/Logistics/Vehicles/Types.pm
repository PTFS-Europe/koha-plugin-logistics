package Koha::Logistics::Vehicles::Types;

use Modern::Perl;

use base qw(Koha::Objects);

=head1 NAME

Koha::Logistics::Vehicles::Types - Koha Logistics Vehicle Types Object class

=head1 API

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsVehiclesTypes';
}

=head3 object_class

=cut

sub object_class {
    return 'Koha::Vehicles::Type';
}

1;
