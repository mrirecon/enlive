#!/usr/bin/env bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
#first argument is both dir name and output name
DIR="$1"
cd ${DIR}

Y=$(identify -format "%[fx:h]" ./r_mm_220_32.png)
#set density. 72 means 1pt is 1 pxl
DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
FONTSIZE=$( echo 'scale=0; 192/6' | bc)
SPACING=$( echo 'scale=0; '${Y}'/48' | bc)

TMP=tmp
mkdir ${TMP} || true
cd $TMP

scale_and_text()
{
	IF="$1"
	T="$2"
	OF="$3"
	convert ${IF} -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} label:"${T}" -gravity Center -append ${OF}
}

ROWS=()
for B in "${Bs[@]}"
do
	for A in "${As[@]}"
	do
		# last row is different
		if [[ $B == "${Bs[-1]}" ]]
		then
			if [[ $A == "${As[0]}" ]]
			then
				scale_and_text ../r_mm_${A}_${B}.png "a=${A}" ${A}_${B}.png
			else
				scale_and_text ../r_mm_${A}_${B}.png "${A}" ${A}_${B}.png
			fi
		else
			cp ../r_mm_${A}_${B}.png ${A}_${B}.png
		fi
	done

	if [[ $B == "${Bs[-1]}" ]]
	then
		convert -interword-spacing 1  -rotate -90 -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} caption:"b=${B}" -gravity Center ../r_mm_${As[0]}_${B}.png +append -gravity east -splice x0 N_tmp.png
	else
		convert -interword-spacing 1  -rotate -90 -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} caption:"${B}" -gravity Center ../r_mm_${As[0]}_${B}.png +append -gravity east -splice x0 N_tmp.png
	fi
	# compose images with a and with b caption on top of each other so that both is correctly aligned
	W=$(identify -format "%[fx:w]" N_tmp.png)
	H=$(identify -format "%[fx:h]" ${As[0]}_${B}.png)
	convert -size ${W}x${H} xc:white ${As[0]}_${B}.png -gravity NorthEast -composite N_tmp.png -gravity NorthEast -composite N_final.png
	
	FARRAY=()
	for A in "${As[@]:1}"; do
		FARRAY+=( ${A}_${B}.png)
	done
	montage -background none N_final.png "${FARRAY[@]}" -tile x1 -geometry +${SPACING}+0 tmp2.png
	ROWS+=(row_${B}.png)
	convert tmp2.png -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage ${ROWS[-1]}
		
done


montage -background white -alpha remove ${ROWS[@]}  -tile 1x \
	-geometry +0+${SPACING} -border 0 tmp.png

convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+${SPACING} +repage -crop -${SPACING}-${SPACING} +repage ../../ENLIVE_a_b.png

cd ..
rm -r ${TMP}
cd ..
