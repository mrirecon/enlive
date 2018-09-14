#!/usr/bin/env bash
source ../../BART.sh
source opts.sh
set -euo pipefail
# brace expand
set -B

out=$1
[ -d $1 ] || mkdir $out



DEBUG=4

#resize to: 
CROP=$(echo "scale=0;"$NSMPL"/2*1.1" | bc -l)
for ((m=1; m<=$COMP_MAPS; m++))
do
    $BART nlinv -d$DEBUG -m$m $NLINV_OPTS $DATA $out/tmp_${m} >$out/log_r_mm_${m} 2>&1
    $BART resize -c 0 $CROP 1 $CROP $out/tmp_${m} $out/r_mm_${m}
    $BART rss 4096 $out/r_mm_${m} $out/tmp_rss_${m}
    $CFL2PNG $CFLCOMMON $out/tmp_rss_${m} $out/r_mm_${m}.png
    $CFL2PNG -C Y $CFLCOMMON $out/r_mm_${m} $out/r_mm_${m}_phase.png

    if [ "$m" -eq "$COMP_MAPS" ]
    then
        $BART nlinv -d$DEBUG -m$m -U $NLINV_OPTS $DATA $out/tmp_{r,s}_${m} >/dev/null 2>&1
    	$BART resize -c 0 $CROP 1 $CROP $out/tmp_r_${m} $out/r_mmu_${m}
    	$BART resize -c 0 $CROP 1 $CROP $out/tmp_s_${m} $out/s_mmu_${m}
	$BART rss 4096 $out/r_mmu_${m} $out/tmp_rss_${m}
	$CFL2PNG $CFLCOMMON $out/tmp_rss_${m} $out/r_mmu_${m}.png
    fi
    rm $out/tmp*_${m}.{cfl,hdr}
done
