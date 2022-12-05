#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

cd $dir/$name/analysis

echo -e "set term png enhanced size 3000, 1500
set output 'ec_"$name".png'
set encoding utf8
set size ratio .25

set style line 1 \
    linecolor rgb '#da0000' \
    linetype 1 linewidth 1
set style line 2 \
    linecolor rgb '#ff9400' \
    linetype 1 linewidth 1
set style line 3 \
    linecolor rgb '#70ff87' \
    linetype 1 linewidth 1
set style line 4 \
    linecolor rgb '#0ff9e7' \
    linetype 1 linewidth 1
set style line 5 \
    linecolor rgb '#0079ff' \
    linetype 1 linewidth 1

set yrange [    0:  25]
set xrange [    0:  50000]

set xlabel 'time'
set ylabel 'angstroms'

set grid
set mytics 5
set title '"$name"'

plot 'ncap_I128_E132_"$name".txt' index 0 with lines linestyle 1 title 'N-cap I128:E132', \
     'ncap_A129_H133_"$name".txt' index 0 with lines linestyle 2 title 'N-cap A129:H133', \
     'ccap_N142_S146_"$name".txt' index 0 with lines linestyle 3 title 'C-cap N142:S146', \
     'ccap_N142_G147_"$name".txt' index 0 with lines linestyle 4 title 'C-cap N142:G147', \
     'ccap_S143_G147_"$name".txt' index 0 with lines linestyle 5 title 'C-cap S143:G147'" > endcap.gnu


gnuplot endcap.gnu;  

cp *.png $HOME/$2/

cd $SCRATCH

done




