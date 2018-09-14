#!/usr/bin/env bash
set -euo pipefail
set -B

# param is output directory
./0_reco_enlive.sh reco_ENLIVE

./1_create_figure.sh reco_ENLIVE

# copy figure to output
cp {,../../output/04_fig_}ENLIVE_Newton_Noise.png 

