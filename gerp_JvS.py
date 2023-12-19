#!/usr/bin/python3

# Last updated: 2021-03-10, Johanna von Seth

# A script to output results from GERP analysis.

# The merged vcf file should only contain high coverage samples,
# and have been filtered for missing sites.

#################################################################################
##                                                                             ##
## Usage: python3 nameofscript.py ancestral_rates.gz merged.vcf.gz scaffold_id ##
##                                                                             ##
#################################################################################


###########################
# IMPORT REQUIRED MODULES #
###########################

import gzip
import sys
from itertools import islice

###########################
###########################


#####################
## DEFINE FUNCTION ##
#####################

def calculate_load(ancestral_file, vcf_file, target_scaffold):

  #####################################
  ## Ancestral rates file processing ##
  #####################################
  
  # Dictonary for gerp scores
  gerp_dict = {}
  # Dictionary for ancestral alleles
  ancestral_dict = {}
  
  print("\n>>> Processing ancestral rates file, with target scaffold being:" ,target_scaffold, "\n")
  
  with gzip.open(ancestral_file, "rt") as f1:
    for line in f1:
      column = line.strip().split("\t")
      scaffold = column[0]
      position = column[1]
      ancestral_allele = column[2]
      gerp_score = column[3]
      if scaffold == target_scaffold:
        if ancestral_allele != "N" and float(gerp_score) > 0:
          # Store position and ancestral allele in dictionary
          ancestral_dict[position] = ancestral_allele
          # Store position and gerp score in dictionary
          gerp_dict[position] = gerp_score
  
  print(">>> Processing finished. Number of considered positions from ancestral rates file:", len(gerp_dict.keys()))

  # convert gerp_dict to list for later
  scores_list = [gerp_dict]
  # create a set variable and store unique gerp scores in there, for later
  scores_set = set()
  for gerp_dict in scores_list:
    for val in gerp_dict.values():
      scores_set.add(val)

  print("\n>>> Continuing with merged vcf file.\n")

  #########################
  ## VCF file processing ##
  #########################
  
  # Create output file
  outputfile = open(target_scaffold + ".derived.sites.txt", "w")

  # Mutational load dictionary
  # Each individual will have a subdictionary (later)
  load_dict = {}
  
  with gzip.open(vcf_file, "rt") as infile2:
    for line in infile2:
      if line.startswith("##"):
        continue
      elif line.startswith("#CHROM"):
        column = line.strip().split("\t")
        # Store sample id's in a list
        samples = list(column[9:]) 
        # Iterate over samples and initiate subdictionaries
        for s in range(len(samples)):
          sample = samples[s] 
          load_dict[sample] = {}
          # give each subdictionary the same number of values as there are gerp scores, which in turn will be keys for a two-indexed list
          for i in range(len(scores_set)):
            # convert set with unique gerp scores into list
            unique_scores_list = list(scores_set)
            # extract current gerp score
            gerp_score = unique_scores_list[i]
            # create two-indexed list for each gerp score
            load_dict[sample][gerp_score] = [0, 0]
      else:
        column = line.strip().split("\t")
        scaffold = column[0]
        position = column[1]
        ref_allele = column[3]
        alt_allele = column[4]
        genotypes = column[9:]
        # If site also contains 'PL' info (e.g. 1/1:270,33,0)
        genotypes = [i.split(":")[0] for i in genotypes]
        if len(alt_allele) == 1:
          if scaffold == target_scaffold:
            # If position exists in ancestral rates file
            if position in gerp_dict:
              # Remove decimals from gerp score?
              gerp_score = gerp_dict[position]
              # Iterate over samples
              for s in range(len(samples)):
                sample = samples[s]
                # extract sample genotype
                genotype = genotypes[s]
                if genotype == '0/0':
                  # store genotype for later
                  genotype = ref_allele + ref_allele
                  # add 2 to the total number of alleles?
                  load_dict[sample][gerp_score][0] += 2
                elif genotype == '0/1':
                  # store genotype for later
                  genotype = ref_allele + alt_allele
                  # add 2 to the total number of alleles?
                  load_dict[sample][gerp_score][0] += 2
                elif genotype == '1/1':
                  # store genotype for later
                  genotype = alt_allele + alt_allele
                  # add 2 to the total number of alleles?
                  load_dict[sample][gerp_score][0] += 2
                else:
                  genotype = "XX"
                # if first allele in genotype is not ancestral
                if genotype[0] != ancestral_dict[position] and genotype != "XX":
                  # add 1 to number of derived alleles
                  load_dict[sample][gerp_score][1] += 1
                # if second allele in genotype is not ancestral
                if genotype[1] != ancestral_dict[position] and genotypes != "XX":
                  # add 1 to number of derived alleles
                  load_dict[sample][gerp_score][1] += 1

# Print to outputfile
  header = "SAMPLE" + "\t" + "SCORE" + "\t" + "TOTAL_ALLELES" + "\t" + "DERIVED_ALLELES" + "\n"
  outputfile.write(header)
  for sample in load_dict.keys():
    for key,value in load_dict[sample].items():
      first = str(value[0])
      second = str(value[1])
      line = sample + "\t" + key + "\t" + first + "\t" + second + "\n"
      outputfile.write(line)
  outputfile.close()
  
  print(">>> Processing of vcf file finished.\n")
  print(">>> Gerp stats have been saved to outputfile.\n") 


##################################################################################################################

if __name__ == "__main__":
  gerp_filename = sys.argv[1]
  vcf_filename = sys.argv[2]
  chromname = sys.argv[3]
  calculate_load(gerp_filename,vcf_filename,chromname)

##################################################################################################################