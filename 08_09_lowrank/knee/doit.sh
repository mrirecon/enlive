#!/usr/bin/env bash

set -euo pipefail

export SHELL=$(type -p bash)

reco()
{
    if [ -z "$1" ]; then
        echo "No undersamplign factor given, using 1.000 for US=2"
        US=1.000
    else
        US=$1
    fi

    if [ -z "$2" ]; then
        TASKSET=''
    else
        TASKSET="taskset -c 0"
    fi

    ./1_gen_unders.sh ${US}

    # ENLIVE reco first:
    # first param is output directory
    $TASKSET ./2_reco_enlive.sh reco_ENLIVE ${US}
    $TASKSET ./3_reco_sake.sh reco_SAKE ${US}

    ./4_create_figure.sh ${US}
}
export -f reco

# Undersampling values
VALS=(  #value  corresponding US factor
        1.000   # 2.0
        1.420   # 3.0
        1.750   # 4.0
        2.000   # 5.0
        2.240   # 6.0
        2.450   # 7.0
        2.650   # 8.0
        2.750   # 8.5
)

mkdir -p reco_ENLIVE
mkdir -p reco_SAKE

./0_prep.sh

# first US separately for timing:
reco ${VALS[0]} 0
# the rest in parallel
parallel reco {} ::: "${VALS[@]:1}"

./5_create_us_fig.sh

cp ENLIVEvSAKE_US.png ../../output/09_fig_lowrank_sake_knee.png
