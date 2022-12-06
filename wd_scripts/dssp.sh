#!/bin/bash

dir=$SCRATCH
name=$2

dssp(){
> secstruct.trajin

for h in {1..25}; do
echo -e "trajin $dir/$name/out/"$name"_"$h".nc" >> secstruct.trajin
done

echo -e "strip :WAT
strip :Na+
strip :Cl-
autoimage
secstruct :126-149 out dssp_"$name".gnu" >> secstruct.trajin

module load ccs/conda/ambertools-21
module load ccs/singularity

cpptraj "$dir/$name"/out/"$name"_octNaCl.top < secstruct.trajin > secstruct.out

conda deactivate
}

cd $dir/$name/dssp
        
dssp

