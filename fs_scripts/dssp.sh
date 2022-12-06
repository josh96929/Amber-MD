#!/bin/bash

dir=$SCRATCH/$2

dssp(){
> secstruct.trajin

for h in {1..25}; do
echo -e "trajin $dir/$name/out/"$name"_"$h".nc" >> secstruct.trajin
done

echo -e "strip :WAT
strip :Na+
strip :Cl-
autoimage
secstruct :1-25 out dssp_"$name".gnu" >> secstruct.trajin

module load ccs/conda/ambertools-21
module load ccs/singularity

cpptraj "$dir/$name"/out/"$name"_octNaCl.top < secstruct.trajin > secstruct.out

conda deactivate
}

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $dir/$name/dssp
        
        dssp

	echo -e $(date)"\t""$name""\t""dssp"   
	
        cd $SCRATCH

    done


