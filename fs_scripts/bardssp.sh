#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

dir=$SCRATCH/$2

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

cd $dir/$name/dssp

echo -e "set term png enhanced font 'Verdana,50' size 6400, 2000
#set term png enhanced size 3200, 800
set output 'bardssp_"$name".png'
set encoding utf8
set size ratio .25

set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9
set xtics format ""
set grid ytics
set grid lw 4
set mytics 5
set border lw 4
set key noenhanced

#set title ""
plot 'dssp_"$name".gnu.sum' using 2:xtic(1) linecolor rgb '"#"9b0067' title 'extended', \
    'dssp_"$name".gnu.sum' using 3 linecolor rgb '"#"e7009a' title 'isolated', \
    'dssp_"$name".gnu.sum' using 4 linecolor rgb '"#"004e40' title '3-10', \
    'dssp_"$name".gnu.sum' using 5 linecolor rgb '"#"009a80' title 'alpha', \
    'dssp_"$name".gnu.sum' using 6 linecolor rgb '"#"00e7c0' title 'pi', \
    'dssp_"$name".gnu.sum' using 7 linecolor rgb '"#"3354ff' title 'turn', \
    'dssp_"$name".gnu.sum' using 8 linecolor rgb '"#"001db3' title 'bend'" > bardssp.gnu


gnuplot bardssp.gnu;  


#concert ps to png

cp bar*.png $HOME/$2/

cd $SCRATCH

done


