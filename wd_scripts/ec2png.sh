#!/bin/bash

dir=$SCRATCH
name=$2

cd $dir/$name/analysis

echo -e "#set term postscript enhanced eps color size 12, 3
set term png enhanced font 'Verdana,50' size 6400, 2000
#set term epscairo color 
#set terminal postscript
set output 'ec_"$name".png'
set encoding utf8
set size ratio .3

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

set yrange [    0:  25]
set xrange [    0:  25000]

set xlabel 'time'
set ylabel 'angstroms'

set grid
set mytics 5

#set title '"$name"'

plot 'ncap_I128_E132_"$name".txt' index 0 with lines linestyle 1 title 'N-cap I128:E132', \
     'ncap_A129_H133_"$name".txt' index 0 with lines linestyle 2 title 'N-cap A129:H133', \
     'ccap_N142_S146_"$name".txt' index 0 with lines linestyle 3 title 'C-cap N142:S146', \
     'ccap_N142_G147_"$name".txt' index 0 with lines linestyle 4 title 'C-cap N142:G147', \
     'ccap_S143_G147_"$name".txt' index 0 with lines linestyle 5 title 'C-cap S143:G147'" > endcap.gnu


gnuplot endcap.gnu


echo -e "#set term postscript enhanced eps color size 12, 3
set term png enhanced font 'Verdana,50' size 6400, 2000
set output 'jbp_"$name".png'
set encoding utf8
set size ratio .3

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

set yrange [    0:  25]
set xrange [    0:  25000]

set xlabel 'time'
set ylabel 'angstroms'

set grid
set mytics 5

#set title '"$name"'

plot 'L144M171_CD1CD2_SD_"$name".txt' index 0 with lines linestyle 1 title 'L144:CD1CD2 - M171:SD', \
     'L144M171_CB_SD_"$name".txt' index 0 with lines linestyle 2 title 'L144:CB - M171:SD', \
     'I145M171_CD1_SD_"$name".txt' index 0 with lines linestyle 4 title 'I145:CD1 - M171:SD', \
     'I145M171_CG2_SD_"$name".txt' index 0 with lines linestyle 5 title 'I145:CG2 - M171:SD'" > endcap.gnu


gnuplot endcap.gnu


#convert ec_"$name".eps ec_"$name".pdf
#convert jbp_"$name".eps jbp_"$name".pdf

cp ec*.png $HOME
cp jbp*.png $HOME

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
set xrange [    0:  25000]

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

cp aot*png $HOME

cd $SCRATCH

