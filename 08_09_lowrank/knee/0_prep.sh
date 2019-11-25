#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH


if false;
then
	cd data
	wget http://old.mridata.org/knees/fully_sampled/p3/e1/s1/P3.zip
	unzip P3.zip
	cd ..
	
	#extract single slice
	bart fft -u -i 1 data/kspace data/tmp_fft
	bart slice 0 160 data/tmp_fft data/single_slice
fi

bart rss 8 data/single_slice data/tmp_rss
bart threshold -H 21 data/tmp_rss data/tmp_pat
bart pattern data/tmp_pat data/pat
bart fmac data/pat data/single_slice data/tmp_full
#scale maximum to about 1
bart scale 1e-8 data/tmp_full data/full


rm data/tmp_*
