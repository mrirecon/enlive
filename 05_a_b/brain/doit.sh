#!/bin/bash
set -euo pipefail
set -B

# ENLIVE reco first:
# param is output directory
./0_reco_enlive.sh

./1_create_figure.sh

# copy figure to output
cp {,../../output/05_fig_}ENLIVE_a_b.png 

