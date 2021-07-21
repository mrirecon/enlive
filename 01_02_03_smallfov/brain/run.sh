#!/bin/bash
set -euo pipefail

./0_prep.sh

# ENLIVE reco first:
./1_reco_enlive.sh

# then ESPIRiT
./2_reco_espirit.sh
