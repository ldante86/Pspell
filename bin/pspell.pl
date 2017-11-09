#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname( dirname abs_path $0) . '/lib';

use Pspell;

pspell_main(@ARGV);

__END__

=head1 NAME

pspell.pl - A spell checker.

=head1 SYNOPSIS

	perl pspell.pl file.txt
	perl pspell.pl word
	perl pspell


If the argument is a file, the file will be processed.

If the argument is not a file, is is treated as a word and spell checked.

If there are no arguments, the program will read from standard input.

=head1 OUTPUT

Only on a misspelling will anything be printed to stanard output.

Output is is the form of:

	on line: 308 'htat' not found

	...

		Number of misspellings: 5

=head1 AUTHOR

Luciano Dante Cecere <ldante1986@gmail.com>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same
terms as Perl itself, either Perl version 5.22.1 or, at your option, any later version
of Perl 5 you may have available.

=cut
