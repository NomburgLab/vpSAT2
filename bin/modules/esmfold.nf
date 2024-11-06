//============================================================================//
// Default params
//============================================================================//
params.out_dir = "output"
params.ESMFOLD_num_recycles = 4

//============================================================================//
// Define process
//============================================================================//
process esmfold {

  tag "$sampleID"
  publishDir "$params.out_dir/colabfold", mode: "copy"

  input:
  tuple val(sampleID), file(in_fasta)

  output:
  tuple val(sampleID),
    file("${sampleID}.pdb"),
    emit: structure

  script:
  """
  esmfold.sh \
  -i ${in_fasta} \
  -o ${sampleID}.pdb \
  --num_recycles ${params.ESMFOLD_num_recycles}
  """
}
