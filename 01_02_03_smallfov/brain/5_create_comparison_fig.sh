#!/bin/bash
set -euo pipefail

source ../../FONT.sh
#first argument is both dir name and output name
source opts.sh
ENLIVE="$1"
ESPIRIT="$2"

Y=$(identify -format "%[fx:h]" ./${ENLIVE}/r_mm_1.png)
#set density. 72 means 1pt is 1 pxl
DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
FONTSIZE=$( echo 'scale=0; 192/6' | bc)
SPACING=$( echo 'scale=0; '${Y}'/24' | bc)
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



scale_and_text ../${ENLIVE}/${ENLIVE}.png "ENLIVE" ENLIVE.png 
scale_and_text ../${ESPIRIT}/${ESPIRIT}.png "ESPIRiT" ESPIRIT.png

montage -background white -alpha remove ENLIVE.png ESPIRIT.png -tile 2x1 \
	-geometry "1x1+${SPACING}+0<" -border 0 tmp.png

#remove whitespace around final image:
convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage ../ENLIVEvESPIRiT.png


cd ..
rm -r ${TMP}
