ZOOM=3
DATA=data/grid
REF=data/ref
WMAX=0.3
CFLCOMMON="-z$ZOOM -u$WMAX -FZ -x0 -y1"

NEWTON=17
REDU=1.5

NLINV_OPTS="-a240 -b40  -i${NEWTON} -R${REDU} -S -f0.5 -pdata/psf"
MAPS=2
COMP_MAPS=2

NSMPL=320
OG=1.5


circle_r=$((  12 * $ZOOM ))
circle_x=$(( ( 176 - 163 ) * $ZOOM ))
circle_y=$(( ( 176 - 45 ) * $ZOOM ))
