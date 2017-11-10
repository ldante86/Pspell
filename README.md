# Pspell version 0.01

## NAME

**Pspell** - a rudimentary spell checker. Usable, but still in development.

## PLATFORM

Linux/UNIX.

## SYNOPSIS

```
use Pspell;
pspell_main(@ARGV);
```

- If the argument is a file, the file will be processed.
- If the argument is not a file, it is treated as a word and spell checked.
- If there are no arguments, the program will read from standard input.

## OUTPUT

Only on a misspelling will anything be printed to standard output. Output is is the form of:

```
on line: 308 'htat' not found
...
    Number of misspellings: 5
```

## NOTES

There is a lot still to do. So far, **Pspell** can only:

- report a misspelled word, not correct it,
- ignore email addresses,
- ignore words that are all numbers,
- ignorantly ignores punctuation.

It will take a lot of regex parsing and grepping to make this a usable command-line, script tool.

## INSTALLATION

To install this module type the following:

```
perl Makefile.PL
make
make test
make install
```

## COPYRIGHT AND LICENCE

Copyright (C) 2017 by **Luciano Dante Cecere** [ldante1986@gmail.com](mailto:ldante1986@gmail.com)

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.22.1 or, at your option, any later version of Perl 5 you may have available.
