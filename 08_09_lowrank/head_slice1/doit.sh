#!/bin/bash

set -euo pipefail


./1_reco_enlive.sh
./2_reco_sake.sh

./3_create_figure.sh

./4_create_us_fig.sh

cp ENLIVEvSAKE_US.png ../../output/08_fig_lowrank_sake.png
