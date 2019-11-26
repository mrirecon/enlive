ZOOM=3
DATA=data/unders
GET_US () { echo -n $(head -n1 data/undersampling_factor_${1}.txt) | tr '.' '-' ; }  
WMAX=0.5
CFLCOMMON="-z$ZOOM -u$WMAX -FZ -x2 -y1"

NEWTON=11
REDU=2

NLINV_OPTS="-a240 -b40 -i${NEWTON} -R${REDU} -S"
SAKE_ITER=50


# Undersampling values
VALS=(  #value  corresponding US factor
        1.205   # 4.0
#        1.573   # 5.0
#        1.86    # 6.0
        2.111   # 7.0
#        2.25    # 7.5
#        2.34    # 8.0
        2.45    # 8.5
 #       2.56    # 9.0
)

PREP ()
{
	US=$1
	source opts.sh

	if [ -f data/undersampling_factor_${US}.txt ];
	then
		# prep already done
		return 0
	fi

	SEED=20869

	# VD-PD for total undersampling of $US:
	bart poisson -Y192 -Z192 -y$US -z$US -v -V10 -s$SEED data/tmp_pat_${US} > /dev/null
	bart pattern data/full data/s_${US}
	bart fmac data/tmp_pat_${US} data/s_${US} data/pat_${US}
	rm data/tmp_pat_${US}.*

	#calculate undersampling
	bart fmac -s 65535 data/s_${US} data/s_${US} data/ns_${US}
	bart fmac -s 65535 data/pat_${US} data/pat_${US} data/npat_${US}
	ALL=$(bart show -f "%+f%+fi" data/ns_${US} | cut -f1 -d"." | cut -f2 -d"+")
	PAT=$(bart show -f "%+f%+fi" data/npat_${US} | cut -f1 -d"." | cut -f2 -d"+")
	rm data/ns_${US}.* data/npat_${US}.* data/s_${US}.*

	UNDERS=$(echo "scale=1;"$ALL"/"$PAT | bc -l)

	echo $UNDERS > data/undersampling_factor_${US}.txt

	US_NAME=$(GET_US $US)

	mv data/pat_${US}.cfl data/pat_${US_NAME}.cfl
	mv data/pat_${US}.hdr data/pat_${US_NAME}.hdr
	bart fmac data/full data/pat_${US_NAME} data/unders_${US_NAME}
}

