#!/bin/bash
 

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2


for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $dir/$name/analysis


#:135-138@CA
b1=$(grep -w " CA  ARG     9" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b2=$(grep -w " C   ARG     9" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b3=$(grep -w " O   ARG     9" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b4=$(grep -w " N   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b5=$(grep -w " H   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b6=$(grep -w " CA  LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b7=$(grep -w " C   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b8=$(grep -w " N   LYS    11" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b9=$(grep -w " H   LYS    11" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b10=$(grep -w " CA  LYS    11" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b11=$(grep -w " C   LYS    11" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b12=$(grep -w " N   VAL    12" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b13=$(grep -w " H   VAL    12" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
b14=$(grep -w " CA  VAL    12" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')

#:130-133@CA
a1=$(grep -w " CA  GLU     7" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a2=$(grep -w " C   GLU     7" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a3=$(grep -w " O   GLU     7" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a4=$(grep -w " N   HIE     8" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a5=$(grep -w " H   HIE     8" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a6=$(grep -w " CA  HIE     8" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a7=$(grep -w " C   HIE     8" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a8=$(grep -w " N   ARG     9" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a9=$(grep -w " H   ARG     9" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a10=$(grep -w " CA  ARG     9" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a11=$(grep -w " C   ARG     9" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a12=$(grep -w " N   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a13=$(grep -w " H   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
a14=$(grep -w " CA  LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')

#:130,135@C,O
c1=$(grep -w " O   GLU     7" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
c2=$(grep -w " N   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
c3=$(grep -w " CA  LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
c4=$(grep -w " C   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
c5=$(grep -w " O   LYS    10" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')
c6=$(grep -w " N   LYS    11" $dir/$name/setup/*octNaCl.pdb | awk '{print $2}')


> rmsd_4pts.trajin

for h in {1..25}; do
echo -e "trajin "$dir/$name"/out/"$name"_"$h".nc" >> rmsd_4pts.trajin
done

echo -e "rms pointB '@"$b1","$b2","$b3","$b4","$b5","$b6","$b7","$b8","$b9","$b10","$b11","$b12","$b13","$b14"' first out rmsdb.txt mass
rms pointA '@"$a1","$a2","$a3","$a4","$a5","$a6","$a7","$a8","$a9","$a10","$a11","$a12","$a13","$a14"' first out rmsda.txt mass
rms pointC '@"$c1","$c2","$c3","$c4","$c5","$c6"' first out rmsdc.txt mass
rms whole '@"$b1","$b2","$b3","$b4","$b5","$b6","$b7","$b8","$b9","$b10","$b11","$b12","$b13","$b14","$a1","$a2","$a3","$a4","$a5","$a6","$a7","$a8","$a9","$a10","$a11","$a12","$a13","$a14","$c1","$c2","$c3","$c4","$c5","$c6"' first out rmsdw.txt mass" >> rmsd_4pts.trajin


module load ccs/conda/ambertools-21
module load ccs/singularity

cpptraj "$dir/$name"/out/"$name"_octNaCl.top < rmsd_4pts.trajin > rmsd_4pts.out

conda deactivate


awk '{$1=""}1' rmsdb.txt | awk '{$1=$1}1' > rmsdb.tmp
tail -n +2 rmsdb.tmp > rmsdb.txt
awk '{$1=""}1' rmsda.txt | awk '{$1=$1}1' > rmsda.tmp
tail -n +2 rmsda.tmp > rmsda.txt
awk '{$1=""}1' rmsdc.txt | awk '{$1=$1}1' > rmsdc.tmp
tail -n +2 rmsdc.tmp > rmsdc.txt
awk '{$1=""}1' rmsdw.txt | awk '{$1=$1}1' > rmsdw.tmp
tail -n +2 rmsdw.tmp > rmsdw.txt




cd $SCRATCH

done







