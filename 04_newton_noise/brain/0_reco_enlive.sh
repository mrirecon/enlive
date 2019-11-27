#!/bin/bash
set -euo pipefail


if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH


source opts.sh


export out=reco_ENLIVE
[ -d $out ] || mkdir $out

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
	bart noise -s$SEED -n$STD data/alias $out/tmp_${N}_${NOISE}

	bart fmac $out/tmp_${N}_${NOISE} data/pat $out/noisy_${N}_${NOISE}
	
	bart nlinv -i$N -d$DEBUG $NLINV_OPTS $out/noisy_${N}_${NOISE} $out/r_mm_${N}_${NOISE} > $out/log_r_mm_${N}_${NOISE}

	rm $out/tmp_${N}_${NOISE}.{cfl,hdr}
	rm $out/noisy_${N}_${NOISE}.{cfl,hdr}
}
export -f reco

nice -n15 parallel reco {} ::: "${NEWTONS[@]}" ::: "${NOISES[@]}"
