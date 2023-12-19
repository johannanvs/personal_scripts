#!/bin/bash -l

# Created: 2023-03-06, Johanna von Seth
# Last updated: 2023-12-05

## Script to submit jobs (converted to sbatch scripts) included in 3.1_bam_rmdup_realign_indels from the GenErode workflow.

#######################
## GENERAL VARIABLES ##
#######################

# Directories
SCRIPT_DIR=/proj/snic2022-6-388/jvs/GenErode/jvs_scripts/bash_converted_workflow_scripts/3.1_bam_rmdup_realign_indels
GENERODE_DIR=/proj/snic2022-6-388/jvs/GenErode

# store list of script specific entries in variables
dataset="historical" # historical or modern
samples_list="${GENERODE_DIR}/config/historical_samples_path.txt" # modern or historical samples list in config folder
samples_index=$(cat $samples_list | cut -f 1 -d ' ' | grep -v 'samplename_index_lane' | cut -f 1,2 -d '_')
#samples=$(cat $samples_list | cut -f 1 -d ' ' | grep -v 'samplename_index_lane' | cut -f 1 -d '_')
samples="K1011 K1012 K102 K103 K104 K105 K106 K107 K108 K109 K111 K121 K122 K123 K1310 K131 K13111 K1312 K1313 K13141 K13142 K1315 K1316 K1317 K13181 K13191 K13192 K13193 K13194 K13195 K13201 K132 K13202 K13203 K13204 K13205 K13206 K13207 K13208 K13209 K13211 K13212 K13213 K13214 K13215 K13221 K13222 K13223 K13224 K13225 K13231 K13232 K13233 K13234 K13241 K13242 K13243 K13244 K13245 K13251 K13252 K13253 K13254 K13255 K13256 K13261 K13262 K13271 K13272 K13273 K13281 K13282 K13291 K13292 K13301 K133 K13302 K13311 K13312 K13321 K13322 K13323 K13331 K13332 K13333 K13334 K13335 K13341 K13342 K13343 K13344 K13345 K13346 K13347 K13351 K13352 K13361 K13362 K13363 K13364 K13365 K13366 K13371 K13372 K134 K135 K136 K137 K138 K139 K41 K42 K43 K44 K51 K52 K610 K611 K62 K631 K64 K65 K66 K67 K68 K69 K6eleven K71 K72 K73 K81"


#############
## Scripts ##
#############

merge_modern_bams_per_index="${SCRIPT_DIR}/01_merge_modern_bams_per_index.sh"
index_merged_index_bams="${SCRIPT_DIR}/02_index_merged_index_bams.sh"
merged_index_bam_stats="${SCRIPT_DIR}/03_merged_index_bam_stats.sh"
merged_index_bam_qualimap="${SCRIPT_DIR}/04_merged_index_bam_qualimap.sh"
rmdup_modern_bams="${SCRIPT_DIR}/06_rmdup_modern_bams.sh"
index_rmdup_bams="${SCRIPT_DIR}/07_index_rmdup_bams.sh"
rmdup_bam_stats="${SCRIPT_DIR}/08_rmdup_bam_stats.sh"
merge_modern_bams_per_sample="${SCRIPT_DIR}/11_merge_modern_bams_per_sample.sh"
index_merged_sample_bams="${SCRIPT_DIR}/12_index_merged_sample_bams.sh"
merged_sample_bam_stats="${SCRIPT_DIR}/13_merged_sample_bam_stats.sh"
merged_sample_bam_qualimap="${SCRIPT_DIR}/14_merged_sample_bam_qualimap.sh"
indel_realigner_targets="${SCRIPT_DIR}/16_indel_realigner_targets.sh"
indel_realigner="${SCRIPT_DIR}/17_indel_realigner.sh"
index_realigned_bams="${SCRIPT_DIR}/18_index_realigned_bams.sh"
realigned_bam_stats="${SCRIPT_DIR}/19_realigned_bam_stats.sh"
realigned_bam_fastqc="${SCRIPT_DIR}/20_realigned_bam_fastqc.sh"
realigned_bam_qualimap="${SCRIPT_DIR}/21_realigned_bam_qualimap.sh"
realigned_bam_depth="${SCRIPT_DIR}/22_realigned_bam_depth_awk_more_decimals.sh"
realigned_bam_depth_noMito="${SCRIPT_DIR}/22_realigned_bam_depth_awk_more_decimals_no_mitogenome.sh"
dp_hist_plot="${SCRIPT_DIR}/23_plot_dp_hist.sh"


####################
## Jobs to submit ##
####################

## 01_merge_modern_bams_per_index ##
#for sample in $samples_index; do sbatch ${merge_modern_bams_per_index} ${sample}; done

## 02_index_merged_index_bams ##
#for sample in $samples_index; do sbatch ${index_merged_index_bams} ${sample} ${dataset}; done

## 03_merged_index_bam_stats ##
#for sample in $samples_index; do sbatch ${merged_index_bam_stats} ${sample} ${dataset}; done
# script 04_merged_index_bam_qualimap.sh automatically submitted by this script

## 04_merged_index_bam_qualimap ##
#for sample in $samples_index; do sbatch ${merged_index_bam_qualimap} ${sample} ${dataset}; done

## 06_rmdup_modern_bams ##
#for sample in $samples_index; do sbatch ${rmdup_modern_bams} ${sample}; done

## 07_index_rmdup_bams ##
#for sample in $samples_index; do sbatch ${index_rmdup_bams} ${sample} ${dataset}; done

## 08_rmdup_bam_stats ##
#for sample in $samples_index; do sbatch ${rmdup_bam_stats} ${sample} ${dataset}; done
# script 09_rmdup_bam_qualimap.sh automatically submitted by this script

## 11_merge_modern_bams_per_sample ##
#for sample in $samples; do sbatch ${merge_modern_bams_per_sample} ${sample}; done

## 12_index_merged_sample_bams ##
#for sample in $samples; do sbatch ${index_merged_sample_bams} ${sample} ${dataset}; done

## 13_merged_sample_bam_stats ##
#for sample in $samples; do sbatch ${merged_sample_bam_stats} ${sample} ${dataset}; done

## 14_merged_sample_bam_qualimap ##
#for sample in $samples; do sbatch ${merged_sample_bam_qualimap} ${sample} ${dataset}; done

## 16_indel_realigner_targets ##
#for sample in $samples; do sbatch ${indel_realigner_targets} ${sample} ${dataset}; done
# script 17_indel_realigner automatically submitted by this script

## 17_indel_realigner ##
#for sample in $samples; do sbatch ${indel_realigner} ${sample} ${dataset}; done
# script 18_index_realigned_bams automatically submitted by this script

## 18_index_realigned_bams ##
#for sample in $samples; do sbatch ${index_realigned_bams} ${sample} ${dataset}; done
# script 19_realigned_bam_stats can be automatically submitted by this script if activated in 18_index_realigned_bams

## 19_realigned_bam_stats ##
#for sample in $samples; do sbatch ${realigned_bam_stats} ${sample} ${dataset}; done
# script 20_realigned_bam_fastqc automatically submitted by this script

## 20_realigned_bam_fastqc ##
#for sample in $samples; do sbatch ${realigned_bam_fastqc} ${sample} ${dataset}; done
# script 21_realigned_bam_qualimap automatically submitted by this script

## 21_realigned_bam_qualimap ##
#for sample in $samples; do sbatch ${realigned_bam_qualimap} ${sample} ${dataset}; done

## 22_realigned_bam_depth ##
#for sample in $samples; do sbatch ${realigned_bam_depth} ${sample} ${dataset}; done

## 22_realigned_bam_depth_noMito ##
#for sample in $samples; do sbatch ${realigned_bam_depth_noMito} ${sample} ${dataset}; done

## 23_dp_hist_plot ##
for sample in $samples; do sbatch ${dp_hist_plot} ${sample} ${dataset}; done


#################################################################################################################################
#################################################################################################################################


#####################
## CLUSTER-RELATED ##
#####################

# cancel jobs
#scancel --jobname ${SCRIPT_DIR}/${index_realigned_bams}
