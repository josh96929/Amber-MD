#!/bin/bash

#need sequences.txt for argument $1

mapfile -t array < $1 #sequences.txt

j=$(wc -l $1 | awk '{ print $1 }')

#########################################################################

mini_template(){
reg=(empty 1.0 2.0 3.0 4.0 5.0 25.0) #restraining energies in kcal/mol

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')
        length=$(echo ${array[$i]} | awk '{ print $2 }')
        end=253 #${#length}
        start=1
        cd $SCRATCH/$name/inp/
        
for k in {1..6}
do
echo -e "*************************************************************************
*****************************    mini$k.in   *****************************
*************************************************************************
Minimzing the system with ${reg[$k]} kcal/mol restraints on peptide, 
500 steps of steepest descent and 500 of conjugated gradient
 &cntrl
   imin=1, 
   ntx=1, 
   irest=0, 
   ntpr=50, 
   ntr=1, 
   maxcyc=1000, 
   ncyc=500, 
   ntmin=1,
   temp0=325.0, 
   ntf=1, 
   ntb=1, 
   cut=9.0, 
   nsnb=10, 
 &end
 Group input for residue restraints: ${reg[$k]} kcal/mol.
 ${reg[$k]}
RES $(echo $start $end)
END
END" > mini$k.in

    done

done
}

#########################################################################

heat_template(){
for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')
        length=$(echo ${array[$i]} | awk '{ print $2 }')
        end=253 #${#length}
        start=1
        cd $SCRATCH/$name/inp/

echo -e "*************************************************************************
*****************************    heat.in    *****************************
*************************************************************************
Heating the system with 25 kcal/mol restraints on DNA, V=const 
 &cntrl
    imin=0, 
    nmropt=1,
    ntx=1,
    ntpr=500,
    ntwr=500,
    ntwx=500,
    ntwe=500,
    ioutfm=1,
    ntr=1,
    nstlim=50000,
    nscm=5000,
    dt=0.002,
    t=0.0,
    ntt=1,
    tempi=100.0,
    temp0=325.0, 
    ntp=0,
    ntc=2,
    ntf=2, 
    ntb=1,
    cut=9.0,
 &end
Heating from 100 to 325 K
 &wt type='TEMP0', istep1=0,    istep2=5000,  value1=100.0, value2=325.0,  &end
 &wt type='TEMP0', istep1=5001, istep2=50000, value1=325.0, value2=325.0,  &end
 &wt type='END',  &end
Group input for DNA restraints: 25 kcal/mol.
 25.0
RES $(echo $start $end)
END
END" > heat.in

done
}

#########################################################################

eq_template(){ 
reg=(empty 1.0 2.0 3.0 4.0 5.0) #restraining energies in kcal/mol

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')
        length=$(echo ${array[$i]} | awk '{ print $2 }')
        end=253 #${#length}
        start=1
        cd $SCRATCH/$name/inp/

for k in {1..5}
do
echo -e "*************************************************************************
*****************************    eq$k.in     *****************************
*************************************************************************
Equilibrating the system with ${reg[$k]} kcal/mol restraints on DNA, during 50ps, 
at constant T= 325K & P= 1Atm and coupling = 0.2 
 &cntrl
    imin=0,  
    ntx=1, 
    ntpr=500, 
    ntwr=500, 
    ntwx=500, 
    ntwe=500, 
    ioutfm=1, 
    ntr=1, 
    nstlim=25000, 
    nscm=5000, 
    dt=0.002, 
    t=0.0, 
    ntt=1, 
    temp0=325.0, 
    tautp=0.2, 
    ntp=1, 
    taup=0.2, 
    ntc=2, 
    ntf=2, 
    ntb=2, 
    cut=9.0, 
 &end
Group input for DNA restraints: ${reg[$k]} kcal/mol.
 ${reg[$k]}
RES $(echo $start $end)
END
END" > eq$k.in

    done

echo -e "*************************************************************************
*****************************    eq05.in    *****************************
*************************************************************************
Equilibrating the system with 0.5 kcal/mol restraints on DNA, during 50ps, 
at constant T= 325K & P= 1Atm and coupling = 0.2
 &cntrl
    imin=0, 
    ntx=5, 
    irest=1,
    ntpr=500, 
    ntwr=500, 
    ntwx=500, 
    ntwe=500, 
    ioutfm=1
    ntr=1,
    nstlim=25000, 
    nscm=5000,
    dt=0.002,
    t=0.0,
    ntt=1, 
    temp0=325.0, 
    tautp=0.2,
    ntp=1,
    taup=0.2,
    ntc=2,
    ntf=2, 
    ntb=2,   
    cut=9.0,
 &end
Group input for DNA restraints: 0.5 kcal/mol.
 0.5
RES $(echo $start $end)
END
END" > eq05.in

done
}

#########################################################################

md0md_template(){
for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')
        length=$(echo ${array[$i]} | awk '{ print $2 }')
        end=253 #${#length}
        start=1
        cd $SCRATCH/$name/inp/

echo -e "*************************************************************************
*****************************    md0.in     *****************************
*************************************************************************
Equilibrating the system without restraints during 50ps at constant 
T= 325K & P= 1Atm and coupling = 5.0
 &cntrl
    imin=0, 
    ntx=5, 
    irest=1, 
    ntpr=500, 
    ntwr=500, 
    ntwx=500, 
    ntwe=500, 
    ioutfm=1, 
    nstlim=25000, 
    nscm=5000, 
    dt=0.002, 
    t=0.0, 
    ntt=1, 
    temp0=325.0, 
    tautp=5.0, 
    ntp=1, 
    taup=5.0, 
    ntc=2, 
    ntf=2, 
    ntb=2, 
    cut=9.0, 
 &end" > md0.in

echo -e "*************************************************************************
*****************************    md.in      *****************************
*************************************************************************
1 ns MD production at constant T= 325K & P= 1Atm and coupling = 5.0
 &cntrl
    imin=0, 
    ntx=5, 
    irest=1,
    ntpr=500, 
    ntwr=500, 
    ntwx=500, 
    ntwe=0, 
    iwrap=1,
    ioutfm=1,
    nstlim=500000, 
    nscm=5000, 
    dt=0.002, 
    t=0.0, 
    ntt=1,
    temp0=325.0, 
    tautp=5.0, 
    ntp=1, 
    taup=5.0,
    ntc=2, 
    ntf=2, 
    ntb=2, 
    cut=9.0,
 &end" > md.in

cp $SCRATCH/$name/inp/*.in $SCRATCH/$name/out/
 done
}

#########################################################################

mini_template
heat_template
eq_template
md0md_template


#cp $SCRATCH/$name/inp/*.in $SCRATCH/$name/out/
