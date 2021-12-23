package Koha::Logistics::Vehicles::Assignement;

use Modern::Perl;

use base qw(Koha::Object);

=head1 NAME

Koha::Logistics::Vehicles::Assignement - Koha Logistics Vehicles Assignement Object class

=head1 API

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsVehiclesAssignements';
}

1;
