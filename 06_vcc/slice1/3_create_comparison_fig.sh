#!/bin/bash
set -euo pipefail

source ../../FONT.sh
#first argument is both dir name and output name

source opts.sh
DIR="$1"
VCC=${DIR}/vcc/vcc_${DIR}.png
PFVCC=${DIR}/pf_vcc/pf_vcc_${DIR}.png

Y=$(identify -format "%[fx:h]" ${DIR}/vcc/r_sm.png)
DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
FONTSIZE=$( echo 'scale=0; 192/6' | bc)
SPACING=$( echo 'scale=0; '${Y}'/24' | bc)

TMP=tmp
mkdir -p ${TMP}
cd $TMP


scale_and_text()
{
	IF="$1"
	T="$2"
	OF="$3"
	convert ${IF} -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} label:"${T}" -gravity Center -append ${OF}
}



scale_and_text ../${VCC} "VCC" 1.png
scale_and_text ../${PFVCC} "PF-VCC" 2.png

montage -background white -alpha remove 1.png 2.png -tile 2x1 \
	-geometry "1x1+${SPACING}+0<" -border 0 tmp.png

#remove whitespace around final image:
convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage ../VCCvPFVCC.png


cd ..
rm -r ${TMP}
