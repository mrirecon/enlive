#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

US=$1

SEED=20869

# VD-PD for total undersampling of $US:
bart poisson -Y192 -Z192 -y$US -z$US -v -V10 -s$SEED data/tmp_pat_${US} > /dev/null
bart pattern data/full data/s_${US}
bart fmac data/tmp_pat_${US} data/s_${US} data/pat_${US}
rm data/tmp_pat_${US}.*

#calculate undersampling
bart fmac -s 65535 data/s_${US} data/s_${US} data/ns_${US}
bart fmac -s 65535 data/pat_${US} data/pat_${US} data/npat_${US}
ALL=$(bart show -f "%+f%+fi" data/ns_${US} | cut -f1 -d"." | cut -f2 -d"+")
PAT=$(bart show -f "%+f%+fi" data/npat_${US} | cut -f1 -d"." | cut -f2 -d"+")
rm data/ns_${US}.* data/npat_${US}.* data/s_${US}.*

UNDERS=$(echo "scale=1;"$ALL"/"$PAT | bc -l)

echo $UNDERS > data/undersampling_factor_${US}.txt

source opts.sh
US_NAME=$(GET_US $US)

mv data/pat_${US}.cfl data/pat_${US_NAME}.cfl
mv data/pat_${US}.hdr data/pat_${US_NAME}.hdr
bart fmac data/full data/pat_${US_NAME} data/unders_${US_NAME}

