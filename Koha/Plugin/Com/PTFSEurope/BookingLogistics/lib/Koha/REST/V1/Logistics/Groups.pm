package Koha::REST::V1::Logistics::Groups;

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
          Koha::Logistics::Groups->find( $c->validation->param('id') );
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
        my $logistics_group = Koha::Logistics::Group->new_from_api( $c->validation->param('body') );
        $logistics_group->store;
        $c->res->headers->location( $c->req->url->to_string . '/' . $logistics_group->id );
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

    my $logistics_group = Koha::Logistics::Groups->find( $c->validation->param('id') );

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

    my $logistics_group = Koha::Logistics::Groups->find( $c->validation->param('id') );
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

1;
