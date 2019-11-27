#!/bin/bash
set -euo pipefail

./0_prep.sh

# ENLIVE reco first:
./1_reco_enlive.sh

# then ESPIRiT
./2_reco_espirit.sh

./3_create_pngs.sh

# difference images
./4_create_difference_imgs.sh
# and individual figures
./5_create_figure.sh reco_ENLIVE
./5_create_figure.sh reco_ESPIRiT


# comparison figure
./6_create_comparison_fig.sh reco_ENLIVE reco_ESPIRiT

# maps comparison fig
./7_create_maps_figure.sh reco_ENLIVE

# sensitivity figure
./8_create_sens_figure.sh reco_ENLIVE

# copy figure to output
cp ENLIVEvESPIRiT.png ../../output/01_fig_ENLIVEvESPIRiT.png
cp reco_ENLIVE/maps_comp.png ../../output/02_fig_ENLIVE_maps.png
cp reco_ENLIVE/reco_ENLIVE_sens.png ../../output/03_fig_ENLIVE_sens.png
