#!/usr/bin/env bash
set -euo pipefail

source ../../BART.sh
source opts.sh
out=$1
US=$(GET_US $2)
if [ $# -gt 2 ]
then
	SAKE_S="$3"
	SUFF="_${SAKE_S}"
else
	SAKE_S=0.125
	SUFF=''
fi



export OMP_NUM_THREADS=1

# brace expand
set -B
{ time $BART sake -i${SAKE_ITER} -s${SAKE_S} ${DATA}_${US} $out/tmp_sake_ksp_${US}${SUFF}; } \
	> $out/log_sake_${US}${SUFF}.log 2> $out/timelog_sake_${US}${SUFF}.log
$BART fft -u -i 7 $out/tmp_sake_ksp_${US}${SUFF} $out/tmp_sake_${US}${SUFF}
$BART rss 8 $out/tmp_sake_${US}${SUFF} $out/r_sake_${US}${SUFF}
rm $out/tmp_sake{,_ksp}_${US}${SUFF}*


$CFL2PNG $CFLCOMMON -u${WMAX} $out/r_sake_${US}${SUFF}{,.png}


