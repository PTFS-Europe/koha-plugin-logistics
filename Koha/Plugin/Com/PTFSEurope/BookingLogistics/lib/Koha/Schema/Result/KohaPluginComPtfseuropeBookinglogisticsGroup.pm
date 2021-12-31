use utf8;
package Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroup

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_com_ptfseurope_bookinglogistics_groups>

=cut

__PACKAGE__->table("koha_plugin_com_ptfseurope_bookinglogistics_groups");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 active

  data_type: 'enum'
  extra: {list => [0,1,2,3,4,5,6]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "active",
  { data_type => "enum", extra => { list => [0 .. 6] }, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 koha_plugin_com_ptfseurope_bookinglogistics_group_patrons

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroupPatron>

=cut

__PACKAGE__->has_many(
  "koha_plugin_com_ptfseurope_bookinglogistics_group_patrons",
  "Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroupPatron",
  { "foreign.group_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 koha_plugin_com_ptfseurope_bookinglogistics_vehicle_assignments

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment>

=cut

__PACKAGE__->has_many(
  "koha_plugin_com_ptfseurope_bookinglogistics_vehicle_assignments",
  "Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment",
  { "foreign.group_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-12-23 12:22:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JGxNqLsZfnE/GpMIk/DeaA

#__PACKAGE__->many_to_many( patrons => 'koha_plugin_com_ptfseurope_bookinglogistics_group_patrons', 'patron' );

__PACKAGE__->has_many(
  "group_patrons",
  "Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroupPatron",
  { "foreign.group_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

#__PACKAGE__->add_relationship( 'patrons', 'Koha::Schema::Result::Borrowers',
#    $condition, $attrs );
#);

sub koha_object_class {
    'Koha::Logistics::Group';
}

sub koha_objects_class {
    'Koha::Logistics::Groups';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
