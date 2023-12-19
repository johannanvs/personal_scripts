#!/bin/bash -l

# Date: 2023-09-18, Johanna von Seth
# Last updated: 2023-09-18

# Edit fasta headers in a msa fasta file.

##########################
##                      ##
## Usage: ONLY MANUALLY ##
##                      ##
##########################


######################
## Script variables ##
######################

# Define dataset names variables
msa_name="msaMuscle.KTH121samples.minBam8X.showDels.showIns.minCallConsDP6.minCons98Perc.Pang169samples.refSeq.outgroup5seqs.AliviewPangEdited" # name of msa fastafile, e.g. "msaMuscle.KTH121samples.minBam8X.showDels.showIns.minCallConsDP1.minCons98Perc.Pang169samples.refSeq.outgroup5seqs.AliviewPangEdited"


# Define paths to input files and directories
dog_dir=/Users/johannavonseth/Documents/programming/bioinformatics/projects/dogs
msa_dir=${dog_dir}/data/intermediate_data/mtDNA/mitogenomes/multiple_sequence_alignment/muscle/edited_msa/202309_september
msa_file="${msa_dir}/${msa_name}.fasta"

# Define output file with fixed headers
msa_headersFixed="${msa_dir}/${msa_name}.headersFixed.fasta"


###########
## Shell ##
###########

# Make sure there is one empty line in between each entry
awk '!previous_empty && />/ {print ""}
     {previous_empty = $0 == ""; print}' ${msa_file} | sed '1{/^$/d;}' > ${msa_headersFixed}


# Fix headers
grep '^>' ${msa_headersFixed}
     # Outgroup sequences
sed -i '' 's/EU789789.1 Canis latrans isolate Coy6a mitochondrion, complete genome/EU789789_Canis_latrans/g' ${msa_headersFixed}
sed -i '' 's/EU789787.1 Canis lupus isolate W2_9805 mitochondrion, complete genome/EU789787_Canis_lupus/g' ${msa_headersFixed}
sed -i '' 's/EU789788.1 Canis lupus isolate W5_9809 mitochondrion, complete genome/EU789788_Canis_lupus/g' ${msa_headersFixed}
sed -i '' 's/MZ042356.1 Canis latrans isolate Coyote.KY.O30238 mitochondrion, complete genome/MZ042356_Canis_latrans/g' ${msa_headersFixed}
sed -i '' 's/NC_008093.1 Canis latrans mitochondrion, complete genome/NC008093_Canis_latrans/g' ${msa_headersFixed}
     # Mapping reference sequence
sed -i '' 's/NC_002008.4_CanFam6.*/NC002008_CanFam6/g' ${msa_headersFixed}
     # Historical skin samples
#sed -i '' 's/NC002008_4_mitochondrion_K/histK/g' ${msa_headersFixed}
     # NCBI samples
sed -i '' 's/_mitochondrion//g' ${msa_headersFixed}


# Add haplogroups to NCBI samples with known haplogroups
hapl_list="${dog_dir}/docs/mtDNA/mitogenome/Pang_et_al_2009_docs/accession_crhap.txt"
accessions=$(cut -f 1 -d ' ' $hapl_list)
for a in $accessions; do hap=$(grep $a $hapl_list | cut -f 2 -d ' '); sed -i "" "s/${a}/${a}_${hap}/g" ${msa_headersFixed}; done

# Replace merged fastafile containing newlines with previous
#mv ${msa_headersFixed} ${msa_file}

###########
###########


###################
## Echo job info ##
###################

# Store duration time in variables
duration=$SECONDS
hours=$(( $duration / 3600 ))
mins=$(( $duration / 60 ))
secs=$(( $duration % 60 ))

echo ""
echo "*************************************************************************"
echo ""
echo "                               JOB INFO:                                 "
echo ""
echo "-------------------------------------------------------------------------"
echo ""
echo -e "Input dataset:" ${dataset}
if [[ -n "$reference" ]]; then
     echo "Outgroup or reference sequence included: yes"
else
     echo "Outgroup or reference sequence included: no"
fi
if [[ -n "$ncbi" ]]; then
     echo "${ncbi} sequences included: yes"
else
     echo "${ncbi} sequences included: no"
fi
echo -e "Output file:"
echo -e ${msa_file}
echo ""
echo "Can now move on to multiple sequence alignment (transfer file to UPPMAX)"
echo ""
echo "-------------------------------------------------------------------------"
echo ""
echo "Execution time (H:M:S):"
echo "$hours:$mins:$secs"
echo ""
echo "*************************************************************************"
echo ""