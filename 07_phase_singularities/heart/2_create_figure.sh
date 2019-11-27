#!/bin/bash
set -euo pipefail
set -B

source ../../FONT.sh
source opts.sh

#first argument is both dir name and output name
DIR=reco

for ((m=1; m<=$COMP_MAPS; m++))
do
    cfl2png $CFLCOMMON $DIR/tmp_rss_${m} $DIR/r_mm_${m}.png
    cfl2png -C Y $CFLCOMMON $DIR/r_mm_${m} $DIR/r_mm_${m}_phase.png

    if [ "$m" -eq "$COMP_MAPS" ]
    then
	cfl2png $CFLCOMMON $DIR/tmp_rssu_${m} $DIR/r_mmu_${m}.png
    fi
    rm $DIR/tmp*_${m}.{cfl,hdr}
done

cd ${DIR}

Y=$(identify -format "%[fx:h]" ./r_mm_1.png)
#set density. 72 means 1pt is 1 pxl
DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
FONTSIZE=$( echo 'scale=0; 192/6' | bc)
SPACING=$( echo 'scale=0; '${Y}'/48' | bc)
STRW=3

TMP=tmp
mkdir ${TMP} || true
cd $TMP

scale_and_text()
{
	IF="$1"
	T="$2"
	OF="$3"
	convert ${IF} -stroke red -strokewidth ${STRW} -fill none -draw "translate ${circle_x},${circle_y} circle 0,0 ${circle_r},0" tmp.png
	convert tmp.png -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} label:"${T}" -gravity Center -append ${OF}
	rm tmp.png

}


scale_and_text "../r_mm_1.png" "1 map" 1m.png 
scale_and_text "../r_mm_2.png" "2 maps" 2m.png 
scale_and_text "../r_mm_1_phase.png" "1 map phase" phase.png

scale_and_text ../r_mmu_2_map_0000.png "map #1" m0.png 
scale_and_text ../r_mmu_2_map_0001.png "map #2" m1.png 
montage -background white -alpha remove phase.png 1m.png 2m.png m0.png m1.png -tile 5x1 -geometry "1x1+${SPACING}+0<" tmp.png

#remove whitespace around final image:
convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage ../${DIR}.png

cd ..
rm -r ${TMP}
cd ..
