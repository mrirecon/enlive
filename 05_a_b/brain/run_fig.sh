#!/bin/bash
set -euo pipefail
set -B

./1_create_figure.sh

# copy figure to output
cp {,../../output/05_fig_}ENLIVE_a_b.png 

