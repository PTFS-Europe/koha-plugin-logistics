use utf8;
use v5.10;

package Koha::Plugin::Com::PTFSEurope::BookingLogistics;

=head1 NAME

Koha::Plugin::Com::PTFSEurope::BookingLogistics

=cut

## It's good practice to use Modern::Perl
use Modern::Perl;

## Required for all plugins
use base qw(Koha::Plugins::Base);

use Module::Metadata;
use Koha::Schema;
BEGIN {
    my $path = Module::Metadata->find_module_by_name(__PACKAGE__);
    $path =~ s!\.pm$!/lib!;
    unshift @INC, $path;

    require Koha::Logistics::Group;
    require Koha::Logistics::Groups;
    require Koha::Logistics::Groups::Patron;
    require Koha::Logistics::Groups::Patrons;
    require Koha::Logistics::Vehicles::Assignment;
    require Koha::Logistics::Vehicles::Assignments;
    require Koha::Logistics::Vehicles::Type;
    require Koha::Logistics::Vehicles::Types;
    require Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroup;
    require Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroupPatron;
    require Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment;
    require Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleType;

    # register the additional schema classes
    Koha::Schema->register_class(
        KohaPluginComPtfseuropeBookinglogisticsGroup =>
          'Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroup'
    );
    Koha::Schema->register_class(
        KohaPluginComPtfseuropeBookinglogisticsGroupPatron =>
          'Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsGroupPatron'
    );
    Koha::Schema->register_class(
        KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment =>
          'Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleAssignment'
    );
    Koha::Schema->register_class(
        KohaPluginComPtfseuropeBookinglogisticsVehicleType =>
          'Koha::Schema::Result::KohaPluginComPtfseuropeBookinglogisticsVehicleType'
    );

    # force a refresh of the database handle so that it includes the new classes
    Koha::Database->schema( { new => 1 } );
}

use JSON::Validator;

## Koha libraries
use C4::Context;
use C4::Output;
use C4::Auth;

use Koha;

## Here we set our plugin version
our $VERSION = "1";

## Here is our metadata, some keys are required, some are optional
our $metadata = {
    name            => 'Booking Logistics',
    author          => 'Martin Renvoize',
    date_authored   => '2021-12-01',
    date_updated    => "2021-12-01",
    minimum_version => '21.11.00.000',
    maximum_version => '21.11.06.000',
    version         => $VERSION,
    description     =>
      'This plugin implements a logistics tool for use with bookings'
};

sub new {
    my ( $class, $args ) = @_;

    ## We need to add our metadata here so our base class can access it
    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    ## Here, we call the 'new' method for our base class
    ## This runs some additional magic and checking
    ## and returns our actual $self
    my $self = $class->SUPER::new($args);

    return $self;
}

sub tool {
    my ( $self, $args ) = @_;

    my $cgi = $self->{'cgi'};

    my $view = $cgi->param('view');
    if ($view) {
        $self->$view;
    }
    else {
        my $template = $self->get_template( { file => 'tool.tt' } );
        my $groups = Koha::Logistics::Groups->new();
        $template->param( no_op_set => 1 );
        $self->output_html( $template->output );
    }
}

sub api_namespace {
    my ($self) = $_;
    return 'logistics';
}

sub api_routes {
    my ($self) = @_;

    my $spec_str = $self->mbf_read('openapi.yaml');
    my $path = $self->bundle_path . "/openapi.yaml";
    my $jv = JSON::Validator->new;
    $jv->schema("file://$path");
    my $spec = $jv->bundle;

    return $spec;
}

sub install {
    my ( $self, $args ) = @_;

    my $groups_table = $self->get_qualified_table_name('groups');
    C4::Context->dbh->do(qq{
        CREATE TABLE IF NOT EXISTS $groups_table (
            `id` INT(11) NOT NULL auto_increment,
            `name` varchar(100) NOT NULL,
            `active` enum('0','1','2','3','4','5','6'),
            PRIMARY KEY (`id`)
        ) ENGINE = INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    });

    my $patrons_link_table = $self->get_qualified_table_name('group_patrons');
    C4::Context->dbh->do(qq{
        CREATE TABLE IF NOT EXISTS $patrons_link_table (
            `patron_id` int(11) NOT NULL,
            `group_id` int(11) NOT NULL,
            `position` int(11) NOT NULL,
            PRIMARY KEY (`patron_id`, `group_id`),
            CONSTRAINT `delivery_groups_fk1` FOREIGN KEY (`patron_id`) REFERENCES `borrowers` (`borrowernumber`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `delivery_groups_fk2` FOREIGN KEY (`group_id`) REFERENCES `$groups_table` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
        ) ENGINE = INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    });

    my $vehicle_types_table = $self->get_qualified_table_name('vehicle_types');
    C4::Context->dbh->do(qq{
        CREATE TABLE IF NOT EXISTS $vehicle_types_table (
            `id` int(11) NOT NULL auto_increment,
            `name` varchar(100) NOT NULL,
            `capacity` int(11) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE = INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    });

    # FIXME: ADD date period assignment handling
    my $vehicles_assignment_table =
      $self->get_qualified_table_name('vehicle_assignments');
    C4::Context->dbh->do(qq{
        CREATE TABLE IF NOT EXISTS $vehicles_assignment_table (
            `id` int(11) NOT NULL auto_increment,
            `vehicle_type_id` int(11) NOT NULL,
            `group_id` int(11) NOT NULL,
            PRIMARY KEY (`id`),
            CONSTRAINT `vehicle_assignments_fk1` FOREIGN KEY (`vehicle_type_id`) REFERENCES `$vehicle_types_table` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `vehicle_assignments_fk2` FOREIGN KEY (`group_id`) REFERENCES `$groups_table` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
        ) ENGINE = INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    });

    return 1;
}

## This is the 'upgrade' method. It will be triggered when a newer version of a
## plugin is installed over an existing older version of a plugin
#sub upgrade {
#    my ( $self, $args ) = @_;
#
#    my $dt = dt_from_string();
#    $self->store_data(
#        { last_upgraded => $dt->ymd('-') . ' ' . $dt->hms(':') } );
#
#    return 1;
#}

## This method will be run just before the plugin files are deleted
## when a plugin is uninstalled. It is good practice to clean up
## after ourselves!
#sub uninstall() {
#    my ( $self, $args ) = @_;
#
#    my $table = $self->get_qualified_table_name('mytable');
#
#    return C4::Context->dbh->do("DROP TABLE $table");
#}

sub _version_check {
    my ( $self, $minversion ) = @_;

    $minversion =~ s/(.*\..*)\.(.*)\.(.*)/$1$2$3/;

    my $kohaversion = Koha::version();

    # remove the 3 last . to have a Perl number
    $kohaversion =~ s/(.*\..*)\.(.*)\.(.*)/$1$2$3/;

    return ( $kohaversion > $minversion );
}

1;
