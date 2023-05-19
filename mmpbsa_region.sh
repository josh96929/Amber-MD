#!/bin/bash

CODE_NAME="$1"
LIST_FILE="$2"

process(){
    analysis_path="$SCRATCH/$CODE_NAME/$study_name/analysis"
    complex_top_path="$SCRATCH/$CODE_NAME/$study_name/out"

    mmpbsa_path="$analysis_path/MMPBSA"
    sub_path="$mmpbsa_path/${substruc}"

    mkdir -p "$sub_path"
    cd $sub_path

    # Set the file names
    COMPLEX_TOP="$sub_path/complex.top"
    RECEPTOR_TOP="$sub_path/receptor.top"
    LIGAND_TOP="$sub_path/ligand.top"

echo "Making mmpbsa.in file"

    cat > "$sub_path/mmpbsa.in" << EOL
&general
debug_printlevel=2
verbose=2,
keep_files=2,
/

&gb
igb=2,
saltcon=0.150,
/

&pb
istrng=0.150,
/

&decomp
idecomp=1,
dec_verbose=1,
/
EOL

echo "Starting MMPBSA.py command"

    # Run MMPBSA calculations:
    MMPBSA.py -O -i $sub_path/mmpbsa.in \
    -o $sub_path/mmpbsa_energy.dat \
    -cp $COMPLEX_TOP \
    -rp $RECEPTOR_TOP \
    -lp $LIGAND_TOP \
    -y $sub_path/snapshots.nc

echo "Post MMPBSA.py command"

    # Collect dat files
    cp $sub_path/mmpbsa_energy.dat ${study_name}_mmpbsa_energy_${substruc}.dat

}

# Load modules
module load ccs/conda/ambertools-21
module load ccs/singularity

while IFS=',' read -r study_name total_residues chainA chainB chainA_name chainB_name chainA_color chainB_color overall_color shift_index alpha2 beta1 beta2 idralpha1 loop_b2a3 alpha3 idralpha2 loop_a3a4 alpha4 idrbeta1 alpha5 beta3 alpha6 alpha7 beta4 beta5 alpha8; do

    substruc=alpha2
    process

    substruc=beta2
    process

    substruc=idralpha1
    process

    substruc=loop_b2a3
    process

    substruc=alpha3
    process

    substruc=idralpha2
    process

    substruc=loop_a3a4
    process

    substruc=alpha4
    process

done < "$LIST_FILE"

# Deactivate conda
conda deactivate


====================================


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
#SBATCH --mail-user=           # where to send email
#SBATCH --account=col_               # name of account to run under


$SCRATCH/scripts_MMPBSA/mmpbsa_region.sh $CODE_NAME $SCRATCH/scripts_MMPBSA/${study_name}.csv
" > "submit_${study_name}_onejob.sh"

done < "$LIST_FILE"

====================================


sbatch --dependency=afterok:1846573 submit_j1_bHLH14a_wt_onejob.sh
sbatch --dependency=afterok:1846573 submit_j1_myc2a_D128I_onejob.sh
sbatch --dependency=afterok:1846573 submit_j1_myc2a_D128N_onejob.sh
sbatch --dependency=afterok:1846573 submit_j1_myc2a_D128P_onejob.sh
sbatch --dependency=afterok:1846573 submit_j1_myc2a_wt_onejob.sh
sbatch --dependency=afterok:1846573 submit_j3_bHLH14a_wt_onejob.sh
sbatch --dependency=afterok:1846573 submit_j3_myc2a_D128I_onejob.sh
sbatch --dependency=afterok:1846573 submit_j3_myc2a_D128N_onejob.sh
sbatch --dependency=afterok:1846573 submit_j3_myc2a_D128P_onejob.sh
sbatch --dependency=afterok:1846573 submit_j3_myc2a_wt_onejob.sh


====================================


testing via command line:

# Load modules
module load ccs/conda/ambertools-21
module load ccs/singularity

CODE_NAME=ferncrest
study_name=j1_myc2a_wt
substruc=alpha2

analysis_path="$SCRATCH/$CODE_NAME/$study_name/analysis"
mmpbsa_path="$analysis_path/MMPBSA"
sub_path="$mmpbsa_path/${substruc}"

COMPLEX_TOP="$sub_path/complex.top"
RECEPTOR_TOP="$sub_path/receptor.top"
LIGAND_TOP="$sub_path/ligand.top"

echo "COMPLEX_TOP:  "$COMPLEX_TOP 
echo "RECEPTOR_TOP: "$RECEPTOR_TOP 
echo "LIGAND_TOP:   "$LIGAND_TOP 

    # Run MMPBSA calculations:
    MMPBSA.py -O -i $sub_path/mmpbsa.in \
    -o $sub_path/mmpbsa_energy.dat \
    -cp $COMPLEX_TOP \
    -rp $RECEPTOR_TOP \
    -lp $LIGAND_TOP \
    -y $sub_path/snapshots.nc




