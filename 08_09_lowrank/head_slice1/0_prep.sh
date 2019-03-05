#!/usr/bin/env bash
set -euo pipefail

source ../../BART.sh

US=$1

SEED=20869

# VD-PD for total undersampling of $US:
$BART poisson -Y192 -Z192 -y$US -z$US -v -V10 -s$SEED data/tmp_pat_${US} > /dev/null
$BART pattern data/full data/s_${US}
$BART fmac data/tmp_pat_${US} data/s_${US} data/pat_${US}
rm data/tmp_pat_${US}.*

#calculate undersampling
$BART fmac -s 65535 data/s_${US} data/s_${US} data/ns_${US}
$BART fmac -s 65535 data/pat_${US} data/pat_${US} data/npat_${US}
ALL=$($BART show -f "%+f%+fi" data/ns_${US} | cut -f1 -d"." | cut -f2 -d"+")
PAT=$($BART show -f "%+f%+fi" data/npat_${US} | cut -f1 -d"." | cut -f2 -d"+")
rm data/ns_${US}.* data/npat_${US}.* data/s_${US}.*

UNDERS=$(echo "scale=1;"$ALL"/"$PAT | bc -l)

echo $UNDERS > data/undersampling_factor_${US}.txt

source opts.sh
US_NAME=$(GET_US $US)

mv data/pat_${US}.cfl data/pat_${US_NAME}.cfl
mv data/pat_${US}.hdr data/pat_${US_NAME}.hdr
$BART fmac data/full data/pat_${US_NAME} data/unders_${US_NAME}

