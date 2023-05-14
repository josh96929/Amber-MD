#!/bin/bash

CODE_NAME="$1"
LIST_FILE="$2"

process(){
    analysis_path="$SCRATCH/$CODE_NAME/$study_name/analysis"
    mmpbsa_path="$analysis_path/MMPBSA"
    sub_path="$mmpbsa_path/${substruc}"
    prmtop_path="$SCRATCH/$CODE_NAME/$study_name/out"

    mkdir -p "$sub_path"
    cd $sub_path

    # Set the residue ranges and file names
    RECEPTOR_RESIDUES_BEFORE=${!substruc}
    LIGAND_RESIDUES_BEFORE="$chainB"
    INPUT_TOP="$sub_path/${substruc}_${chainB_name}.top"
    COMPLEX_TOP="$sub_path/complex.top"
    RECEPTOR_TOP="$sub_path/receptor.top"
    LIGAND_TOP="$sub_path/ligand.top"

    # Get start and end of receptor residues
    IFS='-' read -r -a receptor_before <<< "$RECEPTOR_RESIDUES_BEFORE"
    receptor_start_before=${receptor_before[0]}
    receptor_end_before=${receptor_before[1]}
    echo $receptor_start_before
    echo $receptor_end_before

    # Get start and end of ligand residues
    IFS='-' read -r -a ligand_before <<< "$LIGAND_RESIDUES_BEFORE"
    ligand_start_before=${ligand_before[0]}
    ligand_end_before=${ligand_before[1]}
    echo $ligand_start_before
    echo $ligand_end_before

    # Calculate new residue ranges
    receptor_start_after=1
    receptor_end_after=$(( receptor_end_before - receptor_start_before + 1 ))

    ligand_start_after=$(( receptor_end_after + 1 ))
    ligand_end_after=$(( ligand_start_after + ligand_end_before - ligand_start_before ))

    # Construct new residue range strings
    RECEPTOR_RESIDUES_AFTER="$receptor_start_after-$receptor_end_after"
    LIGAND_RESIDUES_AFTER="$ligand_start_after-$ligand_end_after"

    stripA=1
    stripB=$(( receptor_start_before - 1 ))
    stripC=$(( receptor_end_before + 1 ))
    stripD=$(( ligand_start_before - 1 ))

    stripAB="$stripA-$stripB"
    stripCD="$stripC-$stripD"

    echo ""
    echo "STUDY_NAME: "$study_name 
    echo "SUBSTRUC:   "${substruc}
    pwd
    echo $sub_path 
    echo "ORIGINAL RECEPTOR RANGE: "$RECEPTOR_RESIDUES_BEFORE
    echo "ORIGINAL LIGAND RANGE:   "$LIGAND_RESIDUES_BEFORE 
    echo "NEW RECEPTOR RANGE:      "$RECEPTOR_RESIDUES_AFTER 
    echo "NEW LIGAND RANGE:        "$LIGAND_RESIDUES_AFTER 
    echo "STRIP FRONT RANGE:       "$stripAB 
    echo "STRIP MIDDLE RANGE:      "$stripCD
    echo "INPUT_TOP:    "$INPUT_TOP 
    echo "COMPLEX_TOP:  "$COMPLEX_TOP 
    echo "RECEPTOR_TOP: "$RECEPTOR_TOP 
    echo "LIGAND_TOP:   "$LIGAND_TOP 
    echo ""

    # Set up cpptraj input
    echo "parm $SCRATCH/$CODE_NAME/$study_name/out/${study_name}_octNaCl.top" > "$sub_path/cpptraj_prmtop.in"

#    for i in $(seq 11 999); do
#        traj_file="$SCRATCH/$CODE_NAME/$study_name/out/${study_name}_${i}.trj"
#        if [ -f "$traj_file" ]; then
#           echo "trajin $traj_file 1 1000 20" >> "$sub_path/cpptraj_prmtop.in"
#        else
#            break
#        fi
#    done

#parmstrip !(:${RECEPTOR_RESIDUES_BEFORE},${LIGAND_RESIDUES_BEFORE},WAT,Na+,Cl-)

    cat >> "$sub_path/cpptraj_prmtop.in" << EOL
parmstrip :$stripAB,$stripCD,WAT,Na+,Cl-
parmwrite out $sub_path/${substruc}_${chainB_name}.top
go
EOL

    cat "$sub_path/cpptraj_prmtop.in" | tail -n 10

    cp $SCRATCH/$CODE_NAME/$study_name/out/${study_name}_octNaCl.top $sub_path/
    rm $sub_path/${substruc}_${chainB_name}.top

    # Run cpptraj
    cpptraj -i "$sub_path/cpptraj_prmtop.in"

=====

    # Set up cpptraj input
    echo "parm $SCRATCH/$CODE_NAME/$study_name/out/${study_name}_octNaCl.top" > "$sub_path/cpptraj_snap.in"
 #   echo "parm $sub_path/${substruc}_${chainB_name}.top" > "$sub_path/cpptraj_snap.in"

    for i in $(seq 11 999); do
        traj_file="$SCRATCH/$CODE_NAME/$study_name/out/${study_name}_${i}.trj"
        if [ -f "$traj_file" ]; then
            echo "trajin $traj_file 1 1000 20" >> "$sub_path/cpptraj_snap.in"
        else
            break
        fi
    done

#strip !(:${RECEPTOR_RESIDUES_BEFORE},${LIGAND_RESIDUES_BEFORE},WAT,Na+,Cl-)
#trajout $sub_path/snapshots.nc netcdf parm $sub_path/${substruc}_${chainB_name}.top

    cat >> "$sub_path/cpptraj_snap.in" << EOL
strip :$stripAB,$stripCD,WAT,Na+,Cl-
trajout $sub_path/snapshots.nc netcdf
go
EOL

    #cat "$sub_path/cpptraj_snap.in" | tail -n 10

    rm snapshots.nc

    # Run cpptraj
    cpptraj -i "$sub_path/cpptraj_snap.in"

======

    # Clear out old top files
    rm $sub_path/complex.top
    rm $sub_path/receptor.top
    rm $sub_path/ligand.top

    echo $COMPLEX_TOP 
    echo $RECEPTOR_TOP 
    echo $LIGAND_TOP 
    echo :$RECEPTOR_RESIDUES_AFTER

    # Run ante-MMPBSA.py with adjusted chainA and paths
    command="ante-MMPBSA.py \
    -p $INPUT_TOP \
    -c $COMPLEX_TOP \
    -r $RECEPTOR_TOP \
    -l $LIGAND_TOP \
    -s :WAT,Na+,Cl- \
    -m :$RECEPTOR_RESIDUES_AFTER \
    --radii=mbondi2"

    echo $command
    eval $command
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



