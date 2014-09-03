#!perl
package TestApp {
    use Mojo::Base 'Mojolicious';
    use FindBin;
    use lib "$FindBin::Bin/../lib";
    use lib "$FindBin::Bin/lib";

    BEGIN {

        sub startup {

            my $self = shift;

            $self->plugin(
                'AttributeMaker',
                {
                    controllers => 'TestApp::Controller'
                }
            );
        }
    }

}
our $t;

BEGIN {
    use Mojo::Base -strict;
    use Test::More;
    use Test::Mojo;
    use FindBin;
    use lib "$FindBin::Bin/../lib";
    $t = Test::Mojo->new('TestApp');
}

package TestApp::Controller::Test {
    use Mojo::Base 'Mojolicious::Controller';
    use Mojo::Base -strict;
    use Test::More;
    use Test::Mojo;

    BEGIN {
        __PACKAGE__->make_attribute(
            Test1 => sub {
                my ( $package, $method, $plugin, $mojo_app, $attrname, $attrdata ) = @_;
                is( $attrdata, undef, "No params" );
            }
        );
        __PACKAGE__->make_attribute(
            Test2 => sub {
                my ( $package, $method, $plugin, $mojo_app, $attrname, $attrdata ) = @_;
                is( @$attrdata, 1, "One param" );
            }
        );
        __PACKAGE__->make_attribute(
            Test3 => sub {
                my ( $package, $method, $plugin, $mojo_app, $attrname, $attrdata ) = @_;
                is( @$attrdata, 2, "More param" );
            }
        );
    }

    sub hello1 : Test1 {
    }
    sub hello1_1 : Test1() {
    }
    sub hello1_2 : Test1(   ) {
    }
    sub hello2 : Test2(Simple) {
    }
    sub hello2_1 : Test2('Simple') {
    }
    
    sub hello3 : Test3('First','Second') {
    }
    sub hello3_1 : Test3('First,Second') {
    }
    
};

done_testing();
