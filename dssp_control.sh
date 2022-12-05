#!/bin/bash
name="control_126_149_0125"
dir=$SCRATCH/foldedstart

        var='\\n'
echo -e "set term png enhanced size 3000, 1500
set output 'dssp_"$name".png'
set encoding utf8
set size ratio .25
set pm3d map corners2color c1
#set xtics font \",20\"
unset xtics
set ytics    1.000,   1.000  font \",20\"
set ytics (\"ALA:126\"    1.000,\"TYR:127\"    2.000,\"ILE:128\"    3.000,\"ALA:129\"    4.000,\"GLU:130\"    5.000,\"GLN:131\"    6.000,\"GLU:132\"    7.000,\"HIE:133\"    8.000,\"ARG:134\"    9.000,\"LYS:135\"   10.000,\"LYS:136\"   11.000,\"VAL:137\"   12.000,\"LEU:138\"   13.000,\"ARG:139\"   14.000,\"GLU:140\"   15.000,\"LEU:141\"   16.000,\"ASN:142\"   17.000,\"SER:143\"   18.000,\"LEU:144\"   19.000,\"ILE:145\"   20.000,\"SER:146\"   21.000,\"GLY:147\"   22.000,\"THR:148\"   23.000,\"GLN:149\"   24.000)
#set cbrange [  -0.500:   7.500]
set cbrange [  0.000:   7.000]
set cbtics    0.000,   7.000,5.0 font \",20\"
set palette maxcolors 8
#set palette defined (0 \"#000000\",1 \"#0000cc\",4 \"#00cc00\",7 \"#cc0000\")
set palette defined (0 \"#000000\",2 \"#000000\",3 \"#00fc02\",4 \"#000000\",5 \"#0101ff\",6 \"#fff600\",7 \"#ff4f00\")
set cbtics (\"none\"    0.000,\"extended β\"    1.000,\"isolated β\"    2.000,\"3-10 helix\"    3.000,\"α-helix\"    4.000,\"π-helix\"    5.000,\"turn\"    6.000,\"bend\"    7.000)
#set xlabel \""$var"femtoseconds (1000 fs per ns)\" font \",30\"
set ylabel \"\" font \",25\"
set yrange [   1.000:  26.000]
set xrange [   0.000:25000.000]
splot \"-\" with pm3d title \"$name\"" > dssp_0125.gnu

echo "top dssp"

tail -n +14 dssp_"$name".gnu >> dssp_0125.gnu

echo "data appended"

gnuplot dssp_0125.gnu;  cp *.png $HOME

echo "plot made"

        


name="control_126_149_2650"

dir=$SCRATCH/foldedstart

        var='\\n'
echo -e "set term png enhanced size 3000, 1500
set output 'dssp_"$name".png'
set encoding utf8
set size ratio .25
set pm3d map corners2color c1
#set xtics font \",20\"
unset xtics
set ytics    1.000,   1.000  font \",20\"
set ytics(\"ALA:126\"    1.000,\"TYR:127\"    2.000,\"ILE:128\"    3.000,\"ALA:129\"    4.000,\"GLU:130\"    5.000,\"GLN:131\"    6.000,\"GLU:132\"    7.000,\"HIE:133\"    8.000,\"ARG:134\"    9.000,\"LYS:135\"   10.000,\"LYS:136\"   11.000,\"VAL:137\"   12.000,\"LEU:138\"   13.000,\"ARG:139\"   14.000,\"GLU:140\"   15.000,\"LEU:141\"   16.000,\"ASN:142\"   17.000,\"SER:143\"   18.000,\"LEU:144\"   19.000,\"ILE:145\"   20.000,\"SER:146\"   21.000,\"GLY:147\"   22.000,\"THR:148\"   23.000,\"GLN:149\"   24.000)
#set cbrange [  -0.500:   7.500]
set cbrange [  0.000:   7.000]
set cbtics    0.000,   7.000,5.0 font \",20\"
set palette maxcolors 8
#set palette defined (0 \"#000000\",1 \"#0000cc\",4 \"#00cc00\",7 \"#cc0000\")
set palette defined (0 \"#000000\",2 \"#000000\",3 \"#00fc02\",4 \"#000000\",5 \"#0101ff\",6 \"#fff600\",7 \"#ff4f00\")
set cbtics(\"none\"    0.000,\"extended β\"    1.000,\"isolated β\"    2.000,\"3-10 helix\"    3.000,\"α-helix\"    4.000,\"π-helix\"    5.000,\"turn\"    6.000,\"bend\"    7.000)
#set xlabel \""$var"femtoseconds (1000 fs per ns)\" font \",30\"
set ylabel \"\" font \",25\"
set yrange [   1.000:  26.000]
set xrange [   0.000:25000.000]
splot \"-\" with pm3d title \"$name\"" > dssp_2650.gnu

echo "top dssp"

tail -n +14 dssp_"$name".gnu >> dssp_2650.gnu

echo "data appended"

gnuplot dssp_2650.gnu;  cp *.png $HOME

echo "plot made"

        

