#!/bin/bash
module load ccs/conda/matplotlib-3.1.0

dir=$SCRATCH
name=$2

cd $dir/$name/angle

>plot.tmp.sh

echo -e "import matplotlib.pyplot as plt 
import numpy as np

X = []
Y = []

X, Y = np.loadtxt('da_L144_"$name".txt', delimiter=',', unpack=True)

plt.hist2d(X, Y, bins=200, range=[[0,360],[90,180]], cmap='jet')
cb = plt.colorbar()
cb.set_label('counts in bin')

plt.title('L144/5 of $name')
plt.xlabel('dihedral angle')
plt.ylabel('angle of bend')

plt.savefig('da_L144_"$name".png', dpi=300)" > plot.tmp.sh

chmod 744 plot.tmp.sh

python3 ./plot.tmp.sh

#####################

>plot.tmp.sh

echo -e "import matplotlib.pyplot as plt 
import numpy as np

X = []
Y = []

X, Y = np.loadtxt('da_I145_"$name".txt', delimiter=',', unpack=True)

plt.hist2d(X, Y, bins=200, range=[[0,360],[90,180]], cmap='jet')
cb = plt.colorbar()
cb.set_label('counts in bin')

plt.title('I145/6 of $name')
plt.xlabel('dihedral angle')
plt.ylabel('angle of bend')

plt.savefig('da_I145_"$name".png', dpi=300)" > plot.tmp.sh

chmod 744 plot.tmp.sh

python3 ./plot.tmp.sh

#####################

cp da*.png $HOME/$2/

rm plot.tmp.sh

conda deactivate

