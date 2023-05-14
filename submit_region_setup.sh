#!/bin/bash

#SBATCH --export=NONE                   # do not export current env to the job
#SBATCH --job-name=mmpbsa               # job name
#SBATCH --time=4-00:00:00               # max job run time dd-hh:mm:ss
#SBATCH --ntasks=1
#SBATCH --output=stdout.%j              # save stdout to file
#SBATCH --error=stderr.%j               # save stderr to file
#SBATCH --partition=SKY32M192_L         # name of the partition

#SBATCH --mail-type=ALL                         # send email on start/end
#SBATCH --mail-user=jrwerk2@g.uky.edu           # where to send email
#SBATCH --account=col_lyuan3_uksr               # name of account to run und


$SCRATCH/scripts_MMPBSA/region_setup.sh ferncrest $SCRATCH/scripts_MMPBSA/list_regions.csv


