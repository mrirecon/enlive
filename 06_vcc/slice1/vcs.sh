#!/bin/bash
set -euo pipefail

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

# adapted from:
# https://github.com/mrirecon/vcc-espirit/blob/master/vcc_calib

kspace=$1
out=$2

# brace expand
set -B

# create virtual conjugate channels
bart flip 7 $kspace tmp1
bart circshift 0 1 tmp1 tmp2
bart circshift 1 1 tmp2 tmp1
bart circshift 2 1 tmp1 tmp2
bart conj tmp2 tmp1

bart join 3 $kspace tmp1 $out

# generate VCC PSF
ncoils=$(bart show -d 3 $kspace)
P=${out}_PSF

bart pattern $kspace tmp1
bart flip 7 tmp1 tmp2
bart circshift 0 1 tmp2 tmp1
bart circshift 1 1 tmp1 tmp2
bart circshift 2 1 tmp2 tmp1
bart conj tmp1 tmp2 #PSF for second half of coils
bart pattern $kspace tmp1 # PSF for first half of coils

# join together
bart join 3 $(yes tmp1 | head -n $ncoils) $(yes tmp2 | head -n $ncoils) $P

rm tmp{1,2}.{hdr,cfl}

