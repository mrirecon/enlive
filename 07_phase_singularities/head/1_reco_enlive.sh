#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh
out=$1
[ -d $1 ] || mkdir $out

#resized dataset for square pixels

DEBUG=4
MAPS=2
# brace expand
set -B
bart nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS $DATA $out/r_mmu > $out/log_r_mmu
cfl2png $CFLCOMMON $out/r_mmu $out/r_mmu

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS $DATA $out/r_mm >$out/log_r_mm
cfl2png $CFLCOMMON $out/r_mm $out/r_mm

bart nlinv -d$DEBUG -m1 $NLINV_OPTS $DATA $out/{r,s}_sm >$out/log_r_sm
cfl2png $CFLCOMMON $out/r_sm $out/r_sm
cfl2png -C Y $CFLCOMMON $out/r_sm $out/r_sm_phase.png
