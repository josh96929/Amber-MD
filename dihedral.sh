#!/bin/bash

#sbatch --partition SKY32M192_D --ntasks 32 --ntasks-per-node 32 submit_dihedral.sh 

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2


for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $dir/$name/angle


> dihedral.trajin

#masks are adjusted for a single insertion 19->20, 20->21
#LEU and ILE are referenced back to wildtype without insertation

for h in {1..25}; do
echo -e "trajin "$dir/$name"/out/"$name"_"$h".nc" >> dihedral.trajin
done

echo -e "dihedral dihedral_L144 ':20@CG,CD1,CD2' ':10-13@CA' ':5-8@CA' ':3,10@C,O' out dihedral_set1.txt range360
dihedral dihedral_I145 ':21@CB,CG1' ':10-13@CA' ':5-8@CA' ':3,10@C,O' out dihedral_set2.txt range360
angle bend_L144 ':20@CG,CD1,CD2' ':10-13@CA' ':5-8@CA' out bend_set1.txt
angle bend_I145 ':21@CB,CG1' ':10-13@CA' ':5-8@CA' out bend_set2.txt" >> dihedral.trajin

module load ccs/conda/ambertools-21
module load ccs/singularity

cpptraj "$dir/$name"/out/"$name"_octNaCl.top < dihedral.trajin > dihedral.out

conda deactivate


awk '{$1=""}1' dihedral_set1.txt | awk '{$1=$1}1' > dihedral.tmp
awk '{$1=""}1' bend_set1.txt | awk '{$1=$1}1' > bend.tmp
paste dihedral.tmp bend.tmp -d "," > da_L144_"$name".txt

tail -n +2 da_L144_"$name".txt > da.tmp 
mv da.tmp da_L144_"$name".txt

awk '{$1=""}1' dihedral_set1.txt | awk '{$1=$1}1' > dihedral.tmp
awk '{$1=""}1' bend_set2.txt | awk '{$1=$1}1' > bend.tmp
paste dihedral.tmp bend.tmp -d "," > da_I145_"$name".txt

tail -n +2 da_I145_"$name".txt > da.tmp 
mv da.tmp da_I145_"$name".txt

#cp  da_"$name"*.txt $HOME

echo -e $(date)"\t""$name""\t""dihedral"   

cd $SCRATCH

done

