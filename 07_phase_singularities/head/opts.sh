ZOOM=4
DATA=data/unders
WMAX=0.37
CFLCOMMON="-z$ZOOM -u$WMAX -FZ -x2 -y1"

NEWTON=11
REDU=2

NLINV_OPTS="-a240 -b40 -i${NEWTON} -R${REDU} -S"

circle_x=$(( 110 * $ZOOM ))
circle_y=$((  70 * $ZOOM ))
circle_r=$((  11 * $ZOOM ))
