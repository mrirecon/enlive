#!/bin/bash
set -e

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"

source opts.sh

set -euo pipefail

out=reco_ENLIVE
[ -d $out ] || mkdir $out

DEBUG=4

# brace expand
set -B

for ((m=1; m<=$COMP_MAPS; m++))
do
    bart nlinv -d$DEBUG -m$m $NLINV_OPTS $DATA $out/r_mm_${m} >$out/log_r_mm_${m} 2>&1

    if [ "$m" -ne "$COMP_MAPS" ]
    then
        bart nlinv -d$DEBUG -m$m -U $NLINV_OPTS $DATA $out/r_mmu_${m} >/dev/null 2>&1
    else
        bart nlinv -d$DEBUG -m$m -U $NLINV_OPTS $DATA $out/{r,s}_mmu_${m} >/dev/null 2>&1
    fi
done
