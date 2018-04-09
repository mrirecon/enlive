ZOOM=3
WMAX=0.5
export CFLCOMMON="-z$ZOOM -u$WMAX -x2 -y1"

export SEED=20869

declare -a As=(200 220 240 260 280)
declare -a Bs=(32 36 40 44 48)

NEWTON=19

REDU=1.5
MAPS=2

export NLINV_OPTS="-m$MAPS -i$NEWTON -R${REDU} -S"
