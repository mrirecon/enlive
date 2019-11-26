#!/bin/bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
ENLIVE=reco_ENLIVE
SAKE=reco_SAKE

for USind in "${!VALS[@]}";
do
	USval=${VALS[$USind]}
	US=$(GET_US $USval)

	#ENLIVE
	cfl2png $CFLCOMMON $ENLIVE/r_mm_${US}{,}
	cfl2png $CFLCOMMON $ENLIVE/r_mmu_${US}{,}
	cfl2png $CFLCOMMON $ENLIVE/r_sm_${US}{,}
	cfl2png -C Y $CFLCOMMON $ENLIVE/r_sm_${US} $ENLIVE/r_sm_phase_${US}.png

	#SAKE
	cfl2png $CFLCOMMON -u${WMAX} $SAKE/r_sake_${US}{,.png}

	Y=$(identify -format "%[fx:h]" $ENLIVE/r_mm_${US}.png)
	#set density. 72 means 1pt is 1 pxl
	DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
	FONTSIZE=$( echo 'scale=0; 192/6' | bc)
	SPACING=$( echo 'scale=0; '${Y}'/48' | bc)

	TMP=tmp_${US}
	mkdir ${TMP} || true
	cd $TMP

	scale_and_text()
	{
		IF="$1"
		T="$2"
		OF="$3"
		convert ${IF} -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} label:"${T}" -gravity Center -append ${OF}
	}



	scale_and_text "../"${ENLIVE}"/r_mm_${US}.png" "ENLIVE" 2m.png
	scale_and_text "../"${SAKE}"/r_sake_${US}.png" "SAKE" sake.png
	montage -background none 2m.png sake.png -tile 2x1 -geometry "1x1+${SPACING}+0<" top.png

	scale_and_text ../${ENLIVE}/r_mmu_${US}_map_0000.png "map #1" m0.png
	scale_and_text ../${ENLIVE}/r_mmu_${US}_map_0001.png "map #2" m1.png
	montage -background none m0.png m1.png -tile 2x1 -geometry "1x1+${SPACING}+0<" bot.png

	montage -background white -alpha remove top.png bot.png -tile 1x2 \
		-geometry "1x1+0+${SPACING}<" -border 0 tmp.png

	#remove whitespace around final image:
	convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+${SPACING} +repage -crop -${SPACING}-${SPACING} +repage ../ENLIVEvSAKE_${US}.png

	cd ..
	rm -r ${TMP}
done
