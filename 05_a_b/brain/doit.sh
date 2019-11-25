#!/bin/bash
set -euo pipefail
set -B

# ENLIVE reco first:
# param is output directory
./0_reco_enlive.sh reco_ENLIVE

./1_create_figure.sh reco_ENLIVE

# copy figure to output
cp {,../../output/05_fig_}ENLIVE_a_b.png 

