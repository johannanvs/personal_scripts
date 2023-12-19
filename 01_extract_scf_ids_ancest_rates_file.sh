#!/bin/bash -l

#SBATCH -A snic2019-8-331
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 1-00:00:00
#SBATCH -J extr_scf_ancest_rate

# Date created: 2021-02-25, Johanna von Seth
# Last updated: 2021-06-30

# Run python script to extract unique scaffold id's in ancestral rates file.

python3 01_extract_scf_ids_ancest_rates_file.py
