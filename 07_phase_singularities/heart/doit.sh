#!/usr/bin/env bash
set -euo pipefail

./0_prep.sh

./1_reco_enlive.sh reco

./2_create_figure.sh reco
