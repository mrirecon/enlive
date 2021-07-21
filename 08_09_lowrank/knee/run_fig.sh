#!/bin/bash
set -euo pipefail

./3_create_figure.sh

./4_create_us_fig.sh

cp ENLIVEvSAKE_US.png ../../output/09_fig_lowrank_sake_knee.png
