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
US=$(GET_US $2)

DEBUG=4
MAPS=2

export OMP_NUM_THREADS=1

# regular
{ time bart nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS ${DATA}_${US} $out/r_mmu_${US}; } \
	>$out/log_r_mmu_${US} 2>$out/timelog_r_mmu_${US}
cfl2png $CFLCOMMON $out/r_mmu_${US}{,}

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS ${DATA}_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
cfl2png $CFLCOMMON $out/r_mm_${US}{,}

bart nlinv -d$DEBUG -m1 $NLINV_OPTS ${DATA}_${US} $out/{r,s}_sm_${US} >$out/log_r_sm_${US}
cfl2png $CFLCOMMON $out/r_sm_${US}{,}
cfl2png -C Y $CFLCOMMON $out/r_sm_${US} $out/r_sm_phase_${US}.png
