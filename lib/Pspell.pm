package Pspell;

use strict;
use warnings;
use 5.010;
use Scalar::Util qw(looks_like_number);

require Exporter;

our @ISA     = qw(Exporter);
our @EXPORT  = qw(pspell_main);
our $VERSION = '0.01';

our $words        = ();
our @words        = ();
our $misspellings = 0;

our $dict_path = "/usr/share/dict";
our @dict_list = ();

sub pspell_main {
    my $input = $_[0];

    my $ln = 0;
    if ( not $input ) {
        load_dictionary();
        spell_check_interactive();
    }
    elsif ( open( my $file, '<:encoding(UTF-8)', "$input" ) ) {
        load_dictionary();
        while ( my $line = <$file> ) {
            chomp($line);
            $ln++;
            next if ( not $line );
            load_line( $line, $ln );
        }
        print "\n\tNumber of misspellings: $misspellings\n"
            if ($misspellings);
    }
    else {
        load_dictionary();
        spell_check( "$input", 0 );
    }
}

sub load_line {
    my ( $l, $ln ) = (@_);
    my @line = split( " ", $l );

    for my $w (@line) {
        if ( not $w ) {
            print "\n";
            return 0;
        }
        spell_check( $w, $ln );
    }
}

sub load_dictionary {
    if ( -e $dict_path ) {
        chdir("$dict_path") or die "Cannot cd to $dict_path\n";
        my @files = <*>;
        foreach my $file (@files) {
            if ( -l $file ) {
                push @dict_list, $file;
            }
        }
    }

    my $dict = $dict_list[0];

    open DICTIONARY, "$dict" or die;
    while ( my $line = <DICTIONARY> ) {
        chomp($line);
        push @words, "$line";
    }
    close DICTIONARY;
}

sub spell_check_interactive {
    print "using: $dict_path/$dict_list[0]\n\n";

    print "word: ";
    while ( chomp( my $search = <STDIN> ) ) {
        next if ( not $search );
        $search = parse_word($search);
        next if ( not $search );
        my $found = 0;
        if ( my @found = grep { $_ eq lc "$search" } @words ) {
            $found = 1;
        }

        if ( not $found ) {
            print "not found\n\n";
        }
        else {
            print "ok\n\n";
        }
        print "word: ";
    }
}

sub spell_check {
    my ( $search, $ln ) = (@_);

    $search = parse_word($search);
    return if ( not $search );

    my $found = 0;
    if ( my @found = grep { $_ eq lc "$search" } @words ) {
        $found = 1;
    }

    if ( not $found ) {
        $misspellings++;
        if ( $ln > 0 ) {
            print "on line: $ln: ";
        }
        print "\'$search\' not found\n";
    }
}

sub parse_word {

    # There are so many spelling conventions to consider.

    my $word = $_[0];

    # Email address
    return 0 if ( $word =~ /^[^@]+@+[^\.]+\.+[^\.]{2,6}$/ );

    # Just numbers
    if ( looks_like_number($word) ) { return 0 }

    # For now just get rid of all punctuation
    $word =~ s/(?!\')[[:punct:]]//g;

    $word;
}

1;

__END__

=head1 NAME

Pspell - A spell checker.

=head1 SYNOPSIS

	use Pspell;
	pspell_main(@ARGV);


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

This library is free software; you can redistribute it and/or modify it under the same
terms as Perl itself, either Perl version 5.22.1 or, at your option, any later version
of Perl 5 you may have available.

=cut
