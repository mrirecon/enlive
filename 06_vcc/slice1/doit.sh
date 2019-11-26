#!/bin/bash
set -euo pipefail

./1_reco_vcc.sh
./2_reco_pf_vcc.sh
./3_create_figure.sh
./4_create_comparison_fig.sh
# copy figure to output
cp VCCvPFVCC.png ../../output/06_fig_VCCvPFVCC.png
