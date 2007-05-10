use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'POE::Session::AttributeBased',
    AUTHOR              => 'Chris Fedde <cfedde at cpan.org>',
    VERSION_FROM        => 'lib/POE/Session/AttributeBased.pm',
    ABSTRACT_FROM       => 'lib/POE/Session/AttributeBased.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'POE-Session-AttributeBased-*' },
);
