ZOOM=3
DATA=data/unders
WMAX=0.5
CFLCOMMON="-z$ZOOM -u$WMAX -FZ -x2 -y1"
NEWTON=8
REDU=3

NLINV_OPTS="-a240 -b40 -i${NEWTON} -R${REDU} -S"

ACS=24
# Undersampling values
USs=(  #value  corresponding US factor
        2	# 4
        3	# 9
        4	# 16
#	5 	# 25
)
