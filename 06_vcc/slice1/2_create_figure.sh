#!/usr/bin/env bash
set -euo pipefail

source ../../FONT.sh
#first argument is both dir name and output name
DIR="$1"
source opts.sh

# loop over subdirs and generate output name

cd ${DIR}
for sd in $(find . -mindepth 1 -maxdepth 1 -type d)
do
	cd $sd
	OUTN=${sd}_${DIR}
	
	Y=$(identify -format "%[fx:h]" ./r_sm.png)
	DENSITY=$( echo 'scale=5; 72/192*'$Y | bc)
	FONTSIZE=$( echo 'scale=0; 192/6' | bc)
	SPACING=$( echo 'scale=0; '${Y}'/48' | bc)

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
	
	scale_and_text "../r_sm.png" "1 map" 1m.png 
	scale_and_text "../r_mm.png" "2 maps" 2m.png 
	montage -background none 1m.png 2m.png -tile 2x1 -geometry "1x1+${SPACING}+0<" top.png
	
	scale_and_text ../r_mmu_map_0000.png "map #1" m0.png 
	scale_and_text ../r_mmu_map_0001.png "map #2" m1.png 
	montage -background none m0.png m1.png -tile 2x1 -geometry "1x1+${SPACING}+0<" bot.png
	
	montage -background white -alpha remove top.png bot.png -tile 1x2 \
		-geometry "1x1+0+${SPACING}<" -border 0 tmp.png

	#remove whitespace around final image:
	convert tmp.png -density ${DENSITY} -units PixelsPerInch -crop +${SPACING}+${SPACING} +repage -crop -${SPACING}-${SPACING} +repage ../${OUTN}.png

	cd ..
	rm -r ${TMP}
	cd ..
done
