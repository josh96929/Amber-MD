#set term postscript enhanced eps color size 12, 3
set term png enhanced font 'Verdana,50' size 6400, 2000
set output 'jbp_foldedstart_2.png'
set encoding utf8
set size ratio .3

set style line 1     linecolor rgb '#da0000'     linetype 1 linewidth 2
set style line 2     linecolor rgb '#ff9400'     linetype 1 linewidth 2
set style line 3     linecolor rgb '#70ff87'     linetype 1 linewidth 2
set style line 4     linecolor rgb '#0ff9e7'     linetype 1 linewidth 2
set style line 5     linecolor rgb '#0079ff'     linetype 1 linewidth 2

set yrange [    0:  25]
set xrange [    0:  100000]

set xlabel 'time'
set ylabel 'angstroms'

set grid
set mytics 5

#set title 'foldedstart_2'

plot 'L144M171_CD1CD2_SD_foldedstart_2.txt' index 0 with lines linestyle 1 title 'L144:CD1CD2 - M171:SD',      'L144M171_CB_SD_foldedstart_2.txt' index 0 with lines linestyle 2 title 'L144:CB - M171:SD',      'I145M171_CD1_SD_foldedstart_2.txt' index 0 with lines linestyle 4 title 'I145:CD1 - M171:SD',      'I145M171_CG2_SD_foldedstart_2.txt' index 0 with lines linestyle 5 title 'I145:CG2 - M171:SD'
