#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $SCRATCH/$name/out/
        

for k in {1..30}
    do
    h=$(($k - 1))

FILENAME="$name"_"$k".rst
file=${FILENAME}
minimumsize=1
actualsize=$(du -k "$file" | cut -f 1)
if [ $actualsize -ge $minimumsize ]; then
    echo size is over $minimumsize kilobytes
else
    echo size is under $minimumsize kilobytes
fi


done

#conda deactivate

#cp *.pdb $HOME

done

