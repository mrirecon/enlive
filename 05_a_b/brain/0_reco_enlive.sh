#!/usr/bin/env bash
set -euo pipefail
# brace expand
set -B

source ../../BART.sh
export BART
export CFL2PNG
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

	$BART nlinv -a$A -b$B -d$DEBUG $NLINV_OPTS data/unders $out/r_mm_${A}_${B} > $out/log_r_mm_${A}_${B}
    	$CFL2PNG $CFLCOMMON $out/r_mm_${A}_${B}{,.png}
}
export -f reco

$BART fmac data/alias data/pat data/unders
nice -n15 parallel reco {} ::: "${As[@]}" ::: "${Bs[@]}"
