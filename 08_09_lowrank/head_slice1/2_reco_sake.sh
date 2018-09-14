#!/usr/bin/env bash
set -euo pipefail

source ../../BART.sh
source opts.sh
out=$1
US=$(GET_US $2)



export OMP_NUM_THREADS=1

# brace expand
set -B
{ time $BART sake -i${SAKE_ITER} -s0.05 ${DATA}_${US} $out/tmp_sake_ksp_${US}; } \
	> $out/log_sake_${US}.log 2> $out/timelog_sake_${US}.log
$BART fft -u -i 7 $out/tmp_sake_ksp_${US} $out/tmp_sake_${US}
$BART rss 8 $out/tmp_sake_${US} $out/r_sake_${US}
rm $out/tmp_sake{,_ksp}_${US}*


$CFL2PNG $CFLCOMMON -u${WMAX} $out/r_sake_${US}{,.png}


