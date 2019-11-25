#!/bin/bash
set -euo pipefail
set -B

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh

US=${1}

if false; then
	./gen_pattern.py $ACS $US
fi

# apply undersampling
bart fmac data/slice-full data/pat_$US ${DATA}_$US


#generate pattern .pngs
cfl2png $CFLCOMMON -IN data/pat_${US}{,.png}

