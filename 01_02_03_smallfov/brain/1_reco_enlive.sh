#!/usr/bin/env bash
source ../../BART.sh
source opts.sh

set -euo pipefail

out=$1
[ -d $1 ] || mkdir $out

DEBUG=4

# brace expand
set -B

for ((m=1; m<=$COMP_MAPS; m++))
do
    $BART nlinv -d$DEBUG -m$m $NLINV_OPTS $DATA $out/r_mm_${m} >$out/log_r_mm_${m} 2>&1
    $CFL2PNG $CFLCOMMON $out/r_mm_${m}{,.png}

    if [ "$m" -ne "$COMP_MAPS" ]
    then
        $BART nlinv -d$DEBUG -m$m -U $NLINV_OPTS $DATA $out/r_mmu_${m} >/dev/null 2>&1
	if [ "$m" -eq "2" ]
	then
		$CFL2PNG $CFLCOMMON $out/r_mmu_${m}{,.png}
	fi
    else
        $BART nlinv -d$DEBUG -m$m -U $NLINV_OPTS $DATA $out/{r,s}_mmu_${m} >/dev/null 2>&1
        $CFL2PNG $CFLCOMMON $out/r_mmu_${m}{,.png}
        $CFL2PNG $CFLCOMMON -u0.60 -CG $out/s_mmu{_${m},.png}
    fi
done
