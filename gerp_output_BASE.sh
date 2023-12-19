#!/bin/bash -l

#SBATCH -A snic2019-8-331
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH -J gerp_outputs

# Last updated: 2021-07-02, Johanna von Seth

# A bash script to call the python script that estimates load from gerp scores

ancest_rates_file="/home/jonvs/af_L_Dalen_1709/results/gerp/vulpes_lagopus_03May2019_zDWVm_headers_fixed.haploidified.ancestral.rates.gz"
vcf_file="/home/jonvs/af_snakemake/results/all/vcf/all_above_8_cov/vulpes_lagopus_03May2019_zDWVm_headers_fixed.haploidified.8.cov.merged.noMiss.recode.vcf.gz"
scaffold="BASE"
script_dir=/home/jonvs/af_L_Dalen_1709/jvs_scripts/pipeline_scripts/gerp/jvs_version/02_extract_gerp_results


###################
## gerp analysis ##
###################

# Use python script modified from Tom van der Valk to output GERP stats

python3 ${script_dir}/gerp_JvS.py "$ancest_rates_file" "$vcf_file" "$scaffold"


