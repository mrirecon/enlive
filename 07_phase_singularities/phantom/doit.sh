#!/bin/bash
set -euo pipefail

# param is output directory
./1_reco_enlive.sh reco
./2_create_figure.sh reco


