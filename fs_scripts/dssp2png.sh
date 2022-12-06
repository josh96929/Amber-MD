#!/bin/bash

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

pick(){
ins="${name:0-1}"
if [ "$ins" = A ]; then
        h="** ALA"
elif [ "$ins" = D ]; then
        h="** ASP"
elif [ "$ins" = G ]; then
        h="** GLY"
elif [ "$ins" = N ]; then
        h="** ASN"
elif [ "$ins" = P ]; then
        h="** PRO"
elif [ "$ins" = R ]; then
        h="** ARG"
elif [ "$ins" = S ]; then
        h="** SER"
elif [ "$ins" = T ]; then
        h="** THR"
elif [ "$ins" = W ]; then
        h="** TRP"
else
        h="XX*VOID*XX"
fi
}

register(){
ins="${name:1:3}"
if [ "$ins" = 139 ]; then
    pick
    h139="$h"
else
        h139="GLU"
fi

if [ "$ins" = 140 ]; then
    pick
    h140="$h"
else
        h140="LEU"
fi

if [ "$ins" = 141 ]; then
    pick
    h141="$h"
else
        h141="ASN"
fi

if [ "$ins" = 142 ]; then
    pick
    h142="$h"
else
        h142="SER"
fi

if [ "$ins" = 143 ]; then
    pick
    h143="$h"
else
        h143="LEU"
fi
}

dir=$SCRATCH/$2
mkdir $HOME/$2

pwd

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')
        h=$(echo ${array[$i]} | awk '{ print $2 }')

        cd $dir/$name/dssp

pwd

        pick
        register

echo $h139

        var='\\n'
echo -e "set term png enhanced size 3200, 900
set output 'dssp_"$name".png'
set encoding utf8
set size ratio .3
set lmargin 0.25
set pm3d map corners2color c1
#set xtics font \",20\"
unset xtics
set ytics    1.000,   1.000  font \",20\"
set ytics(\"ALA:126\"    1.000,\"TYR:127\"    2.000,\"ILE:128\"    3.000,\"ALA:129\"    4.000,\"GLU:130\"    5.000,\"GLN:131\"    6.000,\"GLU:132\"    7.000,\"HIE:133\"    8.000,\"ARG:134\"    9.000,\"LYS:135\"   10.000,\"LYS:136\"   11.000,\"VAL:137\"   12.000,\"LEU:138\"   13.000,\"ARG:139\"   14.000,\""$h139":140\"   15.000,\""$h140":141\"   16.000,\""$h141":142\"   17.000,\""$h142":143\"   18.000,\""$h143":144\"   19.000,\"LEU:145\"   20.000,\"ILE:146\"   21.000,\"SER:147\"   22.000,\"GLY:148\"   23.000,\"THR:149\"   24.000,\"GLN:150\"   25.000)
#set cbrange [  -0.000:   7.000]
set cbrange [  0.000:   7.000]
set cbtics    0.000,   7.000,5.0 font \",25\"
set palette maxcolors 8
#set palette defined (0 \"#000000\",1 \"#0000cc\",4 \"#00cc00\",7 \"#cc0000\")
#set palette defined (0 \"#000000\",2 \"#000000\",3 \"#00fc02\",4 \"#000000\",5 \"#0101ff\",6 \"#fff600\",7 \"#ff4f00\")
#set palette defined (0 \"#ff7000\",1 \"#ffffff\",5 \"#ffffff\",6 \"#000083\",7 \"#000083\")
set palette defined (0 \"#ffbd00\",1 \"#ffffff\",5 \"#ffffff\",6 \"#0029ff\",7 \"#0029ff\")
set cbtics(\"none\"    0.000,\"extended β\"    1.000,\"isolated β\"    2.000,\"3_10 helix\"    3.000,\"α-helix\"    4.000,\"π-helix\"    5.000,\"turn\"    6.000,\"bend\"    7.000)
#set xlabel \""$var"femtoseconds (1000 fs per ns)\" font \",30\"
set ylabel \"\" font \",25\"
set yrange [   1.000:  26.000]
set xrange [   0.000:25000.000]
splot \"-\" with pm3d title \"$name\"" > dssp.gnu

echo "top dssp"

tail -n +14 dssp_"$name".gnu >> dssp.gnu

echo "data appended"

gnuplot dssp.gnu;  

cp *.png $HOME/$2/
#cp *.sum $HOME/$2/

echo "plot made"

        cd $SCRATCH

pwd

    done


