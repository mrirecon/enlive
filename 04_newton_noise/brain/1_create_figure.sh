#!/bin/bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
#first argument is both dir name and output name
export DIR=reco_ENLIVE

export SHELL=$(type -p bash)
create_png()
{
	N=$1
	NOISE=$2
    	cfl2png $CFLCOMMON $DIR/r_mm_${N}_${NOISE}{,.png}
}
export -f create_png

parallel create_png {} ::: "${NEWTONS[@]}" ::: "${NOISES[@]}"

cd ${DIR}

Y=$(identify -format "%[fx:h]" ./r_mm_19_0.0.png)
#set density. 72 means 1pt is 1 pxl
DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
FONTSIZE=$( echo 'scale=0; 192/6' | bc)
SPACING=$( echo 'scale=0; '${Y}'/48' | bc)

TMP=tmp
mkdir ${TMP} || true
cd $TMP



#add arrow
arrow_head="l 0,0  +200,+500  -200,+500  +1500,-500 z"

convert -size 1500x1000 xc:None \
	        -draw "stroke white fill white scale 1,1 rotate 0
               path 'M 000,000  $arrow_head' " \
		               arrow.png

declare -A uARROWS
uARROWS["22_0.05"]="+218+219 +541+641"
uARROWS["25_0.01"]="+240+240 +224+286 +175+583"
uARROWS["25_0.025"]="+230+195 +180+233 +141+390 +100+605"
uARROWS["25_0.05"]="+241+125 +190+195 +130+295 +100+347 +141+588 +130+673 +460+823"


#add offsets
offsetx=54
offsety=59
declare -A ARROWS
for i in "${!uARROWS[@]}"
do
	arrow=""
	for uarrow in ${uARROWS[$i]}
	do
		X=$(echo $uarrow | cut -f2 -d"+")
		Y=$(echo $uarrow | cut -f3 -d"+")
		(( X = X - offsetx ))
		(( Y = Y - offsety ))
		arrow="$arrow +$X+$Y"
	done
	ARROWS[$i]="$arrow"
done

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

		arg="${N}_${NOISE}"
		arrows=${ARROWS[$arg]+"${ARROWS[$arg]}"}
		if [ ! -z "$arrows" ]
		then
			for arrow in ${arrows[@]}
 			do	
				convert ${N}_${NOISE}.png \( ./arrow.png -scale 04\% -geometry "$arrow" -background None -rotate 50 \) -composite ${N}_${NOISE}.png
			done
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
