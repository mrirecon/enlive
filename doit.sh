#!/usr/bin/env bash
set -euo pipefail

LOG=timelog.log
echo "Start: $(date --iso-8601=seconds)" | tee $LOG

#prepare software
git submodule update --init
./build_software.sh
echo "preparation and building software: ${SECONDS}s" | tee -a $LOG

# smallfov:
ref=$SECONDS
(
	cd 01_02_03_smallfov
	cd brain
	./doit.sh
)
echo "smallfov: $(( SECONDS - ref ))s" | tee -a $LOG


# Newton-Noise
ref=$SECONDS
(
	cd 04_newton_noise
	cd brain
	./doit.sh
)
echo "newton-noise: $(( SECONDS - ref ))s" | tee -a $LOG


# a-b
ref=$SECONDS
(
	cd 05_a_b
	cd brain
	./doit.sh
)
echo "a-b: $(( SECONDS - ref ))s" | tee -a $LOG


# virtual-conjugate coils
ref=$SECONDS
(
	cd 06_vcc
	cd slice1
	./doit.sh
)
echo "virtual-conjugate coils: $(( SECONDS - ref ))s" | tee -a $LOG


# phase singularities:
ref=$SECONDS
(
	cd 07_phase_singularities
	cd phantom
	./doit.sh
	cd ../head
	./doit.sh
	cd ../heart
	./doit.sh
	cd ..
	./create_Phantom_Head_Heart.sh
)
echo "phase singularities: $(( SECONDS - ref ))s" | tee -a $LOG

# low-rank test
ref=$SECONDS
(
	cd 08_09_lowrank
	cd head_slice1
	./doit.sh
	cd ..
	cd knee
	./doit.sh
)
echo "low-rank: $(( SECONDS - ref ))s" | tee -a $LOG

# high unders
ref=$SECONDS
(
	cd 10_high_unders
	cd head_slice1
	./doit.sh
)
echo "high undersampling: $(( SECONDS - ref ))s" | tee -a $LOG


# the pngs that come out are unoptimized and therefore quite large
# we optimize them if we find pngcrush
./pngcrush.sh || true

echo "End: $(date --iso-8601=seconds)" | tee -a $LOG
