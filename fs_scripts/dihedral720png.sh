#!/bin/bash
module load ccs/conda/matplotlib-3.1.0

dir=$SCRATCH/$2
run="${2:0-1}"

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')


for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

cd $dir/$name/angle

rm *.png

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

plt.title('L144/5 of $name of run$run')
plt.xlabel('dihedral angle')
plt.ylabel('angle of bend')

plt.savefig('da_L144_"$name"_720_run"$run".png', dpi=300)" > plot.tmp.sh

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

plt.title('I145/6 of $name of run$run')
plt.xlabel('dihedral angle')
plt.ylabel('angle of bend')

plt.savefig('da_I145_"$name"_720_run"$run".png', dpi=300)" > plot.tmp.sh

chmod 744 plot.tmp.sh

python3 ./plot.tmp.sh

#####################

cp da*.png $HOME/$2/

rm plot.tmp.sh

done

conda deactivate

