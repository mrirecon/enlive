#!/bin/bash

set -euo pipefail

export SHELL=$(type -p bash)

reco()
{
    if [ -z "$1" ]; then
        echo "No undersamplign factor given, using 1.205 for US=4"
        US=1.205
    else
        US=$1
    fi

    if [ -z "$2" ]; then
        TASKSET=''
    else
        TASKSET="taskset -c 0"
    fi

    ./0_prep.sh ${US}

    # ENLIVE reco first:
    # first param is output directory
    $TASKSET ./1_reco_enlive.sh reco_ENLIVE ${US}
    $TASKSET ./2_reco_sake.sh reco_SAKE ${US}

    ./3_create_figure.sh ${US}
}
export -f reco

# Undersampling values
VALS=(  #value  corresponding US factor
        1.205   # 4.0
        1.573   # 5.0
        1.86    # 6.0
        2.111   # 7.0
        2.25    # 7.5
        2.34    # 8.0
        2.45    # 8.5
        2.56    # 9.0
)

mkdir -p reco_ENLIVE
mkdir -p reco_SAKE
# first US separately for timing:
reco ${VALS[0]} 0
# the rest in parallel
parallel reco {} ::: "${VALS[@]:1}"

./4_create_us_fig.sh

cp ENLIVEvSAKE_US.png ../../output/08_fig_lowrank_sake.png
