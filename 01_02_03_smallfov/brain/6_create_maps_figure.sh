#!/bin/bash
set -euo pipefail

source ../../FONT.sh
#first argument is both dir name and output name
source opts.sh
out=reco_ENLIVE
cd ${out}

Y=$(identify -format "%[fx:h]" ./r_mm_1.png)
#set density. 72 means 1pt is 1 pxl
DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
FONTSIZE=$( echo 'scale=0; 192/6' | bc)
SPACING=$( echo 'scale=0; '${Y}'/24' | bc)

TMP=tmp
mkdir ${TMP}  || true
cd $TMP


rot_and_text()
{
	IF="$1"
	T="$2"
	OF="$3"
   	convert  -rotate -90 -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} caption:"${T}" -gravity Center ${IF} +append ${OF}
}


add_text()
{
	IF="$1"
	T="$2"
	OF="$3"
   	if [ $# -eq "4" ]; then
   		FS=$(echo ${FONTSIZE}"*3/2" | bc)
   	     	convert -density ${DENSITY} -pointsize ${FS} -font ${FONT} label:"${T}" -gravity Center ${IF} +append ${OF} # label before
   	else
   	   	convert ${IF} -density ${DENSITY} -pointsize ${FONTSIZE} -font ${FONT} label:"${T}" -gravity Center -append ${OF} # label below
   	fi
}


for ((m=0; m<$COMP_MAPS; m++))
do
    MAP=$(($m+1))
    printf -v padded_m "%04d" $m
    if [ $MAP -eq "1" ]; then
        MAP_TEXT="1 map"
        rot_and_text ../r_mm_${MAP}.png "ENLIVE" r_mm_${MAP}.png
        rot_and_text ../diff_r_mm_map_${padded_m}.png "diff" diff_tmp2.png
    else
        MAP_TEXT="${MAP} maps"
        cp ../r_mm_${MAP}.png r_mm_${MAP}.png
        cp ../diff_r_mm_map_${padded_m}.png diff_tmp2.png
    fi
    
    add_text ../diff_r_mm_map_${padded_m}.png "$MAP_TEXT" diff_tmp.png
    W=$(identify -format "%[fx:w]" diff_tmp2.png)
    H=$(identify -format "%[fx:h]" diff_tmp.png)
    convert -size ${W}x${H} xc:white diff_tmp2.png -gravity NorthEast -composite diff_tmp.png -gravity NorthEast -composite diff_r_${MAP}.png
    montage -background white -alpha remove r_mm_${MAP}.png diff_r_${MAP}.png -tile 1x -gravity East -geometry "+0+${SPACING}" tmp.png
    # remove whitespace
    convert tmp.png -crop +0+${SPACING} +repage -crop -0-${SPACING} +repage top_${MAP}.png

    add_text ../r_mmu_${COMP_MAPS}_map_${padded_m}.png "map #${MAP}" map_tmp.png
    convert -size ${W}x${H} xc:white map_tmp.png -gravity SouthEast -composite map_tmp2.png
    SEP=$(echo "2*"${SPACING} | bc)
    convert map_tmp2.png -gravity North -splice 0x${SEP} map_${MAP}.png
    if [ $MAP -eq "1" ]; then
        add_text top_${MAP}.png "a " top_${MAP}.png VERT
        add_text map_${MAP}.png "b " map_${MAP}.png VERT
    fi

    montage -background white -alpha remove top_${MAP}.png map_${MAP}.png +set label -tile 1x2 -gravity NorthEast -geometry "+0+0" col_${MAP}.png

done

montage -background white -alpha remove col_*.png -tile x1 \
       -geometry "+${SPACING}+0" tmp.png
#remove whitespace around final image:
convert -flatten tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+0 +repage -crop -${SPACING}-0 +repage ../maps_comp.png

cd ..
rm -r ${TMP}
