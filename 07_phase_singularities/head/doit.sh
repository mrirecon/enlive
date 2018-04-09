#!/usr/bin/env bash
set -euo pipefail

./0_prep.sh

# first param is output directory
./1_reco_enlive.sh reco
./2_create_figure.sh reco


