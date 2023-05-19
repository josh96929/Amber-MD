#!/bin/bash

#need sequences.txt for argument $1

#use the following command line:
#sbatch --partition --ntasks --ntasks-per-node --export=<cores>=$cores submit_MHE.sh 

cores=32

mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

echo $j

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $SCRATCH/$name/setup/
echo $i
echo $name       
pwd
ins="${name:0-1}"
beg="${name:0:4}"

        echo -e "#!/bin/bash
#SBATCH --time=04-02:59:59  # (REQUIRED)
#SBATCH --job-name="$(echo $beg"_"$ins)"  
#SBATCH --nodes=1
#SBATCH -e slurm-%j.err     # Error file for this job.
#SBATCH -o slurm-%j.out     # Output file for this job.
#SBATCH -A col_  # Project allocation account name (REQUIRED)

module load spack/0.14.2-1168-20f2a6c
module load ccs/amber/20-cpu-gpu-gcc

cd \$SCRATCH/"$name"/out/


#MHE

mpiexec -np $cores pmemd.MPI -O -i mini6.in -o "$name"_mini6.out -p "$name"_octNaCl.top -c "$name"_octNaCl.inpcrd -ref "$name"_octNaCl.inpcrd -r "$name"_mini6.rst -x "$name"_mini6.trj -e "$name"_mini6.ene

mpiexec -np $cores pmemd.MPI -O -i heat.in -o "$name"_heat.out -p "$name"_octNaCl.top -c "$name"_mini6.rst -ref "$name"_mini6.rst -r "$name"_heat.rst -x "$name"_heat.trj -e "$name"_heat.ene

mpiexec -np $cores pmemd.MPI -O -i mini5.in -o "$name"_mini5.out -p "$name"_octNaCl.top -c "$name"_heat.rst -ref "$name"_octNaCl.inpcrd -r "$name"_mini5.rst -x "$name"_mini5.trj -e "$name"_mini5.ene

mpiexec -np $cores pmemd.MPI -O -i eq5.in -o "$name"_eq5.out -p "$name"_octNaCl.top -c "$name"_mini5.rst -ref "$name"_mini5.rst -r "$name"_eq5.rst -x "$name"_eq5.trj -e "$name"_eq5.ene

mpiexec -np $cores pmemd.MPI -O -i mini4.in -o "$name"_mini4.out -p "$name"_octNaCl.top -c "$name"_eq5.rst -ref "$name"_eq5.rst -r "$name"_mini4.rst -x "$name"_mini4.trj -e "$name"_mini4.ene

mpiexec -np $cores pmemd.MPI -O -i eq4.in -o "$name"_eq4.out -p "$name"_octNaCl.top -c "$name"_mini4.rst -ref "$name"_mini4.rst -r "$name"_eq4.rst -x "$name"_eq4.trj -e "$name"_eq4.ene

mpiexec -np $cores pmemd.MPI -O -i mini3.in -o "$name"_mini3.out -p "$name"_octNaCl.top -c "$name"_eq4.rst -ref "$name"_eq4.rst -r "$name"_mini3.rst -x "$name"_mini3.trj -e "$name"_mini3.ene

mpiexec -np $cores pmemd.MPI -O -i eq3.in -o "$name"_eq3.out -p "$name"_octNaCl.top -c "$name"_mini3.rst -ref "$name"_mini3.rst -r "$name"_eq3.rst -x "$name"_eq3.trj -e "$name"_eq3.ene

mpiexec -np $cores pmemd.MPI -O -i mini2.in -o "$name"_mini2.out -p "$name"_octNaCl.top -c "$name"_eq3.rst -ref "$name"_eq3.rst -r "$name"_mini2.rst -x "$name"_mini2.trj -e "$name"_mini2.ene

mpiexec -np $cores pmemd.MPI -O -i eq2.in -o "$name"_eq2.out -p "$name"_octNaCl.top -c "$name"_mini2.rst -ref "$name"_mini2.rst -r "$name"_eq2.rst -x "$name"_eq2.trj -e "$name"_eq2.ene

mpiexec -np $cores pmemd.MPI -O -i mini1.in -o "$name"_mini1.out -p "$name"_octNaCl.top -c "$name"_eq2.rst -ref "$name"_eq2.rst -r "$name"_mini1.rst -x "$name"_mini1.trj -e "$name"_mini1.ene

mpiexec -np $cores pmemd.MPI -O -i eq1.in -o "$name"_eq1.out -p "$name"_octNaCl.top -c "$name"_mini1.rst -ref "$name"_mini1.rst -r "$name"_eq1.rst -x "$name"_eq1.trj -e "$name"_eq1.ene

mpiexec -np $cores pmemd.MPI -O -i eq05.in -o "$name"_eq05.out -p "$name"_octNaCl.top -c "$name"_eq1.rst -ref "$name"_eq1.rst -r "$name"_eq05.rst -x "$name"_eq05.trj -e "$name"_eq05.ene

mpiexec -np $cores pmemd.MPI -O -i md0.in -o "$name"_md0.out -p "$name"_octNaCl.top -c "$name"_eq05.rst -r "$name"_md0.rst -x "$name"_md0.trj -e "$name"_md0.ene


#MD

first_ns(){
    mpiexec -np $cores pmemd.MPI -O -i md.in -o "$name"_1.out -p "$name"_octNaCl.top -c "$name"_md0.rst -r "$name"_1.rst -x "$name"_1.trj -e "$name"_1.ene
   # chmod 444 "$name"_1.out
   # chmod 444 "$name"_1.rst
   # chmod 444 "$name"_1.trj
   # chmod 444 "$name"_1.ene
    ln -s "$name"_1.trj "$name"_1.nc
}

first_ns

for i in {2..25}
    do
    h=\$((\$i - 1))

    mpiexec -np $cores pmemd.MPI -O -i md.in -o "$name"_"\$i".out -p "$name"_octNaCl.top -c "$name"_"\$h".rst -r "$name"_"\$i".rst -x "$name"_"\$i".trj -e "$name"_"\$i".ene
   # chmod 444 "$name"_"\$i".out
   # chmod 444 "$name"_"\$i".rst
   # chmod 444 "$name"_"\$i".trj
   # chmod 444 "$name"_"\$i".ene
    ln -s "$name"_"\$i".trj "$name"_"\$i".nc

done


#INPUT:     -i *.in, -p *.top, -c *.inpcrd/*.rst
#OUTPUT:    -o *.out, -ref *.rst, -x *.trj, -e *.ene" > submit_MHEMD.sh

chmod 744 submit_MHEMD.sh
cd $SCRATCH

    done

