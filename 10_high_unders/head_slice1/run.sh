#!/bin/bash
set -euo pipefail

source opts.sh

./1_reco_enlive.sh
./2_reco_espirit.sh
