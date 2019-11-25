#!/bin/bash
set -e

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH


#dataset: same as in Uecker_Magn.Reson.Med._2014

bart fmac data/alias data/pat data/unders

# create reference
bart fft -u -i 7 data/alias data/tmp
bart rss 8 data/tmp data/ref
rm data/tmp.*

