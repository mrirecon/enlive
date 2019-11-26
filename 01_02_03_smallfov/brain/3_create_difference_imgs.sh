#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh

out=reco_ENLIVE

# brace expand
set -B

difflist=()
# reference to fully sampled
for ((m=1; m<=$COMP_MAPS; m++))
do
    # dim 11 is empty:
    bart rss 2048 $out/r_mm_${m} $out/tmp_r_mm
    difflist[$(($m-1))]=$out/diff_r_mm_${m}
    bart saxpy -- -1. $REF $out/tmp_r_mm $out/diff_r_mm_${m}
    rm $out/tmp_r_mm.*
done

bart join 4 ${difflist[@]} tmp_joined_diff

cfl2png $CFLCOMMON -u0.2 tmp_joined_diff $out/diff_r_mm
rm tmp_joined_diff.*
