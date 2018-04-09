#!/usr/bin/env bash
source ../../BART.sh
source opts.sh
set -euo pipefail
out=$1
[ -d $1 ] || mkdir $out

#resized dataset for square pixels

DEBUG=4
MAPS=2
# brace expand
set -B
$BART nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS $DATA $out/r_mmu > $out/log_r_mmu
$CFL2PNG $CFLCOMMON $out/r_mmu $out/r_mmu

$BART nlinv -d$DEBUG -m$MAPS $NLINV_OPTS $DATA $out/r_mm >$out/log_r_mm
$CFL2PNG $CFLCOMMON $out/r_mm $out/r_mm

$BART nlinv -d$DEBUG -m1 $NLINV_OPTS $DATA $out/{r,s}_sm >$out/log_r_sm
$CFL2PNG $CFLCOMMON $out/r_sm $out/r_sm
$CFL2PNG -C Y $CFLCOMMON $out/r_sm $out/r_sm_phase.png
