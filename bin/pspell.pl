#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

if ( @ARGV and "$ARGV[0]" eq "-h" ) {
    die "Usage: pspell.pl [-v] [-h] [word] [file]\n";
}

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname( dirname abs_path $0) . '/lib';

use Pspell;
pspell_main(@ARGV);

__END__
