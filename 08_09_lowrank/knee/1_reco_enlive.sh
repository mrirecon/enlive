#!/bin/bash
set -euo pipefail
set -B

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH
export BART_COMPAT_VERSION="v0.4.04"

source opts.sh
out=reco_ENLIVE
mkdir -p $out

GET_DATA

for USind in "${!VALS[@]}";
do
	USval=${VALS[$USind]}

	if [ $USind -eq 0 ]; then
	        TASKSET="taskset -c 0"
		export OMP_NUM_THREADS=1
	else
        	TASKSET=''
	fi

	PREP $USval

	US=$(GET_US $USval)

	DEBUG=4
	MAPS=2

	# regular
	{ $TASKSET time bart nlinv -d$DEBUG -m$MAPS -U $NLINV_OPTS ${DATA}_${US} $out/r_mmu_${US}; } \
		>$out/log_r_mmu_${US} 2>$out/timelog_r_mmu_${US}

	bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS ${DATA}_${US} $out/r_mm_${US} >$out/log_r_mm_${US}

	bart nlinv -d$DEBUG -m1 $NLINV_OPTS ${DATA}_${US} $out/{r,s}_sm_${US} >$out/log_r_sm_${US}
done
