#!/bin/bash
set -euo pipefail
# brace expand
set -B

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh
out=reco_ESPIRiT

for US in "${USs[@]}"
do

	# apply undersampling
	bart fmac data/slice-full data/pat_$US ${DATA}_$US

	DEBUG=4
	MAPS=2

	bart ecalib -m1 ${DATA}_${US} sens_m1_${US} > /dev/null


	bart pics -d$DEBUG -S -r0.001 ${DATA}_${US} sens_m1_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
	bart rss 1024 $out/r_mm_{,abs_}${US}

	rm sens_m1_${US}.{cfl,hdr}
done
