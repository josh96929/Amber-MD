#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

cd $dir/$name/analysis

echo -e "set term png enhanced font 'Verdana,50' size 6400, 2000
#set term png enhanced size 3000, 1500
set output 'ec_"$name".png'
set encoding utf8
set size ratio .25

set style line 1 \
    linecolor rgb '#da0000' \
    linetype 1 linewidth 4
set style line 2 \
    linecolor rgb '#ff9400' \
    linetype 1 linewidth 4
set style line 3 \
    linecolor rgb '#70ff87' \
    linetype 1 linewidth 4
set style line 4 \
    linecolor rgb '#0ff9e7' \
    linetype 1 linewidth 4
set style line 5 \
    linecolor rgb '#0079ff' \
    linetype 1 linewidth 4

set yrange [    0:  25]
set xrange [    0:  50000]

set xlabel 'time'
set ylabel 'angstroms'

set grid lw 4
set mytics 5
set border lw 4 
set key noenhanced

#set title '"$name"'

plot 'ncap_I128_E132_"$name".txt' index 0 with lines linestyle 1 title 'N-cap I128(:3@O):E132(:7@H)', \
     'ncap_A129_H133_"$name".txt' index 0 with lines linestyle 2 title 'N-cap A129(:4@O):H133(:8@H)', \
     'ccap_N142_S146_"$name".txt' index 0 with lines linestyle 3 title 'C-cap N142(:18@O):S146(:22@H)', \
     'ccap_N142_G147_"$name".txt' index 0 with lines linestyle 4 title 'C-cap N142(:18@O):G147(:23@H)', \
     'ccap_S143_G147_"$name".txt' index 0 with lines linestyle 5 title 'C-cap S143(:19@O):G147(:23@H)'" > endcap.gnu


gnuplot endcap.gnu  


cp ec*.png $HOME/$2/

cd $dir/$name/angle

tail -n +2 dihedral_L144.tmp > dihedral_noheader.tmp
tail -n +2 bend_L144.tmp > bend_noheader.tmp

echo -e "#set term postscript enhanced eps color size 12, 3
set term png enhanced font 'Verdana,50' size 6400, 2000
set output 'aot_L144_"$name".png'
set encoding utf8
set size ratio .25

set style line 1 \
    linecolor rgb '#da0000' \
    linetype 1 linewidth 2
set style line 2 \
    linecolor rgb '#ff9400' \
    linetype 1 linewidth 2
set style line 3 \
    linecolor rgb '#70ff87' \
    linetype 1 linewidth 2
set style line 4 \
    linecolor rgb '#0ff9e7' \
    linetype 1 linewidth 2
set style line 5 \
    linecolor rgb '#0079ff' \
    linetype 1 linewidth 2
    
set yrange [    0:  360]
set xrange [    0:  50000]

set xlabel 'time'
set ylabel 'degrees'

set grid lw 4
set mytics 5
set border lw 4 
set key noenhanced

#set title '"$name"'

plot 'dihedral_noheader.tmp' index 0 with points pointtype 7 pointsize 1.5 linecolor rgb '#da0000' title 'L144 dihedral angle', \
     'bend_noheader.tmp' index 0 with points pointtype 7 pointsize 1.5 linecolor rgb '#0079ff' title 'L144 bend angle'" > aot.gnu

gnuplot aot.gnu

cp aot*png $HOME/$2/







cd $dir/$name/angle

tail -n +2 dihedral_I145.tmp > dihedral_noheader.tmp
tail -n +2 bend_I145.tmp > bend_noheader.tmp

echo -e "#set term postscript enhanced eps color size 12, 3
set term png enhanced font 'Verdana,50' size 6400, 2000
set output 'aot_I145_"$name".png'
set encoding utf8
set size ratio .25

set style line 1 \
    linecolor rgb '#da0000' \
    linetype 1 linewidth 2
set style line 2 \
    linecolor rgb '#ff9400' \
    linetype 1 linewidth 2
set style line 3 \
    linecolor rgb '#70ff87' \
    linetype 1 linewidth 2
set style line 4 \
    linecolor rgb '#0ff9e7' \
    linetype 1 linewidth 2
set style line 5 \
    linecolor rgb '#0079ff' \
    linetype 1 linewidth 2
    
set yrange [    0:  360]
set xrange [    0:  25000]

set xlabel 'time'
set ylabel 'degrees'

set grid lw 4
set mytics 5
set border lw 4 
set key noenhanced

#set title '"$name"'

plot 'dihedral_noheader.tmp' index 0 with points pointtype 7 pointsize 1.5 linecolor rgb '#da0000' title 'I145 dihedral angle', \
     'bend_noheader.tmp' index 0 with points pointtype 7 pointsize 1.5 linecolor rgb '#0079ff' title 'I145 bend angle'" > aot.gnu

gnuplot aot.gnu

cp aot*png $HOME/$2/



cd $SCRATCH

done




