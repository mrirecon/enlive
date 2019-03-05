#!/usr/bin/env bash
set -euo pipefail

source ../../BART.sh

if false;
then
	cd data
	wget http://old.mridata.org/knees/fully_sampled/p3/e1/s1/P3.zip
	unzip P3.zip
	cd ..
	
	#extract single slice
	$BART fft -u -i 1 data/kspace data/tmp_fft
	$BART slice 0 160 data/tmp_fft data/single_slice
fi

$BART rss 8 data/single_slice data/tmp_rss
$BART threshold -H 21 data/tmp_rss data/tmp_pat
$BART pattern data/tmp_pat data/pat
$BART fmac data/pat data/single_slice data/tmp_full
#scale maximum to about 1
$BART scale 1e-8 data/tmp_full data/full


rm data/tmp_*
