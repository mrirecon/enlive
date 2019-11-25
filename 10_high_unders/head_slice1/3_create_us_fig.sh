#!/bin/bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
ENLIVE=reco_ENLIVE
ESPIRIT=reco_ESPIRiT
US=${USs[0]}
Y=$(identify -format "%[fx:h]" $ENLIVE/r_mm_${US}.png)
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
    pat="../data/pat_${US}.png"
    enl="../"${ENLIVE}"/r_mm_${US}.png"
    m1="../${ENLIVE}/r_mmu_${US}_map_0000.png"
    m2="../${ENLIVE}/r_mmu_${US}_map_0001.png"
    es="../${ESPIRIT}/r_mm_${US}.png"

    # last row is different
    if [[ $US == "${USs[-1]}" ]]
    then
        scale_and_text $enl "ENLIVE" enl.png
        scale_and_text $m1  "map #1" 1m.png
        scale_and_text $m2  "map #2" 2m.png
        scale_and_text $pat "pattern" pat.png
        scale_and_text $es "ESPIRiT" es.png
        # add whitespace to seperate pattern and ENLIVE
        convert pat.png -gravity east -splice ${SPACING}x0 pat.png
        # add whitespace to seperate ENLIVE and ESPIRiT
        convert es.png -gravity east -splice ${SPACING}x0 es.png
    else
        cp $enl enl.png
        cp $m1 1m.png
        cp $m2 2m.png
        # add whitespace to seperate pattern and ENLIVE
        convert $pat -gravity east -splice ${SPACING}x0 pat.png
        # add whitespace to seperate ENLIVE and ESPIRiT
        convert $es -gravity east -splice ${SPACING}x0 es.png
    fi

    # add R= text and space to SAKE
    US_TEXT=$(echo "R=${US}" | tr '-' '.')
    US2=$(echo "$US*$US" | bc)
    US_TEXT="R=${US2}"
    SEP=$(echo "2*"${SPACING} | bc)
    convert  -rotate -90 -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} caption:"${US_TEXT}" -gravity Center $pat +append -gravity east -splice ${SEP}x0 pat_tmp.png
    # compose images with R= and with "SAKE" caption on top of each other so that both is correctly aligned
    W=$(identify -format "%[fx:w]" pat_tmp.png)
    H=$(identify -format "%[fx:h]" pat.png)
    convert -size ${W}x${H} xc:white pat.png -gravity NorthEast -composite pat_tmp.png -gravity NorthEast -composite pat_final.png

    montage -background none pat_final.png es.png enl.png 1m.png 2m.png -tile x1 -geometry +${SPACING}+0 tmp2.png
    convert tmp2.png -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage row_${US}.png
done

montage -background white -alpha remove row_*.png  -tile 1x \
	-geometry +0+${SPACING} -border 0 tmp.png

#remove whitespace around final image:
convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+${SPACING} +repage -crop -${SPACING}-${SPACING} +repage ../ENLIVE_US.png

cd ..
rm -r ${TMP}
