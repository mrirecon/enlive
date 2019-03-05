#!/usr/bin/env bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
NLINV=reco_ENLIVE

USs=("2-0" "3-0" "5-0")

SAKE=reco_SAKE
US=${USs[0]}
Y=$(identify -format "%[fx:h]" $NLINV/r_mm_${US}.png)
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


for US in "${USs[@]}"
do
    enl="../"${NLINV}"/r_mm_${US}.png"
    sake="../"${SAKE}"/r_sake_${US}.png"
    m1="../${NLINV}/r_mmu_${US}_map_0000.png"
    m2="../${NLINV}/r_mmu_${US}_map_0001.png"

    # last row is different
    if [[ $US == "${USs[-1]}" ]]
    then
        scale_and_text $enl "ENLIVE" enl.png
        scale_and_text $m1  "map #1" 1m.png
        scale_and_text $m2  "map #2" 2m.png
        scale_and_text $sake "SAKE" sake.png
        # add whitespace to seperate SAKE and ENLIVE
        convert sake.png -gravity east -splice ${SPACING}x0 sake.png
    else
        cp $enl enl.png
        cp $m1 1m.png
        cp $m2 2m.png
        # add whitespace to seperate SAKE and ENLIVE
        convert $sake -gravity east -splice ${SPACING}x0 sake.png
    fi

    # add R= text and space to SAKE
    US_TEXT=$(echo "R=${US}" | tr '-' '.')
    SEP=$(echo "2*"${SPACING} | bc)
    convert  -rotate -90 -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} caption:"${US_TEXT}" -gravity Center $sake +append -gravity east -splice ${SEP}x0 sake_tmp.png
    # compose images with R= and with "SAKE" caption on top of each other so that both is correctly aligned
    W=$(identify -format "%[fx:w]" sake_tmp.png)
    H=$(identify -format "%[fx:h]" sake.png)
    convert -size ${W}x${H} xc:white sake.png -gravity NorthEast -composite sake_tmp.png -gravity NorthEast -composite sake_final.png

    montage -background none sake_final.png enl.png 1m.png 2m.png -tile x1 -geometry +${SPACING}+0 tmp2.png
    convert tmp2.png -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage row_${US}.png
done

montage -background white -alpha remove row_*.png  -tile 1x \
	-geometry +0+${SPACING} -border 0 tmp.png

#remove whitespace around final image:
convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+${SPACING} +repage -crop -${SPACING}-${SPACING} +repage tmp2.png

#add arrow
arrow_head="l 0,0  +200,+500  -200,+500  +1500,-500 z"

convert -size 1500x1000 xc:None \
        -draw "stroke white fill white scale 1,1 rotate 0
               path 'M 000,000  $arrow_head' " \
        arrow.png

convert tmp2.png \( ./arrow.png -scale 05\% -geometry +357+2465 -background None -rotate -20 \) -composite ../ENLIVEvSAKE_US.png

cd ..
rm -r ${TMP}
