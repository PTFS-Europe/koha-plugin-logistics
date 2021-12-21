use utf8;

package Koha::Plugin::Com::PTFSEurope::BookingLogistics;

=head1 NAME

Koha::Plugin::Com::PTFSEurope::BookingLogistics

=cut

## It's good practive to use Modern::Perl
use Modern::Perl;

## Required for all plugins
use base qw(Koha::Plugins::Base);

## Koha libraries
use C4::Context;
use C4::Output;
use C4::Auth;

use Koha;

## Here we set our plugin version
our $VERSION = "{VERSION}";

## Here is our metadata, some keys are required, some are optional
our $metadata = {
    name            => 'Logistics Plugin',
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

    my $template = $self->get_template({ file => 'tool.tt' });

    $self->output_html( $template->output() );
}

## This is the 'install' method. Any database tables or other setup that should
## be done when the plugin if first installed should be executed in this method.
## The installation method should always return true if the installation succeeded
## or false if it failed.
sub install {
    my ( $self, $args ) = @_;

    my $table = $self->get_qualified_table_name('');

    return C4::Context->dbh->do( "
        CREATE TABLE IF NOT EXISTS $table (
        ) ENGINE = INNODB;
    " );
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
