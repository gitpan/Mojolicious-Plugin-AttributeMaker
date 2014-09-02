package Mojolicious::Plugin::AttributeMaker::Extension::Routing;
use parent 'Mojolicious::Plugin::AttributeMaker::Extension';

our $VERSION = 0.01;

=head1 NAME

Mojolicious::Plugin::AttributeMaker::Extension::Routing - Catalyst like routing in you Mojolicious app!

=head1 VERSION

Version 0.01

=cut

=head1 ATTRIBUTES

Example app namespace : MyApp
Example app contrioller namespace : MyApp::Controller

=head2 Local

Example:
 
    package Simple;
    sub homepage :Local { ... }
    
    http://*:port/simple/homepage

A local atrribute ignore arguments
=cut

=head2 Path

Example:

    package Simple;
    sub homepage :Path('user_home') { ... }
    
    http://*:port/simple/user_home

A path atrribute has one mandatory argument

=cut

=head2 Global

Example:
    
    sub homepage :Global { ... }
    
    http://*:port/homepage
    
A global action defined in any controller always runs relative to your root.
So the above is the same as:
    
    sub myaction :Path("/homepage") { ... }
   
But if you write this:
    
    sub homepage :Global('/homepage_custom_url') { ... }
    
You will get this result:
    
    http://*:port/homepage_custom_url
    
=cut

__PACKAGE__->make_attribute(
    Local => sub {
        my ( $package, $method, $plugin, $mojo_app, $attrname, $attrdata ) = @_;
        my $controller = _get_controller_name($package);
        my $url        = $plugin->config->{namespace} . $controller . "/" . $method;
        _add_route( $plugin, $controller, $method, $url, $attrname );
    }
);
__PACKAGE__->make_attribute(
    Global => sub {
        my ( $package, $method, $plugin, $mojo_app, $attrname, $attrdata ) = @_;
        my $controller = _get_controller_name($package);
        my $url        = $method;
        if ($attrdata) {
            $url = $attrdata->[0];
        }
        _add_route( $plugin, $controller, $method, $url, $attrname );
    }
);
__PACKAGE__->make_attribute(
    Path => sub {
        my ( $package, $method, $plugin, $mojo_app, $attrname, $attrdata ) = @_;
        my $controller = _get_controller_name($package);
        my $url        = $method;
        my $config     = $plugin->config();
        if ($attrdata) {
            if ( 0 == index( $attrdata->[0], '/' ) ) {
                $url = $config->{namespace} . "" . lc $attrdata->[0];
            }
            else {
                $url = $config->{namespace} . $controller . "/" . $attrdata->[0];
            }
        }
        else {
            warn __PACKAGE__ . " Attribute 'Path' has one mandatory parameter! Please fix: ${package}\n";
            return;
        }
        _add_route( $plugin, $controller, $method, $url, $attrname );
    }
);

sub _get_controller_name($) {
    return ( split( '::', $_[0] ) )[-1];
}

sub _add_route() {
    my $plugin = shift;

    #[ 'Controller', 'Action', 'Url', 'Type' ]
    $_[2] = "/" . $_[2]; # append slash first...may be hack,may be no 
    $_[2] =~ s/\/+/\//g;
    $plugin->config()->{urls}->{ lc $_[2] } = { attr => $_[3], url => lc $_[2] };
    $plugin->config->{app}->routes->route( lc $_[2] )->to( controller => $_[0], action => $_[1] );

    #push @{ _config()->{table} }, [ $_[0], $_[1], lc $_[2], $_[3] ];
}

1;
