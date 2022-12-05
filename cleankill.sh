#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

cd $dir/$name/analysis
rm *.txt
rm *.out
rm *.trajin

cd $dir/$name/angle
rm *.txt
rm *.out
rm *.trajin
rm *.tmp
rm *.png

cd $dir/$name/dssp
rm *.txt
rm *.out
rm *.trajin
rm *.png
rm *.sum
rm *.gnu

cd $SCRATCH

done

