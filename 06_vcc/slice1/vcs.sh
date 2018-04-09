#!/usr/bin/env bash
set -euo pipefail

# adapted from:
# https://github.com/mrirecon/vcc-espirit/blob/master/vcc_calib

kspace=$1
out=$2
source ../../BART.sh

# brace expand
set -B

# create virtual conjugate channels
$BART flip 7 $kspace tmp1
$BART circshift 0 1 tmp1 tmp2
$BART circshift 1 1 tmp2 tmp1
$BART circshift 2 1 tmp1 tmp2
$BART conj tmp2 tmp1

$BART join 3 $kspace tmp1 $out

# generate VCC PSF
ncoils=$($BART show -d 3 $kspace)
P=${out}_PSF

$BART pattern $kspace tmp1
$BART flip 7 tmp1 tmp2
$BART circshift 0 1 tmp2 tmp1
$BART circshift 1 1 tmp1 tmp2
$BART circshift 2 1 tmp2 tmp1
$BART conj tmp1 tmp2 #PSF for second half of coils
$BART pattern $kspace tmp1 # PSF for first half of coils

# join together
$BART join 3 $(yes tmp1 | head -n $ncoils) $(yes tmp2 | head -n $ncoils) $P

rm tmp{1,2}.{hdr,cfl}

