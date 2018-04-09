#!/usr/bin/env bash
set -euo pipefail
find output -name \*.png  | xargs -I {} -n1 -P4 pngcrush -q -new -ow {} {}_tmp
