package Koha::Logistics::Group;

use Modern::Perl;

use base qw(Koha::Object);

=head1 NAME

Koha::Logistics::Group - Koha Logistics Group Object class

=head1 API

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsGroup';
}

1;
