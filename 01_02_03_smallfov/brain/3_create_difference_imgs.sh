#!/usr/bin/env bash
source ../../BART.sh
source opts.sh
set -euo pipefail

out="$1"

# brace expand
set -B

difflist=()
# reference to fully sampled
for ((m=1; m<=$COMP_MAPS; m++))
do
    # dim 11 is empty:
    $BART rss 2048 $out/r_mm_${m} $out/tmp_r_mm
    difflist[$(($m-1))]=$out/diff_r_mm_${m}
    $BART saxpy -- -1. $REF $out/tmp_r_mm $out/diff_r_mm_${m}
    rm $out/tmp_r_mm.*
done

$BART join 4 ${difflist[@]} tmp_joined_diff

$CFL2PNG $CFLCOMMON -u0.2 tmp_joined_diff $out/diff_r_mm
rm tmp_joined_diff.*
