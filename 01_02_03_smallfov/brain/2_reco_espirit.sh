#!/usr/bin/env bash
set -euo pipefail

source ../../BART.sh
source opts.sh

out=$1
[ -d $1 ] || mkdir $out

$BART ecalib -m1 $DATA sens_m1 > /dev/null
{ time taskset -c 0 $BART ecalib  -m$MAPS $DATA sens_m2; } >$out/log_r_mmu_2 2>$out/timelog_r_mmu_2

DEBUG=4
# brace expand
set -B

$BART pics -d$DEBUG -S -r0.001 ${DATA} sens_m1 $out/r_mm_1 >$out/log_r_mm_1
$CFL2PNG $CFLCOMMON $out/r_mm_1{,.png}

{ time taskset -c 0 $BART pics -d$DEBUG -S -r0.001 ${DATA} sens_m2 $out/r_mmu_2; } >>$out/log_r_mmu_2 2>>$out/timelog_r_mmu_2
$CFL2PNG $CFLCOMMON $out/r_mmu_2{,.png}

$BART rss 16 $out/r_mmu_2 $out/r_mm_2
$CFL2PNG $CFLCOMMON $out/r_mm_2{,.png}

rm sens_m{1,2}.{cfl,hdr}
