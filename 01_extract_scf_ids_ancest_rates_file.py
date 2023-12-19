#!/usr/bin/python3

# Date created: 2021-02-25, Johanna von Seth
# Last updated: 2021-06-30

# Extract unique scaffold id's from ancestral rates file (gerp output)

# ancestral rates file
ancest_file="/home/jonvs/arctic_fox/b2016073_nobackup/jvs/snakemake_af_genomics/snakemake_v3_L_Dalen_1709/L_Dalen_1709/results/gerp/vulpes_lagopus_03May2019_zDWVm_headers_fixed.haploidified.ancestral.rates.gz"
ids_file="vulpes_lagopus_03May2019_zDWVm_headers_fixed.haploidified.ancestral.rates.scf.ids.python.txt"

# import modules
import gzip

with gzip.open(ancest_file, 'rt') as infile:
	# initiate id list
	scf_id = []
	for line in infile:
		column = line.strip().split("\t")
		scaffold = column[0]
		if scaffold in scf_id:
			continue
		else:
			scf_id.append(scaffold)
	with open(ids_file, 'w') as outfile:
		for i in scf_id:
			scf_out = i + "\n"
			outfile.write(scf_out)