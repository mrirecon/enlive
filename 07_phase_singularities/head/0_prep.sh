#!/usr/bin/env bash
set -euo pipefail
source ../../BART.sh

#pattern: 2x undersampling, 24 ref lines

$BART fmac data/full data/pat data/unders

