#!/bin/bash
set -euo pipefail
set -B

./1_create_figure.sh

# copy figure to output
cp {,../../output/04_fig_}ENLIVE_Newton_Noise.png 

