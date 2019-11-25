#!/bin/bash
set -euo pipefail
# brace expand
set -B


if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh

export out=$1
[ -d $1 ] || mkdir $out

export SHELL=$(type -p bash)

export DEBUG=4


# maximum of dataset: 
export MAX=15318.6


export OMP_NUM_THREADS=2
reco()
{
	A=$1
	B=$2

	bart nlinv -a$A -b$B -d$DEBUG $NLINV_OPTS data/unders $out/r_mm_${A}_${B} > $out/log_r_mm_${A}_${B}
    	cfl2png $CFLCOMMON $out/r_mm_${A}_${B}{,.png}
}
export -f reco

bart fmac data/alias data/pat data/unders
nice -n15 parallel reco {} ::: "${As[@]}" ::: "${Bs[@]}"
