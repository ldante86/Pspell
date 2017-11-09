use 5.010;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Pspell',
    VERSION_FROM  => 'lib/Pspell.pm',
    PREREQ_PM     => {},
    ABSTRACT_FROM => 'lib/Pspell.pm',
    AUTHOR        => 'Luciano Dante Cecere <ldante86@gmail.com>',
    LICENSE       => 'perl',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    EXE_FILES     => [qw(bin/pspell.pl)],
);
