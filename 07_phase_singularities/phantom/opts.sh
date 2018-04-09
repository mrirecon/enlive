ZOOM=3
DATA=data/ksp_phan
WMAX=0.25
CFLCOMMON="-z$ZOOM -u$WMAX -x1 -y0"

NEWTON=11
REDU=2

NLINV_OPTS="-a240 -b40 -Idata/init_phan -i${NEWTON} -R${REDU} -S"
circle_x=$(( 129 * $ZOOM ))
circle_y=$(( 169 * $ZOOM ))
circle_r=$((  15 * $ZOOM ))
