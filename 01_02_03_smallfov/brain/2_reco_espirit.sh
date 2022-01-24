#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
		echo "\$TOOLBOX_PATH is not set correctly!" >&2
			exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"

source opts.sh

out=reco_ESPIRiT
[ -d $out ] || mkdir $out

bart ecalib -m1 $DATA sens_m1 > /dev/null
{ time taskset -c 0 bart ecalib  -m$MAPS $DATA sens_m2; } >$out/log_r_mmu_2 2>$out/timelog_r_mmu_2

DEBUG=4
# brace expand
set -B

bart pics -d$DEBUG -S -r0.001 ${DATA} sens_m1 $out/r_mm_1 >$out/log_r_mm_1

{ time taskset -c 0 bart pics -d$DEBUG -S -r0.001 ${DATA} sens_m2 $out/r_mmu_2; } >>$out/log_r_mmu_2 2>>$out/timelog_r_mmu_2

bart rss 16 $out/r_mmu_2 $out/r_mm_2

rm sens_m{1,2}.{cfl,hdr}
