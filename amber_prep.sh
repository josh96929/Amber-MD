#!/bin/bash

#need sequences.txt for argument $1
#input file to be setup in columns (name sequence altname) without trailing returns

directory_setup() {
    mkdir $name
    mkdir $name/analysis
    mkdir $name/angle
    mkdir $name/dssp
    mkdir $name/inp
    mkdir $name/out
    mkdir $name/setup
echo -e $name"\tdirectory_setup\t\tcompleted"
}

format_seq() {
    var=$(perl $SCRATCH/one2three.pl $seq)
    var2="N$var"
    trimmed="$(sed -e 's/[[:space:]]*$//' <<<${var2})"
    insert=$((${#trimmed} - 3))
    seqf=$(echo $trimmed | sed "s/./&C/$insert")    
    declare -gx seqf #="echo $trimmed | sed "s/./&C/$insert"" #gives error if there are trailing white space lines
echo -e $name"\tformat_seq\t\tcompleted"
}

unit_counts_nh() {
    avo=6.0221415*10^23
    dencoeff=3.105/10^26
    adj=1000
    watmol=`grep 'O   WAT' "$name"_nh.pdb|wc -l`
    natmol=`grep 'Na+  Na+' "$name"_nh.pdb|wc -l`
    chlmol=`grep 'Cl-  Cl-' "$name"_nh.pdb|wc -l`
    atomst=`grep 'ATOM' "$name"_nh.pdb|wc -l`
    mM=150

    echo -e "File:\t\t"$name"_nh.pdb
    WAT\t\t"$watmol"
    Na+\t\t"$natmol"
    Cl-\t\t"$chlmol"
    ATOMS (tot)\t"$atomst"\n" >> report_"$name".txt

    numK=`echo "scale=10; $avo*$dencoeff*$mM/$adj*$watmol" |bc`
    declare -gx numKrd=`printf %0.f $numK`

    echo -e "Number of Na+ to bring to "$mM" mM:  "$numKrd" ("$numK")\n\n\n\n" >> report_"$name".txt
    #numKadd=`echo "$natmol + $numKrd" |bc`
echo -e $name"\tunit_counts_nh\t\tcompleted"
}

unit_counts_octNaCl() {
    avo=6.0221415*10^23
    dencoeff=3.105/10^26
    adj=1000
    watmol=`grep 'O   WAT' "$name"_octNaCl.pdb|wc -l`
    natmol=`grep 'Na+  Na+' "$name"_octNaCl.pdb|wc -l`
    chlmol=`grep 'Cl-  Cl-' "$name"_octNaCl.pdb|wc -l`
    atomst=`grep 'ATOM' "$name"_octNaCl.pdb|wc -l`
    mM=150

    echo -e "File:\t\t"$name"_octNaCl.pdb
    WAT\t\t"$watmol"
    Na+\t\t"$natmol"
    Cl-\t\t"$chlmol"
    ATOMS (tot)\t"$atomst"\n" >> report_"$name".txt

    numK=`echo "scale=10; $avo*$dencoeff*$mM/$adj*$watmol" |bc`
    declare -gx numKrd=`printf %0.f $numK`

    echo -e "Number of Na+ to bring to "$mM" mM:  "$numKrd" ("$numK")\n\n\n\n" >> report_"$name".txt
    #numKadd=`echo "$natmol + $numKrd" |bc`
echo -e $name"\tunits_counts_octNaCl\tcompleted"
}

create_pep() {
    echo -e "source leaprc.protein.ff19SB
source leaprc.water.opc
$(echo $name) = sequence { $seqf }
savepdb $(echo $name) $(echo $name).pdb
quit" > leap_create.in

    module load ccs/conda/ambertools-21
    module load ccs/singularity
    tleap -f leap_create.in > leap_create.out
    conda deactivate
echo -e $name"\tcreate_pep\t\tcompleted"
}

molarity_build() {
    #"0" at end of addIons means for tleap to calc num of counter ions to neut system
    echo -e "source leaprc.protein.ff19SB
source leaprc.water.opc
mol = loadpdb "$name".pdb
addIons mol Na+ 0
addIons mol Cl- 0 #might create error
solvateOct mol OPCBOX 1.0
savePdb mol "$name"_nh.pdb #neutralized and hydrated
quit" > leap_counterion.in

    module load ccs/conda/ambertools-21
    module load ccs/singularity
    tleap -f leap_counterion.in > leap_counterion.out
    conda deactivate
echo -e $name"\tmolarity_build\t\tcompleted"
}

final_build() {
    echo -e "source leaprc.protein.ff19SB
source leaprc.water.opc
mol = loadpdb "$name".pdb
addIons mol Na+ 0
addIons mol Cl- 0
solvateOct mol OPCBOX 1.0
addIonsRand mol Na+ "$numKrd" Cl- "$numKrd" #new mod to auto randomize upon addition 
SaveAmberParm mol "$name"_octNaCl.top "$name"_octNaCl.inpcrd
savePdb mol "$name"_octNaCl.pdb #neutral, hydrated, salty
quit" > leap_final.in

    module load ccs/conda/ambertools-21
    module load ccs/singularity
    tleap -f leap_final.in > leap_final.out
    conda deactivate

    cp "$name".pdb $SCRATCH/$name/out/
    cp "$name"_octNaCl.top /mnt/gpfs2_4m/scratch/jrwerk2/$name/out/
    cp "$name"_octNaCl.inpcrd /mnt/gpfs2_4m/scratch/jrwerk2/$name/out/
    cp "$name"_octNaCl.pdb /mnt/gpfs2_4m/scratch/jrwerk2/$name/out/
echo -e $name"\tfinal_build\t\tcompleted"
}



mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')
        seq=$(echo ${array[$i]} | awk '{ print $2 }')
        altname=$(echo ${array[$i]} | awk '{ print $3 }')

        directory_setup

        cd $SCRATCH/$name/setup/
        
        format_seq
        create_pep
        molarity_build
        
        > report_"$name".txt
        
        unit_counts_nh
        final_build
        unit_counts_octNaCl

        cd $SCRATCH
echo -e $name"\t\t\tcomplete"
    done




