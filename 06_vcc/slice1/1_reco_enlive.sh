#!/bin/bash
set -euo pipefail
# brace expand
set -B


if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

out=$1
mkdir -p $out



source opts.sh
#generate vcc
VCC=data/both
./vcs.sh $UNDERS $VCC
#generate pf vcc
if [ ! -z $PF ];
then
	PF_VCC=data/both_PF
	PSF_PF_VCC=data/both_PF_PSF
	./vcs.sh $PF $PF_VCC
fi

DEBUG=4
MAPS=2

# vcc
mkdir -p $out/vcc
bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS -U $VCC $out/vcc/r_mmu >$out/vcc/log_r_mmu.log

cfl2png $CFLCOMMON $out/vcc/r_mmu{,}

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS $VCC $out/vcc/r_mm >$out/vcc/log_r_mm.log
cfl2png $CFLCOMMON $out/vcc/r_mm{,}

bart nlinv -d$DEBUG -m1 $NLINV_OPTS $VCC $out/vcc/r_sm >$out/vcc/log_r_sm.log

cfl2png $CFLCOMMON $out/vcc/r_sm{,}

#partial fourier vcc
mkdir -p $out/pf_vcc
# generate VCC PSF
bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS -U -P -p$PSF_PF_VCC $PF_VCC $out/pf_vcc/r_mmu >$out/pf_vcc/log_r_mmu.log

cfl2png $CFLCOMMON $out/pf_vcc/r_mmu $out/pf_vcc/r_mmu.png

bart nlinv -d$DEBUG -m$MAPS $NLINV_OPTS -P -p$PSF_PF_VCC $PF_VCC $out/pf_vcc/r_mm >$out/pf_vcc/log_r_mm.log
cfl2png $CFLCOMMON $out/pf_vcc/r_mm $out/pf_vcc/r_mm.png

bart nlinv -d$DEBUG -m1 $NLINV_OPTS -P -p$PSF_PF_VCC $PF_VCC $out/pf_vcc/r_sm >$out/pf_vcc/log_r_sm.log

cfl2png $CFLCOMMON $out/pf_vcc/r_sm $out/pf_vcc/r_sm.png
