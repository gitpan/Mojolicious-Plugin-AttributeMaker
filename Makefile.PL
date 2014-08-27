use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Mojolicious::Plugin::AttributeMaker',
    AUTHOR           => q{"Evgeniy Vansevich" <"hammer@cpan.org">},
    VERSION_FROM     => 'lib/Mojolicious/Plugin/AttributeMaker.pm',
    ABSTRACT_FROM    => 'lib/Mojolicious/Plugin/AttributeMaker.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Mojolicious' => 3
    },
    PREREQ_PM => {
    
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Mojolicious-Plugin-AttributeMaker-*' },
);
