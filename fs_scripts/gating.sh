#!/bin/bash

#run,residue,name,mode1xmin,mode1xmax,mode1ymin,mode1ymax,\
#mode2xmin,mode2xmax,mode2ymin,mode2ymax,mode3xmin,mode3xmax,\
#mode3ymin,mode3ymax,mode4xmin,mode4xmax,mode4ymin,mode4ymax

dir=$SCRATCH/$2
#run="${2:0-1}"
mkdir $dir/gateddata #to collect all the files into one directory

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

for (( i = 0; i <= $j; i++ )) do
        run=$(echo ${array[$i]} | awk '{ print $1 }')
        residue=$(echo ${array[$i]} | awk '{ print $2 }')
        name=$(echo ${array[$i]} | awk '{ print $3 }')

        mode1xmin=$(echo ${array[$i]} | awk '{ print $4 }')
        mode1xmax=$(echo ${array[$i]} | awk '{ print $5 }')
        mode1ymin=$(echo ${array[$i]} | awk '{ print $6 }')
        mode1ymax=$(echo ${array[$i]} | awk '{ print $7 }')
        
        mode2xmin=$(echo ${array[$i]} | awk '{ print $8 }')
        mode2xmax=$(echo ${array[$i]} | awk '{ print $9 }')
        mode2ymin=$(echo ${array[$i]} | awk '{ print $10 }')
        mode2ymax=$(echo ${array[$i]} | awk '{ print $11 }')

        mode3xmin=$(echo ${array[$i]} | awk '{ print $12 }')
        mode3xmax=$(echo ${array[$i]} | awk '{ print $13 }')
        mode3ymin=$(echo ${array[$i]} | awk '{ print $14 }')
        mode3ymax=$(echo ${array[$i]} | awk '{ print $15 }')

        mode4xmin=$(echo ${array[$i]} | awk '{ print $16 }')
        mode4xmax=$(echo ${array[$i]} | awk '{ print $17 }')
        mode4ymin=$(echo ${array[$i]} | awk '{ print $18 }')
        mode4ymax=$(echo ${array[$i]} | awk '{ print $19 }')

cd $dir/$name/angle

#mode1
if [[ -z $mode1xmin || -z $mode1xmax || -z $mode1ymin || -z $mode1ymax ]]; then
echo "stopped without a mode"
else
awk -v xi="$mode1xmin" -v xa="$mode1xmax" -F',' '{if ($1 > xi && $1 < xa) print $0}' da_"$residue"_"$name"_720.txt > mode1x.tmp
awk -v yi="$mode1ymin" -v ya="$mode1ymax" -F',' '{if ($2 > yi && $2 < ya) print $0}' mode1x.tmp > mode1_"$residue"_"$name"_run"$run".txt
echo "made mode1 file for da_"$residue"_"$name
fi

#mode2
if [[ -z $mode2xmin || -z $mode2xmax || -z $mode2ymin || -z $mode2ymax ]]; then
echo "no mode2"
else
awk -v xi="$mode2xmin" -v xa="$mode2xmax" -F',' '{if ($1 > xi && $1 < xa) print $0}' da_"$residue"_"$name"_720.txt > mode2x.tmp
awk -v yi="$mode2ymin" -v ya="$mode2ymax" -F',' '{if ($2 > yi && $2 < ya) print $0}' mode2x.tmp > mode2_"$residue"_"$name"_run"$run".txt
echo "made mode2 file for da_"$residue"_"$name
fi

#mode3
if [[ -z $mode3xmin || -z $mode3xmax || -z $mode3ymin || -z $mode3ymax ]]; then
echo "no mode3"
else
awk -v xi="$mode3xmin" -v xa="$mode3xmax" -F',' '{if ($1 > xi && $1 < xa) print $0}' da_"$residue"_"$name"_720.txt > mode3x.tmp
awk -v yi="$mode3ymin" -v ya="$mode3ymax" -F',' '{if ($2 > yi && $2 < ya) print $0}' mode3x.tmp > mode3_"$residue"_"$name"_run"$run".txt
echo "made mode3 file for da_"$residue"_"$name
fi

#mode4
if [[ -z $mode4xmin || -z $mode4xmax || -z $mode4ymin || -z $mode4ymax ]]; then
echo "no mode4"
else
awk -v xi="$mode4xmin" -v xa="$mode4xmax" -F',' '{if ($1 > xi && $1 < xa) print $0}' da_"$residue"_"$name"_720.txt > mode4x.tmp
awk -v yi="$mode4ymin" -v ya="$mode4ymax" -F',' '{if ($2 > yi && $2 < ya) print $0}' mode4x.tmp > mode4_"$residue"_"$name"_run"$run".txt
echo "made mode4 file for da_"$residue"_"$name
fi

cp mode*_run*.txt $dir/gateddata/

done



