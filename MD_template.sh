#!/bin/bash

#need sequences.txt for argument $1

#use the following command line:
#sbatch --partition --ntasks --ntasks-per-node --export=<cores>=$cores submit_MHE.sh 


mapfile -t array < $1

j=$(wc -l $1 | awk '{ print $1 }')

for (( i = 0; i <= $j; i++ )) do
        name=$(echo ${array[$i]} | awk '{ print $1 }')

        cd $SCRATCH/$name/setup/
        
        echo -e "#!/bin/bash
#SBATCH --time=13-23:59:59  # (REQUIRED)
#SBATCH --job-name="$name"  
#SBATCH --nodes=1
#SBATCH -e slurm-%j.err     # Error file for this job.
#SBATCH -o slurm-%j.out     # Output file for this job.
#SBATCH -A col_  # Project allocation account name (REQUIRED)

module load spack/0.14.2-1168-20f2a6c
module load ccs/amber/20-cpu-gpu-gcc

cd \$SCRATCH/"$name"/out/

first_ns(){
    mpiexec -np 32 pmemd.MPI -O -i md.in -o "$name"_1.out -p "$name"_octNaCl.top -c "$name"_md0.rst -r "$name"_1.rst -x "$name"_1.trj -e "$name"_1.ene
    ln -s "$name"_1.trj "$name"_1.nc
}

#first_ns

for i in {2..100}
    do
    h=\$((\$i - 1))

    mpiexec -np 32 pmemd.MPI -O -i md.in -o "$name"_"\$i".out -p "$name"_octNaCl.top -c "$name"_"\$h".rst -r "$name"_"\$i".rst -x "$name"_"\$i".trj -e "$name"_"\$i".ene
    ln -s "$name"_"\$i".trj "$name"_"\$i".nc

done


#INPUT:     -i *.in, -p *.top, -c *.inpcrd/*.rst
#OUTPUT:    -o *.out, -ref *.rst, -x *.trj, -e *.ene" > submit_MD.sh

chmod 744 submit_MD.sh

    done

