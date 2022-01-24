#!/bin/bash
set -euo pipefail
# brace expand
set -B


if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"

out=reco_ENLIVE/vcc
mkdir -p $out

source opts.sh
#generate vcc
VCC=data/both
./vcs.sh $UNDERS $VCC

DEBUG=4
MAPS=2

# vcc
bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS -U $VCC $out/r_mmu >$out/log_r_mmu.log

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS $VCC $out/r_mm >$out/log_r_mm.log

bart nlinv -d$DEBUG -m1 $NLINV_OPTS $VCC $out/r_sm >$out/log_r_sm.log
