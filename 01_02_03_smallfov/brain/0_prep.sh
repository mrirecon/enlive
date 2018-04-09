#!/usr/bin/env bash
source ../../BART.sh

#dataset: same as in Uecker_Magn.Reson.Med._2014

$BART fmac data/alias data/pat data/unders

# create reference
$BART fft -u -i 7 data/alias data/tmp
$BART rss 8 data/tmp data/ref
rm data/tmp.*

