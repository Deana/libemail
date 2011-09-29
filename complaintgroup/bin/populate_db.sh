#!/bin/bash

INPUTFILE=$1

if [ -z $INPUTFILE ]; then
	echo "You must supply a list of complaints"
	exit 1
fi

if [ ! -f $INPUTFILE ]; then
	echo "ERROR: $INPUTFILE cannot be found"
	exit 2
fi

if [ -z $CGROOT ]; then
	echo "variable CGROOT is not set"
	exit 3
fi

cat $INPUTFILE  | xargs ${CGROOT}/bin/normalize_email.pl
