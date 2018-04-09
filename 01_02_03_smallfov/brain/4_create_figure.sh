#!/usr/bin/env bash
set -euo pipefail

source ../../FONT.sh
source opts.sh
#first argument is both dir name and output name
DIR="$1"
cd ${DIR}

Y=$(identify -format "%[fx:h]" ./r_mm_1.png)
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



scale_and_text "../r_mm_1.png" "1 map" 1m.png
scale_and_text "../r_mm_2.png" "2 maps" 2m.png
montage -background none 1m.png 2m.png -tile 2x1 -geometry "1x1+${SPACING}+0<" top.png

scale_and_text ../r_mmu_2_map_0000.png "map #1" m0.png
scale_and_text ../r_mmu_2_map_0001.png "map #2" m1.png
montage -background none m0.png m1.png -tile 2x1 -geometry "1x1+${SPACING}+0<" bot.png

montage -background white -alpha remove top.png bot.png -tile 1x2 \
	-geometry "1x1+0+${SPACING}<" -border 0 tmp.png

#remove whitespace around final image:
convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+${SPACING} +repage -crop -${SPACING}-${SPACING} +repage ../${DIR}.png

cd ..
rm -r ${TMP}
cd ..
