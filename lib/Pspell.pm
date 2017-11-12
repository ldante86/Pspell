package Pspell;

use strict;
use warnings;
use 5.010;
use Scalar::Util qw(looks_like_number);

require Exporter;

our @ISA     = qw(Exporter);
our @EXPORT  = qw(pspell_main);
our $VERSION = '0.01';

our %words        = ();
our $misspellings = 0;
our $dict_path    = "/usr/share/dict";
our @dict_list    = ();
our $dict;

sub pspell_main {
    my ( $opt, $input ) = (@_);
    my ( @line, $ln, $verbose ) = ( (), 0, 0 );

    if ( $opt and "$opt" eq "-v" and ( not $input ) ) {
        $verbose = 1;
    }
    elsif ( $opt and "$opt" eq "-v" and $input ) {
        $verbose = 1;
    }
    elsif ( $opt and ( not $input ) ) {
        $input = $opt;
    }

    if ( not $input ) {
        load_dictionary();
        spell_check_interactive($verbose);
    }
    elsif ( open( my $file, '<:encoding(UTF-8)', "$input" ) ) {
        load_dictionary();
        while ( my $line = <$file> ) {
            chomp($line);
            $ln++;
            next if ( not $line );
            @line = split( /\s+/, $line );
            for my $w (@line) {
                next if ( not $w );
                spell_check( $w, $ln, $verbose );
            }
        }
        print "\n\tNumber of misspellings: $misspellings\n\n"
            if ( $misspellings and $verbose );
    }
    else {
        load_dictionary();
        spell_check( "$input", 0, $verbose );
    }
}

sub load_dictionary {
    my $prob = 0;
    if ( -d $dict_path ) {
        chdir("$dict_path") or die "Cannot cd to $dict_path: $!\n";
        my @files = <*>;
        foreach my $file (@files) {
            if ( -l $file ) {
                push @dict_list, "$file";
            }
        }
        if ( not @dict_list ) {
            foreach my $file (@files) {
                if ( -f $file ) {
                    push @dict_list, "$file";
                }
            }
        }
        if ( not @dict_list ) {
            $prob = 1;
            warn "Cannot locate any dictionaries in $dict_path: $!\n";
        }
    }
    else {
        $prob = 1;
        warn "$dict_path cannot be found: $!\n";
    }

    if ($prob) {
        print "\nWord-list directory?: ";
        chomp( $dict_path = <STDIN> );
        load_dictionary();
    }

    $dict = $dict_list[0];

    my ( $words, $lines, @long ) = ( 0, 0, () );
    open( DICTIONARY, "$dict" )
        or die "Cannot open \'$dict\' for reading: $!\n";

    while ( my $line = <DICTIONARY> ) {
        $lines++;
        $words += scalar( split( /\s+/, $line ) );
    }
    if ( $lines != $words ) {
        close(DICTIONARY);
        die "\'$dict\' doesn't seem to be a word list: $!\n";
    }
    close(DICTIONARY);

    open( DICTIONARY, "$dict" )
        or die "Cannot open \'$dict\' for reading: $!\n";

    while ( my $line = <DICTIONARY> ) {
        chomp($line);
        $words{ lc "$line" } = 0;
    }
    close(DICTIONARY);
}

sub spell_check_interactive {
    my $verbose = $_[0];
    if ($verbose) {
        print "using: $dict_path/$dict\n\n";
        print "word: ";
    }

    while ( chomp( my $search = <STDIN> ) ) {
        next if ( not $search );
        $search = parse_word($search);
        if ( $search eq 1 ) {
            print "ok\n\nword: ";
            next;
        }
        my $found = 0;
        if ( exists( $words{ lc $search } ) ) {
            $found = 1;
        }
        if   ( not $found ) { print "not found\n\n" }
        else                { print "ok\n\n" }

        print "word: " if ($verbose);
    }
}

sub spell_check {
    my ( $search, $ln, $verbose ) = (@_);

    return if ( not $search );
    $search = parse_word($search);
    return if ( $search eq 1 );

    my $found = 0;
    if ( exists( $words{ lc $search } ) ) {
        $found = 1;
    }
    if ( not $found ) {
        $misspellings++;
        if ( $ln > 0 and $verbose ) {
            print "on line: $ln: ";
        }
        if ($verbose) {
            print "\'$search\' not found\n";
        }
        else {
            print "$search\n";
        }
    }
}

sub parse_word {
    my $word = $_[0];

    # There are so many spelling conventions to consider.

    # Email address
    return 1 if ( $word =~ /^[^@]+@+[^\.]+\.+[^\.]{2,6}$/ );

    # Ignore numbers
    if ( looks_like_number($word) ) {
        return 1;
    }

    # Ignore hyphenated words.
    return 1 if ( $word =~ '\b\w+(-\w+)+\b' );

    # For now just get rid of all punctuation
    return 1 if ( $word =~ s/(?!\')[[:punct:]]//g );

    # Ignore possessive plural'
    if ( substr( $word, -1 ) eq "'" ) {
        chop($word);
        return 1;
    }

    $word;
}

1;

__END__

=head1 NAME

Pspell - A spell checker.

=head1 SYNOPSIS

    use Pspell;
    pspell_main(@ARGV);

    pspell_main(-v, "word");

If the first argument is B<-v>, print verbose output.

If the argument is a file, the file will be processed.

If the argument is not a file, is is treated as a word and spell checked.

If there are no arguments, the program will read from standard input.

=head1 OUTPUT

Verbose output is is the form of:

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
