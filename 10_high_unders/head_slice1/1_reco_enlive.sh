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
out=reco_ENLIVE
mkdir -p $out

for US in "${USs[@]}"
do
	if false; then
		./gen_pattern.py $ACS $US
	fi

	# apply undersampling
	bart fmac data/slice-full data/pat_$US ${DATA}_$US

	DEBUG=4
	MAPS=2

	# regular
	{ time bart nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS ${DATA}_${US} $out/r_mmu_${US}; } \
		>$out/log_r_mmu_${US} 2>$out/timelog_r_mmu_${US}

	bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS ${DATA}_${US} $out/r_mm_${US} >$out/log_r_mm_${US}
done
