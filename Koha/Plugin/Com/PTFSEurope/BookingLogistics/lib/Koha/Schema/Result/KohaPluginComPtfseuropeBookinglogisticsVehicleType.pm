use utf8;
package Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleType

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<koha_plugin_com_ptfseurope_bookinglogistics_vehicle_types>

=cut

__PACKAGE__->table("koha_plugin_com_ptfseurope_bookinglogistics_vehicle_types");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 capacity

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "capacity",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 koha_plugin_com_ptfseurope_bookinglogistics_vehicle_assignments

Type: has_many

Related object: L<Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment>

=cut

__PACKAGE__->has_many(
  "koha_plugin_com_ptfseurope_bookinglogistics_vehicle_assignments",
  "Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment",
  { "foreign.vehicle_type_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-12-23 12:22:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:t4ILwIBZPSJnnEOocii2qw

sub koha_object_class {
    'Koha::Logistics::Vehicles::Type';
}

sub koha_objects_class {
    'Koha::Logistics::Vehicles::Types';
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
