package Koha::Plugin::Com::PTFSEurope::BookingLogistics::REST::V1::Logistics::Groups;

# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

use Modern::Perl;

use Mojo::Base 'Mojolicious::Controller';

use Koha::Patrons;
use Koha::Logistics::Groups;

use Try::Tiny qw( catch try );

=head1 API

=head2 Methods

=head3 list

Controller function that handles retrieving a list of logistics groups

=cut

sub list {
    my $c = shift->openapi->valid_input or return;

    return try {
        my $logistics_groups_set = Koha::Logistics::Groups->new;
        my $logistics_groups     = $c->objects->search($logistics_groups_set);
        return $c->render( status => 200, openapi => $logistics_groups );
    }
    catch {
        $c->unhandled_exception($_);
    };

}

=head3 get

Controller function that handles retrieving a single logistics group

=cut

sub get {
    my $c = shift->openapi->valid_input or return;

    return try {
        my $logistics_group =
          Koha::Logistics::Groups->find( $c->validation->param('group_id') );
        unless ($logistics_group) {
            return $c->render(
                status  => 404,
                openapi => { error => "Logistics::Group not found" }
            );
        }

        return $c->render( status => 200, openapi => $logistics_group->to_api );
    }
    catch {
        $c->unhandled_exception($_);
    }
}

=head3 add

Controller function that handles adding a new logistics group

=cut

sub add {
    my $c = shift->openapi->valid_input or return;

    return try {
        my $logistics_group =
          Koha::Logistics::Group->new_from_api( $c->validation->param('body') );
        $logistics_group->store;
        $c->res->headers->location(
            $c->req->url->to_string . '/' . $logistics_group->id );
        return $c->render(
            status  => 201,
            openapi => $logistics_group->to_api
        );
    }
    catch {
        $c->unhandled_exception($_);
    };
}

=head3 update

Controller function that handles updating an existing logistics group

=cut

sub update {
    my $c = shift->openapi->valid_input or return;

    my $logistics_group =
      Koha::Logistics::Groups->find( $c->validation->param('group_id') );

    if ( not defined $logistics_group ) {
        return $c->render(
            status  => 404,
            openapi => { error => "Object not found" }
        );
    }

    return try {
        $logistics_group->set_from_api( $c->validation->param('body') );
        $logistics_group->store();
        return $c->render( status => 200, openapi => $logistics_group->to_api );
    }
    catch {
        $c->unhandled_exception($_);
    };
}

=head3 delete

Controller function that handles removing an existing logistics group

=cut

sub delete {
    my $c = shift->openapi->valid_input or return;

    my $logistics_group =
      Koha::Logistics::Groups->find( $c->validation->param('group_id') );
    if ( not defined $logistics_group ) {
        return $c->render(
            status  => 404,
            openapi => { error => "Object not found" }
        );
    }

    return try {
        $logistics_group->delete;
        return $c->render(
            status  => 204,
            openapi => q{}
        );
    }
    catch {
        $c->unhandled_exception($_);
    };
}

=head3 get_patrons

Controller function that handles retrieving group's patrons

=cut

sub get_patrons {
    my $c = shift->openapi->valid_input or return;

    my $logistics_group =
      Koha::Logistics::Groups->find( $c->validation->param('group_id') );
    if ( not defined $logistics_group ) {
        return $c->render(
            status  => 404,
            openapi => { error => "Object not found" }
        );
    }

    return try {

        my $patrons_rs = $logistics_group->patrons;
        my $patrons    = $c->objects->search($patrons_rs);
        return $c->render(
            status  => 200,
            openapi => $patrons
        );
    }
    catch {
        $c->unhandled_exception($_);
    };
}

=head3 assign_patron

Controller function that handles adding patrons to this group

=cut

sub assign_patron {
    my $c = shift->openapi->valid_input or return;

    my $group_id        = $c->validation->param('group_id');
    my $logistics_group = Koha::Logistics::Groups->find($group_id);
    if ( not defined $logistics_group ) {
        return $c->render(
            status  => 404,
            openapi => { error => "Logistics group not found" }
        );
    }

    my $patron_id = $c->validation->param('body')->{'patron_id'};
    my $patron    = Koha::Patrons->find( $patron_id );

    unless ($patron) {
        return $c->render(
            status  => 404,
            openapi => { error => "Patron not found" }
        );
    }

    my $position;
    my $after_id = $c->validation->param('body')->{'after'};
    if ($after_id) {
        my $existing_patron = Koha::Logistics::Groups::Patrons->find(
            { patron_id => $after_id, group_id => $group_id } );
        unless ($existing_patron) {
            return $c->render(
                status  => 400,
                openapi => { error => "After patron not found in group" }
            );
        }
        $position = $existing_patron->position + 1;
    }

    return try {
        my $link = $logistics_group->assign_patron( $patron, $position );
        return $c->render(
            status  => 201,
            openapi => $patron
        );
    }
    catch {
        if ( ref($_) eq 'Koha::Exceptions::Object::DuplicateID' ) {
            return $c->render(
                status  => 409,
                openapi => {
                    error => 'Patron is already in group',
                    key   => $_->duplicate_id
                }
            );
        }
        else {
            $c->unhandled_exception($_);
        }
    };
}

1;
