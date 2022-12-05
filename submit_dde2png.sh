#!/bin/bash
#SBATCH --time=59:59        # (REQUIRED)
#SBATCH --job-name=dde2png 
#SBATCH --nodes=1
#SBATCH -e slurm-%j.err     # Error file for this job.
#SBATCH -o slurm-%j.out     # Output file for this job.
#SBATCH -A col_lyuan3_uksr  # Project allocation account name (REQUIRED)


./dssp2png.sh remainders25.txt foldedstart_1

./dihedral2png.sh remainders25.txt foldedstart_1

./ec2png.sh remainders25.txt foldedstart_1

./bardssp.sh remainders25.txt foldedstart_1

