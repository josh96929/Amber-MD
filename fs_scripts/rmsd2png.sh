#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

cd $dir/$name/analysis

echo -e "#set term postscript enhanced eps color size 12, 3
set term png enhanced font 'Verdana,50' size 6400, 2000
set output 'rmsd_"$name".png'
set encoding utf8
set size ratio .25

set style line 1 \
    linecolor rgb '#da0000' \
    linetype 1 linewidth 4
set style line 2 \
    linecolor rgb '#ff9400' \
    linetype 1 linewidth 4
set style line 3 \
    linecolor rgb '#05d0c0' \
    linetype 1 linewidth 3
set style line 4 \
    linecolor rgb '#0079ff' \
    linetype 1 linewidth 4
set style line 5 \
    linecolor rgb '#003167' \
    linetype 1 linewidth 4

set yrange [    0:  5]
set xrange [    0:  25000]

set xlabel 'time'
set ylabel 'angstroms'

set grid lw 4
set mytics 5
set border lw 4 
set key noenhanced

#set title '"$name"'

plot 'rmsdw.txt' index 0 with lines linestyle 2 title 'whole', \
    'rmsdb.txt' index 0 with lines linestyle 5 title 'point B', \
    'rmsda.txt' index 0 with lines linestyle 4 title 'point A', \
    'rmsdc.txt' index 0 with lines linestyle 3 title 'point C'" > rmsd_4pts.gnu


#    'rmsdL.txt' index 0 with lines linestyle 4 title 'target L', \
#    'rmsdI.txt' index 0 with lines linestyle 5 title 'target I'" > rmsd_4pts.gnu

gnuplot rmsd_4pts.gnu

cp rmsd*png $HOME/$2/

cd $SCRATCH

done


