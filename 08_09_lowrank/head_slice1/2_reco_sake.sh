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
out=reco_SAKE
mkdir -p $out

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

	set +e
	{ $TASKSET time bart sake -i${SAKE_ITER} -s0.05 ${DATA}_${US} $out/tmp_sake_ksp_${US}; } \
		> $out/log_sake_${US}.log 2> $out/timelog_sake_${US}.log
	ES=$?
	if [ "$ES" -ne 0 ]; then
		echo "Error running Sake!" >&2
		cat $out/timelog_sake_${US}.log >&2
		exit "$ES"
	fi
	set -e

	bart fft -u -i 7 $out/tmp_sake_ksp_${US} $out/tmp_sake_${US}
	bart rss 8 $out/tmp_sake_${US} $out/r_sake_${US}
	rm $out/tmp_sake{,_ksp}_${US}*
done


