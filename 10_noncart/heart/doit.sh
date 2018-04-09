#!/usr/bin/env bash
set -euo pipefail

./0_prep.sh

./1_reco_enlive.sh reco_ENLIVE

./2_create_figure.sh reco_ENLIVE

# copy figure to output
cp reco_ENLIVE/reco_ENLIVE.png ../../output/10_fig_noncart.png
