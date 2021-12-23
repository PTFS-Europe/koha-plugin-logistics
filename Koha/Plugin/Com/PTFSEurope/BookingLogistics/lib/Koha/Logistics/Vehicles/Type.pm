package Koha::Logistics::Vehicles::Type;

use Modern::Perl;

use base qw(Koha::Object);

=head1 NAME

Koha::Logistics::Vehicles::Type - Koha Logistics Vehicles  Type Object class

=head1 API

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsVehiclesTypes';
}

1;
