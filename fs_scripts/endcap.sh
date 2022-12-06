#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $dir/$name/analysis


> endcap_stab.trajin

for h in {1..50}; do
echo -e "trajin "$dir/$name"/out/"$name"_"$h".nc" >> endcap_stab.trajin
done

echo -e "distance N-cap_I128_E132 ':3@O' ':7@H' out ncap_I128_E132_"$name".txt

distance N-cap_A129_H133 ':4@O' ':8@H' out ncap_A129_H133_"$name".txt

distance C-cap_N142_S146 ':18@O' ':22@H' out ccap_N142_S146_"$name".txt

distance C-cap_N142_G147 ':18@O' ':23@H' out ccap_N142_G147_"$name".txt

distance C-cap_S143_G147 ':19@O' ':23@H' out ccap_S143_G147_"$name".txt" >> endcap_stab.trajin


module load ccs/conda/ambertools-21
module load ccs/singularity
cpptraj "$dir/$name"/out/"$name"_octNaCl.top < endcap_stab.trajin > endcap.out
conda deactivate

#cp *.txt $HOME

echo -e $(date)"\t""$name""\t""endcap"   

cd $SCRATCH

done

