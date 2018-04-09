#!/usr/bin/env bash
set -euo pipefail
#build bart:
(
	cd software/bart
	make allclean
	make PARALLEL=1
)

#build view
(
	cd software/view
	make clean
	make cfl2png TOOLBOX_PATH=../bart
)
