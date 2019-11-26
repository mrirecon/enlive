#!/bin/bash
set -euo pipefail
# brace expand
set -B

source opts.sh

for US in "${USs[@]}"
do
	#generate pattern .pngs
	cfl2png $CFLCOMMON -IN data/pat_${US}{,.png}

	cfl2png $CFLCOMMON reco_ENLIVE/r_mmu_${US}{,.png}
	cfl2png $CFLCOMMON reco_ENLIVE/r_mm_${US}{,.png}

	cfl2png $CFLCOMMON reco_ESPIRiT/r_mm_abs_${US} reco_ESPIRiT/r_mm_${US}.png
done
