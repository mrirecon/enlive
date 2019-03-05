#!/usr/bin/env python3
import numpy as np
import cfl
import sys


#print(str(sys.argv))

pat = np.zeros((1,192,192))

#generate CAIPIRINHA pattern:


ACS = int(sys.argv[1])
US  = int(sys.argv[2])
if len(sys.argv) > 3:
    CAIPI_SHIFT = int(sys.argv[3])
else:
    CAIPI_SHIFT = US//2

for i in range(0,192,US):
    f = ((i//US % US) * CAIPI_SHIFT) % US

    pat[0,i,f::US] = 1

pat[0,192//2-ACS//2:192//2+ACS//2, 192//2-ACS//2:192//2+ACS//2] = 1 

out='data/pat_' + str(US)
cfl.writecfl(out, pat.transpose((0,2,1)))
