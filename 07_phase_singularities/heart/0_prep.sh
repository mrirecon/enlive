#!/bin/bash
set -euo pipefail
set -B

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh

if false; then
	# generate undersampled data

	# TT10740, sl9, 15-20
	DAT=/home/ague/archive/volunteers/2018-09-07_MRT5_ADVM_0004/2018-09-07_SA_BlackHoles/meas_MID00268_FID25607_mpi_rfl40_33ms_SA_mit_VH_20_3.dat
	RAW=data/raw_T10740
	bart twixread -A $DAT $RAW 
	NSPK=$(echo "$NSSPK"*"$NTURN" | bc)
	bart slice 13 07 $RAW data/tmp
	bart extract 10 80 85 data/tmp{,2}
	bart transpose 2 10 data/tmp{2,}
	bart circshift 2 3 data/tmp{,2}

	bart reshape 6 $NSPK 1 data/tmp{2,}
	bart transpose 1 2 data/tmp{,2}
	bart transpose 0 1 data/tmp2 data/unders
fi

NSSPK=15
NTURN=5
NSPK=$(echo "$NSSPK"*"$NTURN" | bc)
NC=$(bart show -d3 data/unders)

bart traj -x$NSMPL -y$NSPK -t5 -D data/traj_uncorr

# gradient delays
GD=$(bart estdelay data/traj_uncorr data/unders)

bart traj -x$NSMPL -y$NSPK -t5 -D -q${GD} data/tmp
bart reshape 12 $NSSPK $NTURN data/tmp{,2}
bart circshift 3 3 data/tmp{2,}
bart reshape 12 $NSPK 1 data/tmp data/traj

S=$(echo "scale=0;"$NSMPL"*"$OG"/1" | bc -l)

bart scale $OG data/traj data/traj_scaled

# grid data
SCALE=$(echo "scale=5;1./"$NSPK | bc -l)
bart nufft -d$S:$S:1 -a data/traj_scaled data/unders data/tmp_grid > /dev/null
bart fft -u 7 data/tmp_grid data/tmp
bart scale 1. data/tmp data/grid

#PSF
bart ones 3 1 $NSMPL $NSPK data/tmp_o
bart nufft -d$S:$S:1 -a data/traj_scaled data/tmp_o data/tmp > /dev/null
bart fft -u 7 data/tmp{,2}
bart scale $SCALE data/tmp2 data/psf
rm data/tmp*.{cfl,hdr}
