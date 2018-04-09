#!/usr/bin/env bash
source ../../BART.sh
source opts.sh
set -euo pipefail
# brace expand
set -B

out=$1
US=$2

DEBUG=4
MAPS=2

# regular
{ time $BART nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS ${DATA}_${US} $out/r_mmu_${US}; } \
	>$out/log_r_mmu_${US} 2>$out/timelog_r_mmu_${US}
$CFL2PNG $CFLCOMMON $out/r_mmu_${US}{,.png}

$BART nlinv -d$DEBUG -m$MAPS $NLINV_OPTS ${DATA}_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
$CFL2PNG $CFLCOMMON $out/r_mm_${US}{,.png}
