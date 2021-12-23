use utf8;
package Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroupPatron;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroupPatron

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_com_ptfseurope_bookinglogistics_group_patrons>

=cut

__PACKAGE__->table("koha_plugin_com_ptfseurope_bookinglogistics_group_patrons");

=head1 ACCESSORS

=head2 patron_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 group_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 position

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "patron_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "group_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "position",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</patron_id>

=item * L</group_id>

=back

=cut

__PACKAGE__->set_primary_key("patron_id", "group_id");

=head1 RELATIONS

=head2 group

Type: belongs_to

Related object: L<Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroup>

=cut

__PACKAGE__->belongs_to(
  "group",
  "Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroup",
  { id => "group_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 patron

Type: belongs_to

Related object: L<Koha::Schema::Result::Borrower>

=cut

__PACKAGE__->belongs_to(
  "patron",
  "Koha::Schema::Result::Borrower",
  { borrowernumber => "patron_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-12-23 12:22:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fjT/XdweSIc9V0i+xesopw
__PACKAGE__->load_components(qw( Ordered ));
__PACKAGE__->position_column('position'); # Our position
__PACKAGE__->grouping_column('group_id'); # Our group_id

sub koha_object_class {
    'Koha::Logistics::Groups::Patron';
}

sub koha_objects_class {
    'Koha::Logistics::Groups::Patrons';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
