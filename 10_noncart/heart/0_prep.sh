#!/usr/bin/env bash
source ../../BART.sh
source opts.sh
set -euo pipefail
set -B

#if false; then
#	# generate undersampled data
#	# T6439, sl2, 21-25
#	RAW=/home/ague/archive/2016/2016-08-30_Sequence_bSSFP/T006439/T006439_raw.coo
#	$BART extract 11 2 2 $RAW data/tmp
#	$BART extract 10 21 25 data/tmp{,2}
#	$BART transpose 2 10 data/tmp{2,}
#	$BART circshift 2 4 data/tmp{,2}
#	$BART reshape 6 $NSPK 1 data/tmp{2,}
#	$BART transpose 1 2 data/tmp{,2}
#	$BART transpose 0 1 data/tmp2 data/unders
#fi

$BART traj -x$NSMPL -y$NSPK -t5 -D data/traj_uncorr

# gradient delays
GD=$($BART estdelay data/traj_uncorr data/unders)

$BART traj -x$NSMPL -y$NSPK -t5 -D -q${GD} data/tmp
$BART reshape 12 13 5 data/tmp{,2}
$BART circshift 3 3 data/tmp{2,}
$BART reshape 12 $NSPK 1 data/tmp data/traj

S=$(echo "scale=0;"$NSMPL"*"$OG"/1" | bc -l)

$BART scale $OG data/traj data/traj_scaled

# grid data
SCALE=$(echo "scale=5;1./"$NSPK | bc -l)
$BART nufft -d$S:$S:1 -a data/traj_scaled data/unders data/tmp_grid > /dev/null
$BART fft -u 7 data/tmp_grid data/tmp
$BART scale $SCALE data/tmp data/grid


$BART ones 3 1 $NSMPL $NSPK data/tmp_o
$BART nufft -d$S:$S:1 -a data/traj_scaled data/tmp_o data/tmp > /dev/null
$BART fft -u 7 data/tmp{,2}
$BART scale $SCALE data/tmp2 data/psf
rm data/tmp*.{cfl,hdr}
