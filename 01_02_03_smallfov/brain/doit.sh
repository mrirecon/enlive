#!/bin/bash
set -euo pipefail

./0_prep.sh

# ENLIVE reco first:
# first param is output directory
./1_reco_enlive.sh reco_ENLIVE

# then ESPIRiT
./2_reco_espirit.sh reco_ESPIRiT


# difference images
./3_create_difference_imgs.sh reco_ENLIVE
# and individual figures
./4_create_figure.sh reco_ENLIVE
./4_create_figure.sh reco_ESPIRiT


# comparison figure
./5_create_comparison_fig.sh reco_ENLIVE reco_ESPIRiT

# maps comparison fig
./6_create_maps_figure.sh reco_ENLIVE

# sensitivity figure
./7_create_sens_figure.sh reco_ENLIVE

# copy figure to output
cp ENLIVEvESPIRiT.png ../../output/01_fig_ENLIVEvESPIRiT.png
cp reco_ENLIVE/maps_comp.png ../../output/02_fig_ENLIVE_maps.png
cp reco_ENLIVE/reco_ENLIVE_sens.png ../../output/03_fig_ENLIVE_sens.png
