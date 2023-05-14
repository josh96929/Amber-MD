#!/bin/bash

CODE_NAME="$1"
LIST_FILE="$2"

while IFS=',' read -r study_name total_residues chainA chainB chainA_name chainB_name chainA_color chainB_color overall_color shift_index alpha2 beta1 beta2 idralpha1 loop_b2a3 alpha3 idralpha2 loop_a3a4 alpha4 idrbeta1 alpha5 beta3 alpha6 alpha7 beta4 beta5 alpha8; do
    analysis_path="$SCRATCH/$CODE_NAME/$study_name/analysis"
    mmpbsa_path="$analysis_path/MMPBSA"

        echo -e "#!/bin/bash
#SBATCH --export=NONE                   # do not export current env to the job
#SBATCH --job-name=mmpbsa                # job name
#SBATCH --time=2-00:00:00               # max job run time dd-hh:mm:ss
#SBATCH --ntasks=1
#SBATCH --output=stdout.%j              # save stdout to file
#SBATCH --error=stderr.%j               # save stderr to file
#SBATCH --partition=SKY32M192_L         # name of the partition

#SBATCH --mail-type=ALL                         # send email on start/end
#SBATCH --mail-user=jrwerk2@g.uky.edu           # where to send email
#SBATCH --account=col_lyuan3_uksr               # name of account to run under


$SCRATCH/scripts_MMPBSA/mmpbsa_region.sh $CODE_NAME $SCRATCH/scripts_MMPBSA/${study_name}.csv
" > "submit_${study_name}_onejob.sh"

done < "$LIST_FILE"

