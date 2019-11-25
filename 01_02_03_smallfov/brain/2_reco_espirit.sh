#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
		echo "\$TOOLBOX_PATH is not set correctly!" >&2
			exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh

out=$1
[ -d $1 ] || mkdir $out

bart ecalib -m1 $DATA sens_m1 > /dev/null
{ time taskset -c 0 bart ecalib  -m$MAPS $DATA sens_m2; } >$out/log_r_mmu_2 2>$out/timelog_r_mmu_2

DEBUG=4
# brace expand
set -B

bart pics -d$DEBUG -S -r0.001 ${DATA} sens_m1 $out/r_mm_1 >$out/log_r_mm_1
cfl2png $CFLCOMMON $out/r_mm_1{,.png}

{ time taskset -c 0 bart pics -d$DEBUG -S -r0.001 ${DATA} sens_m2 $out/r_mmu_2; } >>$out/log_r_mmu_2 2>>$out/timelog_r_mmu_2
cfl2png $CFLCOMMON $out/r_mmu_2{,.png}

bart rss 16 $out/r_mmu_2 $out/r_mm_2
cfl2png $CFLCOMMON $out/r_mm_2{,.png}

rm sens_m{1,2}.{cfl,hdr}
