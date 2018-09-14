ZOOM=3
DATA=data/unders
GET_US () { echo -n $(head -n1 data/undersampling_factor_${1}.txt) | tr '.' '-' ; }  
WMAX=0.5
CFLCOMMON="-z$ZOOM -u$WMAX -FZ -x2 -y1"

NEWTON=11
REDU=2

NLINV_OPTS="-a240 -b40 -i${NEWTON} -R${REDU} -S"
SAKE_ITER=50
