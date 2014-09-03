#!perl

package TestApp {
    use Mojo::Base 'Mojolicious';
    use FindBin;

    # This method will run once at server start
    sub startup {
        my $self = shift;

        # Documentation browser under "/perldoc"
        $self->plugin(
            'AttributeMaker',
            {
                controllers => 'TestApp::Controller'
            }
        );
    }
}
our $t;

BEGIN {
    use Mojo::Base -strict;
    use Test::More;
    use Test::Mojo;
    use lib "$FindBin::Bin/../lib";
    $t = Test::Mojo->new('TestApp');
}

package TestApp::Controller::Test {
    use Mojo::Base 'Mojolicious::Controller';

    sub welcome : Local {
        my $self = shift;
        $self->render( text => 'Local' );
    }

    sub welcome1 : Path('test1') {
        my $self = shift;
        $self->render( text => 'Path' );
    }

    sub welcome2 : Path('/test2') {
        my $self = shift;
        $self->render( text => 'Path' );
    }

    sub welcome3 : Global {
        my $self = shift;
        $self->render( text => 'Global' );
    }

    sub welcome4 : Global('test4') {
        my $self = shift;
        $self->render( text => 'Global' );
    }

    sub welcome5 : Global('/test5') {
        my $self = shift;
        $self->render( text => 'Global' );
    }
}

BEGIN {
    my $urls = Mojolicious::Plugin::AttributeMaker::config()->{urls};
    foreach ( @{ $t->app->routes->children } ) {
        $t->get_ok( $_->to_string )->status_is(200)->content_like(qr/$urls->{$_->to_string}->{attr}/i);
    }
    done_testing();
}

__DATA__

