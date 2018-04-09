#!/usr/bin/env bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
#first argument is both dir name and output name
DIR="$1"
cd ${DIR}

Y=$(identify -format "%[fx:h]" ./r_mm_1.png)
#set density. 72 means 1pt is 1 pxl
DENSITY=$( echo 'scale=5; 72/192*'$Y'*7/5' | bc)
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
   	convert  -rotate -90 -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} label:"${T}" -gravity Center ${IF} -gravity east -splice ${SPACING}x0  +append ${OF}
}

TILE=8x1

rows=()
for ((m=0; m<$COMP_MAPS; m++))
{
    MAP=$(($m+1))
    printf -v padded_m "%04d" $m
    montage -background white -alpha remove ../s_mmu_coil_000{0,1,2,3,4,5,6,7}_map_${padded_m}.png -tile $TILE \
           -geometry "1x1+0+0<" -border 0 m${m}.png

    rows[$m]=row${m}.png
    #the space after "map #x" is a unicode  U+2009 THIN SPACE
    scale_and_text m${m}.png "map #${MAP} " ${rows[$m]}
}




montage -background white -alpha remove ${rows[@]} +set label -tile 1x${COMP_MAPS} \
	-geometry "1x1+0+${SPACING}<" -border 0 tmp.png

H=$(echo $(identify -format "%[fx:h]" tmp.png)"/2" | bc)

convert ../../MYGBM_colorbar.png -geometry x${H} cb_tmp.png

convert tmp.png cb_tmp.png -gravity Center +append -layers mosaic tmp2.png

#remove whitespace around final image:
convert tmp2.png -flatten -density ${DENSITY} -units PixelsPerInch -crop +0+${SPACING} +repage -crop -0-${SPACING} +repage ../${DIR}_sens.png

cd ..
rm -r ${TMP}
cd ..
