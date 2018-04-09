#!/usr/bin/env bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
#first argument is both dir name and output name
DIR="$1"
cd ${DIR}

Y=$(identify -format "%[fx:h]" ./r_mm_19_0.0.png)
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
for NOISE in "${NOISES[@]}"
do
	NPERCENT=$(echo "$NOISE * 100" | bc -l)
	NSTRING=$(printf "%2.2f%%" $NPERCENT) # thin space

	for N in "${NEWTONS[@]}"
	do
		# last row is different
		if [[ $NOISE == "${NOISES[-1]}" ]]
		then
			scale_and_text ../r_mm_${N}_${NOISE}.png ${N} ${N}_${NOISE}.png
		else
			cp ../r_mm_${N}_${NOISE}.png ${N}_${NOISE}.png
		fi
	done

	convert -interword-spacing 1  -rotate -90 -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} caption:"${NSTRING}" -gravity Center ../r_mm_${NEWTONS[0]}_${NOISE}.png +append -gravity east -splice x0 N_tmp.png
	# compose images with noise and with Newton caption on top of each other so that both is correctly aligned
	W=$(identify -format "%[fx:w]" N_tmp.png)
	H=$(identify -format "%[fx:h]" ${NEWTONS[0]}_${NOISE}.png)
	convert -size ${W}x${H} xc:white ${NEWTONS[0]}_${NOISE}.png -gravity NorthEast -composite N_tmp.png -gravity NorthEast -composite N_final.png

	FARRAY=()
	for N in "${NEWTONS[@]:1}"; do
		FARRAY+=( ${N}_${NOISE}.png)
	done
	montage -background none N_final.png "${FARRAY[@]}" -tile x1 -geometry +${SPACING}+0 tmp2.png
	ROWS+=(row_${NOISE}.png)
	convert tmp2.png -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage ${ROWS[-1]}

done


montage -background white -alpha remove ${ROWS[@]}  -tile 1x \
	-geometry +0+${SPACING} -border 0 tmp.png

convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+${SPACING} +repage -crop -${SPACING}-${SPACING} +repage ../../ENLIVE_Newton_Noise.png

cd ..
rm -r ${TMP}
cd ..
