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
out=$1
US=$2

DEBUG=4
MAPS=2

bart ecalib -m1 ${DATA}_${US} sens_m1_${US} > /dev/null


bart pics -d$DEBUG -S -r0.001 ${DATA}_${US} sens_m1_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
bart rss 1024 $out/r_mm_{,abs_}${US}
cfl2png $CFLCOMMON $out/r_mm_abs_${US} $out/r_mm_${US}.png

rm sens_m1_${US}.{cfl,hdr}
