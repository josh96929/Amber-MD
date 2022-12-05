#!/bin/bash
#SBATCH --time=59:59        # (REQUIRED)
#SBATCH --job-name=dde 
#SBATCH --nodes=1
#SBATCH -e slurm-%j.err     # Error file for this job.
#SBATCH -o slurm-%j.out     # Output file for this job.
#SBATCH -A col_lyuan3_uksr  # Project allocation account name (REQUIRED)

echo -e "start dssp""\n"
date
echo -e "\n\n"

./dssp.sh remainders25.txt foldedstart_1 

echo -e "start dihedral""\n"
date
echo -e "\n\n"

./dihedral.sh remainders25.txt foldedstart_1

echo -e "start endcap""\n"
date
echo -e "\n\n"

./endcap.sh remainders25.txt foldedstart_1

echo -e "jobs completed""\n"
date
echo -e "\n\n"

