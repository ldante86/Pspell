#!/bin/bash -

VERBOSE=0
INPUT=

while (( $# > 0 ))
do
	case $1 in
		-v) VERBOSE=1
		;;
		'') :
		;;
		*) INPUT="$1"
	esac
	shift
done

case $VERBOSE in
	1) perl -MPspell -e 'Pspell::pspell_main(-v, @ARGV)' "$INPUT"
	;;
	0) perl -MPspell -e 'Pspell::pspell_main(@ARGV)' "$INPUT"
	;;
esac
