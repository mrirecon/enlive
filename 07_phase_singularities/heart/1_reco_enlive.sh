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
[ -d $1 ] || mkdir $out



DEBUG=4

#resize to: 
CROP=$(echo "scale=0;"$NSMPL"/2*1.1" | bc -l)
for ((m=1; m<=$COMP_MAPS; m++))
do
    bart nlinv -d$DEBUG -m$m $NLINV_OPTS $DATA $out/tmp_${m} >$out/log_r_mm_${m} 2>&1
    bart resize -c 0 $CROP 1 $CROP $out/tmp_${m} $out/r_mm_${m}
    bart rss 4096 $out/r_mm_${m} $out/tmp_rss_${m}
    cfl2png $CFLCOMMON $out/tmp_rss_${m} $out/r_mm_${m}.png
    cfl2png -C Y $CFLCOMMON $out/r_mm_${m} $out/r_mm_${m}_phase.png

    if [ "$m" -eq "$COMP_MAPS" ]
    then
        bart nlinv -d$DEBUG -m$m -U $NLINV_OPTS $DATA $out/tmp_{r,s}_${m} >/dev/null 2>&1
    	bart resize -c 0 $CROP 1 $CROP $out/tmp_r_${m} $out/r_mmu_${m}
    	bart resize -c 0 $CROP 1 $CROP $out/tmp_s_${m} $out/s_mmu_${m}
	bart rss 4096 $out/r_mmu_${m} $out/tmp_rss_${m}
	cfl2png $CFLCOMMON $out/tmp_rss_${m} $out/r_mmu_${m}.png
    fi
    rm $out/tmp*_${m}.{cfl,hdr}
done
