ZOOM=3
DATA=data/unders
GET_US () { echo -n $(head -n1 data/undersampling_factor_${1}.txt) | tr '.' '-' ; }  
WMAX=0.5
CFLCOMMON="-z$ZOOM -u$WMAX -FX -x2 -y1"

NEWTON=11
REDU=2

NLINV_OPTS="-a240 -b40 -i${NEWTON} -R${REDU} -S"
SAKE_ITER=50


# Undersampling values
VALS=(  #value  corresponding US factor
        1.000   # 2.0
        1.420   # 3.0
#        1.750   # 4.0
        2.000   # 5.0
#        2.240   # 6.0
#        2.450   # 7.0
#        2.650   # 8.0
#        2.750   # 8.5
)



PREP ()
{
	US=$1

	if [ -f data/undersampling_factor_${US}.txt ];
	then
		# prep already done
		return 0
	fi

	SEED=20869

	# VD-PD for total undersampling of $US:
	bart poisson -Y320 -Z256 -y$US -z$US -v -V05 -s$SEED data/tmp_pat_${US} > /dev/null
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


GET_DATA ()
{

	if [ -f data/full.cfl ];
	then
		return
	fi

	if false;
	then
		cd data
		wget http://old.mridata.org/knees/fully_sampled/p3/e1/s1/P3.zip
		unzip P3.zip
		cd ..

		#extract single slice
		bart fft -u -i 1 data/kspace data/tmp_fft
		bart slice 0 160 data/tmp_fft data/single_slice
	fi

	bart rss 8 data/single_slice data/tmp_rss
	bart threshold -H 21 data/tmp_rss data/tmp_pat
	bart pattern data/tmp_pat data/pat
	bart fmac data/pat data/single_slice data/tmp_full
	#scale maximum to about 1
	bart scale 1e-8 data/tmp_full data/full


	rm data/tmp_*
}
