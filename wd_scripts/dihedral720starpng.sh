#!/bin/bash
module load ccs/conda/matplotlib-3.1.0

dir=$SCRATCH
name=$2

cd $dir/$name/angle



awk '{$1=""}1' dihedral_set1.txt | awk '{$1=$1}1' > dihedral_L144.tmp
awk '{$1=""}1' bend_set1.txt | awk '{$1=$1}1' > bend_L144.tmp
paste dihedral_L144.tmp bend_L144.tmp -d "," > da_L144_"$name".txt

tail -n +2 da_L144_"$name".txt > da.tmp
mv da.tmp da_L144_"$name".txt


awk '{$1=""}1' dihedral_set2.txt | awk '{$1=$1}1' > dihedral_I145.tmp
awk '{$1=""}1' bend_set2.txt | awk '{$1=$1}1' > bend_I145.tmp
paste dihedral_I145.tmp bend_I145.tmp -d "," > da_I145_"$name".txt

tail -n +2 da_I145_"$name".txt > da.tmp
mv da.tmp da_I145_"$name".txt



tail -n +2 dihedral_L144.tmp > dihedral_L144_360.tmp
cp dihedral_L144_360.tmp dihedral_L144_720.tmp
awk '{$1=""}1' dihedral_set1.txt | awk '{$1=$1}1' | awk '{$1+=360.0000}1' | tail -n +2 >> dihedral_L144_720.tmp

tail -n +2 bend_L144.tmp > bend_L144_360.tmp
cp bend_L144_360.tmp bend_L144_720.tmp
cat bend_L144_360.tmp >> bend_L144_720.tmp

paste dihedral_L144_720.tmp bend_L144_720.tmp -d "," > da_L144_"$name"_720.txt



tail -n +2 dihedral_I145.tmp > dihedral_I145_360.tmp
cp dihedral_I145_360.tmp dihedral_I145_720.tmp
awk '{$1=""}1' dihedral_set2.txt | awk '{$1=$1}1' | awk '{$1+=360.0000}1' | tail -n +2 >> dihedral_I145_720.tmp

tail -n +2 bend_I145.tmp > bend_I145_360.tmp
cp bend_I145_360.tmp bend_I145_720.tmp
cat bend_I145_360.tmp >> bend_I145_720.tmp

paste dihedral_I145_720.tmp bend_I145_720.tmp -d "," > da_I145_"$name"_720.txt






>plot.tmp.sh

echo -e "import matplotlib.pyplot as plt 
import numpy as np

X = []
Y = []

X, Y = np.loadtxt('da_L144_"$name"_720.txt', delimiter=',', unpack=True)

plt.hist2d(X, Y, bins=200, range=[[0,720],[0,180]], cmap='jet')
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

X, Y = np.loadtxt('da_I145_"$name"_720.txt', delimiter=',', unpack=True)

plt.hist2d(X, Y, bins=200, range=[[0,720],[0,180]], cmap='jet')
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


