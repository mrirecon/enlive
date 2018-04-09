ZOOM=3
WMAX=0.5
export CFLCOMMON="-z$ZOOM -u$WMAX -x2 -y1"

export SEED=20869

declare -a NEWTONS=(13 16 19 22 25)
declare -a NOISES=(0.0 0.001 0.01 0.025 0.05)

REDU=1.5
MAPS=2

export NLINV_OPTS="-a240 -b40 -m$MAPS -R${REDU} -S"
