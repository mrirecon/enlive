ZOOM=3
WMAX=0.5
CFLCOMMON="-z$ZOOM -u$WMAX -FZ -x2 -y1"

NEWTON=11
REDU=2

NLINV_OPTS="-a240 -b40 -i${NEWTON} -R${REDU} -S"

FULL=data/slice-full
UNDERS=data/slice-x3
PF=data/slice-x3pf58r24 #partial fourier dataset

