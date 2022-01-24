#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"

source opts.sh
out=reco
[ -d $out ] || mkdir $out

#resized dataset for square pixels

DEBUG=4
MAPS=2
# brace expand
set -B

#pattern: 2x undersampling, 24 ref lines
bart fmac data/full data/pat data/unders

bart nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS $DATA $out/r_mmu > $out/log_r_mmu

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS $DATA $out/r_mm >$out/log_r_mm

bart nlinv -d$DEBUG -m1 $NLINV_OPTS $DATA $out/{r,s}_sm >$out/log_r_sm
