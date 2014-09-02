#!perl

use Mojo::Base -strict;
use FindBin qw/$Bin/;
use lib "$FindBin::Bin/lib";
use lib "$FindBin::Bin/../lib";

use Test::More;
use Test::Mojo;
use Data::Dumper;
my $t = Test::Mojo->new('TestApp');
my $urls = Mojolicious::Plugin::AttributeMaker::config()->{urls};
foreach ( @{ $t->app->routes->children } ) {
    $t->get_ok( $_->to_string )->status_is(200)->content_like(qr/$urls->{$_->to_string}->{attr}/i);
}
done_testing();
