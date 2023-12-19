#!/bin/bash -l

#SBATCH -A NAISS2023-22-48
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 5-00:00:00
#SBATCH -J indel_realigner_targets

# Date: 2023-03-06, Johanna von Seth 
# Last updated: 2023-05-24

# Script modified to bash script from GenErode, and adjusted to a sbatch script.

# Create a realignment target list to realign indels to improve alignments to reference and reduce the amount of false positive SNPs


######################
## Script variables ##
######################

# General variables 
threads=8 # make sure it matches the number of cores requested above in #SBATCH
generode="/proj/snic2022-6-388/jvs/GenErode"
script_dir=${generode}/jvs_scripts/bash_converted_workflow_scripts/3.1_bam_rmdup_realign_indels
REF_NAME=$(grep 'ref_path' ${generode}/config/config.yaml | grep -v 'gerp' | cut -f 2 -d '"' | awk -F/ '{print $NF}' | sed 's/\.f.*//g')
sample=${1}
dataset=${2}

# Script specific parameters
input_ref=$(grep 'ref_path' ${generode}/config/config.yaml | grep -v 'gerp' | cut -f 2 -d '"')
input_bam="${generode}/results/${dataset}/mapping/${REF_NAME}/${sample}.merged.rmdup.merged.bam"
output_target_list="${generode}/results/${dataset}/mapping/${REF_NAME}/${sample}.merged.rmdup.merged.realn_targets.list"
log="${generode}/results/logs/3.1_bam_rmdup_realign_indels/${dataset}/${REF_NAME}/${sample}_indel_realigner_targets.log"

# Define Singularity image
singularity_image="docker://broadinstitute/gatk3:3.7-0"


###################
## Echo job info ##
###################

echo ""
echo "*************************************************************************"
echo "                               JOB INFO:                                 "
echo "-------------------------------------------------------------------------"
echo -e "Date:"
date
echo -e "Sample:" ${sample}
echo -e "Input file:" ${input_bam}
echo -e "Output file: ${output_target_list}"
echo -e "Log file:" ${log}
echo ""
echo -e "Slurm job ID:" $SLURM_JOB_ID
echo -e "Slurm job name:" $SLURM_JOB_NAME
echo "*************************************************************************"
echo ""


###########
## Shell ##
###########

singularity run ${singularity_image} java -jar /usr/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ${input_ref} -I ${input_bam} -o ${output_target_list} -nt ${threads} 2> ${log} &&

# Submit next job if managed to run
sbatch ${script_dir}/17_indel_realigner.sh ${sample} ${dataset} &&
echo ">>> Job finished, next job ${script_dir}/17_indel_realigner.sh submitted to slurm queue."

###########
###########


echo ""
echo "-------------------------------------------------------------------------"
echo "Job finished by:"
date
echo "-------------------------------------------------------------------------"
echo ""
echo ""


