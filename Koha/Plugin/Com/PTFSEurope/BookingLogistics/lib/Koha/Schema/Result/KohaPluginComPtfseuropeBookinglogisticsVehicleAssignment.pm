use utf8;
package Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_com_ptfseurope_bookinglogistics_vehicle_assignments>

=cut

__PACKAGE__->table("koha_plugin_com_ptfseurope_bookinglogistics_vehicle_assignments");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 vehicle_type_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 group_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "vehicle_type_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "group_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

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

=head2 vehicle_type

Type: belongs_to

Related object: L<Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleType>

=cut

__PACKAGE__->belongs_to(
  "vehicle_type",
  "Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleType",
  { id => "vehicle_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-12-23 12:22:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:a4dJce/6gT3UOo1Cjez8HQ

sub koha_object_class {
    'Koha::Logistics::Vehicles::Assignement';
}

sub koha_objects_class {
    'Koha::Logistics::Vehicles::Assignements';
}


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
