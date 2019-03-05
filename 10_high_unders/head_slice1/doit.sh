#!/usr/bin/env bash
set -euo pipefail

export SHELL=$(type -p bash)
source opts.sh

reco()
{
    US=${1}
    ./0_prep.sh ${US}

    # first param is output directory
    # second param is undersampling
    ./1_reco_enlive.sh reco_ENLIVE ${US}
    ./2_reco_espirit.sh reco_ESPIRiT ${US}
}
export -f reco

mkdir -p reco_ENLIVE
mkdir -p reco_ESPIRiT

parallel reco {} ::: "${USs[@]}"

./3_create_us_fig.sh

cp ENLIVE_US.png ../../output/10_fig_high_unders.png
