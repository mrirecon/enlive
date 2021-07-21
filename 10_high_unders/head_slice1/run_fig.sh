#!/bin/bash
set -euo pipefail

source opts.sh

./3_create_pngs.sh
./4_create_us_fig.sh

cp ENLIVE_US.png ../../output/10_fig_high_unders.png

