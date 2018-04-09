#!/usr/bin/env bash
source ../../BART.sh
export BART
export CFL2PNG
source opts.sh

set -euo pipefail

export out=$1
[ -d $1 ] || mkdir $out

export SHELL=$(type -p bash)

#resized dataset for square pixels

export DEBUG=4


# maximum of dataset: 
export MAX=15318.6

# brace expand
set -B

export OMP_NUM_THREADS=2
reco()
{
	N=$1
	NOISE=$2
	STD=$(echo "$MAX * $NOISE" | bc -l)
	$BART noise -s$SEED -n$STD data/alias $out/tmp_${N}_${NOISE}

	$BART fmac $out/tmp_${N}_${NOISE} data/pat $out/noisy_${N}_${NOISE}
	
	$BART nlinv -i$N -d$DEBUG $NLINV_OPTS $out/noisy_${N}_${NOISE} $out/r_mm_${N}_${NOISE} > $out/log_r_mm_${N}_${NOISE}
    	$CFL2PNG $CFLCOMMON $out/r_mm_${N}_${NOISE}{,.png}

	rm $out/tmp_${N}_${NOISE}.{cfl,hdr}
	rm $out/noisy_${N}_${NOISE}.{cfl,hdr}
}
export -f reco

nice -n15 parallel reco {} ::: "${NEWTONS[@]}" ::: "${NOISES[@]}"
