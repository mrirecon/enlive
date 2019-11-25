#!/bin/bash
set -euo pipefail

./1_reco_enlive.sh reco_ENLIVE
./2_create_figure.sh reco_ENLIVE
if [ -f ./3_create_comparison_fig.sh ]; then
	./3_create_comparison_fig.sh reco_ENLIVE
	# copy figure to output
	cp VCCvPFVCC.png ../../output/06_fig_VCCvPFVCC.png
fi
