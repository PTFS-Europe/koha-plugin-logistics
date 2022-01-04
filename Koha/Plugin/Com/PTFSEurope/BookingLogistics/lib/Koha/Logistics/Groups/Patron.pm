package Koha::Logistics::Groups::Patron;

use Modern::Perl;

use base qw(Koha::Object);

=head1 NAME

Koha::Logistics::Groups::Patron - Koha Logistics Groups Patron Object class

=head1 API

=head2 Class Methods

=head3 patron

  my $patron = $stage->patron;

Koha::Patron relationship

=cut

sub patron {
    my ($self) = @_;

    return &{$self->_relation(qw/ patron Patron /)};
}

=head3 siblings

  my $siblings = $stage->siblings;

Koha::Object wrapper around DBIx::Class::Ordered.

=cut

sub siblings {
    my ( $self ) = @_;
    return &{$self->_relation(qw/ siblings Logistics::Groups::Patrons /)};
}

=head3 next_siblings

  my $next_siblings = $stage->next_siblings;

Koha::Object wrapper around DBIx::Class::Ordered.

=cut

sub next_siblings {
    my ( $self ) = @_;
    return &{$self->_relation(qw/ next_siblings Logistics::Groups::Patrons /)};
}

=head3 previous_siblings

  my $previous_siblings = $stage->previous_siblings;

Koha::Object wrapper around DBIx::Class::Ordered.

=cut

sub previous_siblings {
    my ( $self ) = @_;
    return &{$self->_relation(qw/ previous_siblings Logistics::Groups::Patrons /)};
}

=head3 next_sibling

  my $next = $stage->next_sibling;

Koha::Object wrapper around DBIx::Class::Ordered.

=cut

sub next_sibling {
    my ( $self ) = @_;
    return &{$self->_relation(qw/ next_sibling Logistics::Groups::Patron /)};
}

=head3 previous_sibling

  my $previous = $stage->previous_sibling;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub previous_sibling {
    my ( $self ) = @_;
    return &{$self->_relation(qw/ previous_sibling Logistics::Groups::Patron /)};
}

=head3 first_sibling

  my $first = $stage->first_sibling;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub first_sibling {
    my ( $self ) = @_;
    return &{$self->_relation(qw/ first_sibling Logistics::Groups::Patron /)};
}

=head3 last_sibling

  my $last = $stage->last_sibling;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub last_sibling {
    my ( $self ) = @_;
    return &{$self->_relation(qw/ last_sibling Logistics::Groups::Patron /)};
}

=head3 move_previous

  1|0 = $stage->move_previous;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub move_previous {
    my ( $self ) = @_;
    return $self->_result->move_previous;
}

=head3 move_next

  1|0 = $stage->move_next;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub move_next {
    my ( $self ) = @_;
    return $self->_result->move_next;
}

=head3 move_first

  1|0 = $stage->move_first;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub move_first {
    my ( $self ) = @_;
    return $self->_result->move_first;
}

=head3 move_last

  1|0 = $stage->move_last;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub move_last {
    my ( $self ) = @_;
    return $self->_result->move_last;
}

=head3 move_to

  1|0 = $stage->move_to($position);

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub move_to {
    my ( $self, $position ) = @_;
    return $self->_result->move_to($position)
        if ( $position le $self->group->stockrotationstages->count );
    return 0;
}

=head3 move_to_group

  1|0 = $stage->move_to_group($group_id, [$position]);

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub move_to_group {
    my ( $self, $group_id, $position ) = @_;
    return $self->_result->move_to_group($group_id, $position);
}

=head3 delete

  1|0 = $stage->delete;

Koha::Object Wrapper around DBIx::Class::Ordered.

=cut

sub delete {
    my ( $self ) = @_;
    return $self->_result->delete;
}


=head2 Internal methods

=head3 _type

=cut

sub _type {
    return 'KohaPluginComPtfseuropeBookinglogisticsGroupPatron';
}

sub _relation {
    my ( $self, $method, $type ) = @_;
    return sub {
        my $rs = $self->_result->$method;
        return 0 if !$rs;
        my $namespace = 'Koha::' . $type;
        return $namespace->_new_from_dbic( $rs );
    }
}

1;
