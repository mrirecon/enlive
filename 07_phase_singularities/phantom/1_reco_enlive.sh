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


# prepare initialization for 1 map:
# Technically, this is wrong, as now the first coil is initialized
# with the same data as the image. However, that is what I
# published originally, so it stays:

bart extract 2 0 7 data/init_phan data/init_phan_m1


DEBUG=4
MAPS=2
# brace expand
set -B

bart nlinv -d$DEBUG -m$MAPS -Idata/init_phan -U $NLINV_OPTS $DATA $out/r_mmu > $out/log_r_mmu

bart nlinv -d$DEBUG -m$MAPS -Idata/init_phan $NLINV_OPTS $DATA $out/r_mm >$out/log_r_mm

bart nlinv -d$DEBUG -m1 -Idata/init_phan_m1  $NLINV_OPTS $DATA $out/{r,s}_sm >$out/log_r_sm
