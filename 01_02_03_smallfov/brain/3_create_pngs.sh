#!/bin/bash
set -e

if [ ! -e $TOOLBOX_PATH/bart ] ; then
	echo "\$TOOLBOX_PATH is not set correctly!" >&2
	exit 1
fi
export PATH=$TOOLBOX_PATH:$PATH

source opts.sh

set -euo pipefail

# brace expand
set -B

#ENLIVE
out=reco_ENLIVE
for ((m=1; m<=$COMP_MAPS; m++))
do
    cfl2png $CFLCOMMON $out/r_mm_${m}{,.png}

    if [ "$m" -ne "$COMP_MAPS" ]
    then
	if [ "$m" -eq "2" ]
	then
		cfl2png $CFLCOMMON $out/r_mmu_${m}{,.png}
	fi
    else
        cfl2png $CFLCOMMON $out/r_mmu_${m}{,.png}
        cfl2png $CFLCOMMON -u0.60 -CG $out/s_mmu{_${m},.png}
    fi
done


out=reco_ESPIRiT
# brace expand
set -B

cfl2png $CFLCOMMON $out/r_mm_1{,.png}
cfl2png $CFLCOMMON $out/r_mmu_2{,.png}
cfl2png $CFLCOMMON $out/r_mm_2{,.png}


