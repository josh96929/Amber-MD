#!/bin/bash

dir=$SCRATCH/$2
cd $dir/angle
name=$2

#:135-138@CA
b1=$(grep -w " CA  ARG   134" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b2=$(grep -w " C   ARG   134" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b3=$(grep -w " O   ARG   134" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b4=$(grep -w " N   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b5=$(grep -w " H   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b6=$(grep -w " CA  LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b7=$(grep -w " C   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b8=$(grep -w " N   LYS   136" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b9=$(grep -w " H   LYS   136" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b10=$(grep -w " CA  LYS   136" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b11=$(grep -w " C   LYS   136" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b12=$(grep -w " N   VAL   137" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b13=$(grep -w " H   VAL   137" $dir/setup/*octNaCl.pdb | awk '{print $2}')
b14=$(grep -w " CA  VAL   137" $dir/setup/*octNaCl.pdb | awk '{print $2}')

#:130-133@CA
a1=$(grep -w " CA  GLU   132" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a2=$(grep -w " C   GLU   132" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a3=$(grep -w " O   GLU   132" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a4=$(grep -w " N   HIE   133" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a5=$(grep -w " H   HIE   133" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a6=$(grep -w " CA  HIE   133" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a7=$(grep -w " C   HIE   133" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a8=$(grep -w " N   ARG   134" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a9=$(grep -w " H   ARG   134" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a10=$(grep -w " CA  ARG   134" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a11=$(grep -w " C   ARG   134" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a12=$(grep -w " N   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a13=$(grep -w " H   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
a14=$(grep -w " CA  LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')

#:130,135@C,O
c1=$(grep -w " O   GLU   132" $dir/setup/*octNaCl.pdb | awk '{print $2}')
c2=$(grep -w " N   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
c3=$(grep -w " CA  LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
c4=$(grep -w " C   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
c5=$(grep -w " O   LYS   135" $dir/setup/*octNaCl.pdb | awk '{print $2}')
c6=$(grep -w " N   LYS   136" $dir/setup/*octNaCl.pdb | awk '{print $2}')


> dihedral.trajin

for h in {1..25}; do
echo -e "trajin "$dir"/out/"$name"_"$h".nc" >> dihedral.trajin
done

echo -e "dihedral dihedral_L144 ':144@CG,CD1,CD2' '@"$b1","$b2","$b3","$b4","$b5","$b6","$b7","$b8","$b9","$b10","$b11","$b12","$b13","$b14"' '@"$a1","$a2","$a3","$a4","$a5","$a6","$a7","$a8","$a9","$a10","$a11","$a12","$a13","$a14"' '@"$c1","$c2","$c3","$c4","$c5","$c6"' out dihedral_set1.txt range360
angle bend_L144 ':144@CG,CD1,CD2' '@"$b1","$b2","$b3","$b4","$b5","$b6","$b7","$b8","$b9","$b10","$b11","$b12","$b13","$b14"' '@"$a1","$a2","$a3","$a4","$a5","$a6","$a7","$a8","$a9","$a10","$a11","$a12","$a13","$a14"' out bend_set1.txt
dihedral dihedral_I145 ':145@CB,CG1' '@"$b1","$b2","$b3","$b4","$b5","$b6","$b7","$b8","$b9","$b10","$b11","$b12","$b13","$b14"' '@"$a1","$a2","$a3","$a4","$a5","$a6","$a7","$a8","$a9","$a10","$a11","$a12","$a13","$a14"' '@"$c1","$c2","$c3","$c4","$c5","$c6"' out dihedral_set2.txt range360
angle bend_I145 ':145@CB,CG1' '@"$b1","$b2","$b3","$b4","$b5","$b6","$b7","$b8","$b9","$b10","$b11","$b12","$b13","$b14"' '@"$a1","$a2","$a3","$a4","$a5","$a6","$a7","$a8","$a9","$a10","$a11","$a12","$a13","$a14"' out bend_set2.txt" >> dihedral.trajin


cat *trajin

module load ccs/conda/ambertools-21
module load ccs/singularity

cpptraj "$dir"/out/"$name"_octNaCl.top < dihedral.trajin > dihedral.out

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


