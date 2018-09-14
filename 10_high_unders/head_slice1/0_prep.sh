#!/usr/bin/env bash
set -euo pipefail
set -B

source ../../BART.sh
source opts.sh

US=${1}

if false; then
	./gen_pattern.py $ACS $US
fi

# apply undersampling
$BART fmac data/slice-full data/pat_$US ${DATA}_$US


#generate pattern .pngs
$CFL2PNG $CFLCOMMON -IN data/pat_${US}{,.png}

