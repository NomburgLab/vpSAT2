#!/usr/bin/env bash

#------------------------------------------------------------------------------#
# Defining usage and setting inputs
#------------------------------------------------------------------------------#
usage() {
        echo "
        This script runs ESM-fold to predict an input protein structure.

        Required params:
        -i --IN_FASTA {path}
            Path to an input fasta containing a single protein sequence.
        -o --OUT_FILE {path}
            Path to the ouput structure in pdb format.

        Optional params:
        -n --NUM_RECYCLES {4}
            Number of model recycles. 4 is the default.
        "
}

#If less than 2 options are input, show usage and exit script.
if [ $# -le 3 ] ; then
        usage
        exit 1
fi

#Setting input
while getopts i:o:n: option ; do
        case "${option}"
        in
                i) IN_FASTA=${OPTARG};;
                o) OUT_FILE=${OPTARG};;
                n) NUM_RECYCLES=${OPTARG};;
        esac
done

#------------------------------------------------------------------------------#
# Set defaults and constants
#------------------------------------------------------------------------------#
# Defaults
NUM_RECYCLES=${NUM_RECYCLES:-4}

#------------------------------------------------------------------------------#
# Validate inputs and program availablity
#------------------------------------------------------------------------------#
if ! command -v esm-fold ; then
    echo "esm-fold not detected! there should be an executible in path called esm-fold"
    exit 1
fi

if [[ ! -f $IN_FASTA ]] ; then 
    echo "Cannot find IN_FASTA, $IN_FASTA"
    exit 1
fi

if [ "$(grep -c '^>' "$IN_FASTA")" -gt 1 ] ; then
    echo "There are more than one protein in the IN_FASTA."
    exit 1
fi

#------------------------------------------------------------------------------#
# Main
#------------------------------------------------------------------------------#
echo "
$0 inputs:

IN_FASTA: $IN_FASTA
OUT_FILE: $OUT_FILE
NUM_RECYCLES: $NUM_RECYCLES
"

echo "$0: Started at $(date)"

esm-fold \
-i $IN_FASTA \
-o ${OUT_FILE}_result

mv ${OUT_FILE}_result/*pdb ${OUT_FILE} && rm -r ${OUT_FILE}_result

echo "$0: Finished at $(date)"