#! /bin/bash -l

###########
## USAGE ##
###########

# DO NOT EXECUTE THIS IN A BATCH SCRIPT UNDER ANY CIRCUMSTANCE. LIKE ANY AT ALL. SERIOUSLY.

# Go to the folder from where the script should be initiated.

# Usage in COMMAND LINE:

cd /home/jonvs/arctic_fox/b2016073_nobackup/jvs/snakemake_af_genomics/snakemake_v3_L_Dalen_1709/L_Dalen_1709/jvs_scripts/pipeline_scripts/gerp/jvs_version/02_extract_gerp_results/individual_scripts/

scaffold_ids=$(cat /home/jonvs/arctic_fox/b2016073_nobackup/jvs/snakemake_af_genomics/snakemake_v3_L_Dalen_1709/L_Dalen_1709/jvs_scripts/pipeline_scripts/gerp/jvs_version/vulpes_lagopus_03May2019_zDWVm_headers_fixed.haploidified.ancestral.rates.scf.ids.python.txt)

echo $scaffold_ids

# Copy original file and replace all occurrences of BASE with sample ID
for scaffold in $scaffold_ids; do cp ../gerp_output_BASE.sh gerp_output_"$scaffold".sh; sed -i 's/BASE/'"$scaffold"'/g' gerp_output_"$scaffold".sh; done

# Submit all scripts do slurm queue
#for scaffold in $scaffold_ids; do sbatch -M snowy gerp_output_"$scaffold".sh; done

# Delete all copied and renamed files
#for scaffold in $scaffold_ids; do rm gerp_output_"$scaffold".sh; done


# DO NOT EXECUTE THIS IN A BATCH SCRIPT UNDER ANY CIRCUMSTANCE. LIKE ANY AT ALL. SERIOUSLY.

###########
###########