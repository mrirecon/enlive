#!/usr/bin/env bash
source ../../BART.sh
source opts.sh

set -euo pipefail
# brace expand
set -B

out=$1
US=$(GET_US $2)

DEBUG=4
MAPS=2

export OMP_NUM_THREADS=1

# regular
{ time $BART nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS ${DATA}_${US} $out/r_mmu_${US}; } \
	>$out/log_r_mmu_${US} 2>$out/timelog_r_mmu_${US}
$CFL2PNG $CFLCOMMON $out/r_mmu_${US}{,}

$BART nlinv -d$DEBUG -m$MAPS $NLINV_OPTS ${DATA}_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
$CFL2PNG $CFLCOMMON $out/r_mm_${US}{,}

$BART nlinv -d$DEBUG -m1 $NLINV_OPTS ${DATA}_${US} $out/{r,s}_sm_${US} >$out/log_r_sm_${US}
$CFL2PNG $CFLCOMMON $out/r_sm_${US}{,}
$CFL2PNG -C Y $CFLCOMMON $out/r_sm_${US} $out/r_sm_phase_${US}.png
