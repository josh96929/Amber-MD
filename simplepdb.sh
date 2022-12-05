#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $SCRATCH/$name/out/
        
module load ccs/conda/ambertools-21
module load ccs/singularity


for k in {1..30}
    do
    h=$(($k - 1))

FILENAME="$name"_"$k".rst
echo ${FILENAME}

#if [ -f ${FILENAME} ]
#then
    if [ -e ${FILENAME} ]
    then

ambpdb -noter -offset 125 -p "$name"_octNaCl.top -c "$name"_"$k".rst > "$name"_"$k".pdb

cp *.pdb $HOME
#else
#    echo "File exists but empty"
#    rm -i "$name"_"$k".pdb    
#    fi
else
    echo "File not exists"
    fi


done

conda deactivate

#cp *.pdb $HOME

done


