#!/bin/bash
set -euo pipefail
# brace expand
set -B

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

NONCART_FLAG=""
if bart version -t v0.6.00 ; then
	NONCART_FLAG="-n"
fi

source opts.sh
out=reco
[ -d $out ] || mkdir $out


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

bart traj -x$NSMPL -y$NSSPK -t$NTURN -D data/tmp
bart reshape 1028 $NSPK 1 data/tmp data/traj_uncorr

# gradient delays
GD=$(bart estdelay data/traj_uncorr data/unders)

bart traj -x$NSMPL -y$NSSPK -t$NTURN -D -q${GD} data/tmp
bart circshift 10 3 data/tmp{,2}
bart reshape 1028 $NSPK 1 data/tmp2 data/traj

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



DEBUG=4

#resize to: 
CROP=$(echo "scale=0;"$NSMPL"/2*1.1" | bc -l)
for ((m=1; m<=$COMP_MAPS; m++))
do
    bart nlinv $NONCART_FLAG -d$DEBUG -m$m $NLINV_OPTS $DATA $out/tmp_${m} >$out/log_r_mm_${m} 2>&1
    bart resize -c 0 $CROP 1 $CROP $out/tmp_${m} $out/r_mm_${m}
    bart rss 4096 $out/r_mm_${m} $out/tmp_rss_${m}

    if [ "$m" -eq "$COMP_MAPS" ]
    then
        bart nlinv $NONCART_FLAG -d$DEBUG -m$m -U $NLINV_OPTS $DATA $out/tmp_{r,s}_${m} >/dev/null 2>&1
    	bart resize -c 0 $CROP 1 $CROP $out/tmp_r_${m} $out/r_mmu_${m}
    	bart resize -c 0 $CROP 1 $CROP $out/tmp_s_${m} $out/s_mmu_${m}
	bart rss 4096 $out/r_mmu_${m} $out/tmp_rssu_${m}
    fi
done
