#!/usr/bin/env bash
set -euo pipefail

source ../FONT.sh
source head/opts.sh
DIR=reco
SL1=phantom/${DIR}/${DIR}.png
SL2=head/${DIR}/${DIR}.png
SL3=heart/${DIR}/${DIR}.png

Y=$(identify -format "%[fx:h]" phantom/${DIR}/r_sm.png)
DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
FONTSIZE=$( echo 'scale=0; 192/4' | bc)
SPACING=$( echo 'scale=0; '${Y}'/24' | bc)

TMP=tmp
mkdir ${TMP} || true
cd $TMP


scale_and_text()
{
	IF="$1"
	T="$2"
	OF="$3"
	convert -background none -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} -size 100x caption:"${T}" -gravity Center ${IF} +append ${OF}
}


#the space after a and b is a unicode  U+2009 THIN SPACE
scale_and_text ../${SL1} "a " 1.png
scale_and_text ../${SL2} "b " 2.png
W=$(identify -format "%[fx:w]" ../${SL2})
convert -geometry ${W}x ../${SL3} tmp3.png
scale_and_text tmp3.png "c " 3.png


montage -background white -alpha remove 1.png 2.png 3.png -tile 1x3 \
	-geometry "1x1+0+${SPACING}<" -border 0 tmp.png

H=$(identify -format "%[fx:h]" tmp.png)
H2=$(echo "$H/2" | bc)

convert ../../MYGBM_colorbar.png -geometry x${H2} cb_tmp.png

convert tmp.png cb_tmp.png -gravity east +append -layers mosaic tmp2.png


#remove whitespace around final image:
convert tmp2.png -density ${DENSITY} -units PixelsPerInch -crop +0+${SPACING} +repage -crop -0-${SPACING} +repage ../bh_phan_head_heart.png


cd ..
rm -r ${TMP}

cp bh_phan_head_heart.png ../output/07_fig_blackholes.png
