package Koha::Logistics::Group;

use Modern::Perl;

use base qw(Koha::Object);

=head1 NAME

Koha::Logistics::Group - Koha Logistics Group Object class

=head1 API

=head2 relations

=head3 patrons

=cut

sub patrons {
    my ($self) = @_;

    my $patrons_rs = $self->_result->search_related(
        'koha_plugin_com_ptfseurope_bookinglogistics_group_patrons',
        {}, { order_by => 'position' } )->search_related('patron');

    return Koha::Patrons->_new_from_dbic($patrons_rs);
}

=head3 assign_patron

  my $link = $item->assign_patron($patron, $position);

Adds the patron passed to this group

=cut

sub assign_patron {
    my ( $self, $patron, $position ) = @_;

    return Koha::Logistics::Groups::Patron->new(
        {
            group_id  => $self->id,
            patron_id => $patron->borrowernumber,
            position  => $position
        }
    )->store;
}

=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsGroup';
}

1;
