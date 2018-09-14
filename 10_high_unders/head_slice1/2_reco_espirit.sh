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

$BART ecalib -m1 ${DATA}_${US} sens_m1_${US} > /dev/null


$BART pics -d$DEBUG -S -r0.001 ${DATA}_${US} sens_m1_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
$BART rss 1024 $out/r_mm_{,abs_}${US}
$CFL2PNG $CFLCOMMON $out/r_mm_abs_${US} $out/r_mm_${US}.png

rm sens_m1_${US}.{cfl,hdr}
