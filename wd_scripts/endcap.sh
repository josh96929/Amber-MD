#!/bin/bash

dir=$SCRATCH
name=$2

cd $dir/$name/analysis

> endcap_stab.trajin

for h in {1..25}; do
echo -e "trajin "$dir/$name"/out/"$name"_"$h".nc" >> endcap_stab.trajin
done

echo -e "distance N-cap_I128_E132 ':128@O' ':132@H' out ncap_I128_E132_"$name".txt

distance N-cap_A129_H133 ':129@O' ':133@H' out ncap_A129_H133_"$name".txt

distance C-cap_N142_S146 ':142@O' ':146@H' out ccap_N142_S146_"$name".txt

distance C-cap_N142_G147 ':142@O' ':147@H' out ccap_N142_G147_"$name".txt

distance C-cap_S143_G147 ':143@O' ':147@H' out ccap_S143_G147_"$name".txt

distance L144M171_CD1CD2_SD ':144@CD1,CD2' ':171@SD' out L144M171_CD1CD2_SD_"$name".txt

distance L144M171_CB_SD ':144@CB' ':171@SD' out L144M171_CB_SD_"$name".txt

distance I145M171_CD1_SD ':145@CD1' ':171@SD' out I145M171_CD1_SD_"$name".txt

distance I145M171_CG2_SD ':145@CG2' ':171@SD' out I145M171_CG2_SD_"$name".txt" >> endcap_stab.trajin


module load ccs/conda/ambertools-21
module load ccs/singularity
cpptraj "$dir/$name"/out/"$name"_octNaCl.top < endcap_stab.trajin > endcap.out
conda deactivate
