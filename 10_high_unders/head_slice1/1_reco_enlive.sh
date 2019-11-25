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

# regular
{ time bart nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS ${DATA}_${US} $out/r_mmu_${US}; } \
	>$out/log_r_mmu_${US} 2>$out/timelog_r_mmu_${US}
cfl2png $CFLCOMMON $out/r_mmu_${US}{,.png}

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS ${DATA}_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
cfl2png $CFLCOMMON $out/r_mm_${US}{,.png}
