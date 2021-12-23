package Koha::Logistics::Vehicles::Assignments;

use Modern::Perl;

use base qw(Koha::Objects);

=head1 NAME

Koha::Logistics::Vehicles::Assignments - Koha Logistics Vehicle Assignments Object class

=head1 API

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsVehiclesAssignements';
}

=head3 object_class

=cut

sub object_class {
    return 'Koha::Vehicles::Assignement';
}

1;
