#!/usr/bin/python3

# Date: 2021-01-27, Johanna von Seth

# Get mapped read ratio.


###############
## VARIABLES ##
###############

sample = "K42_01_01"
outfile = "/proj/sllstore2017093/b2017093/b2017093_nobackup/jvs/dog_data/results/species_identification/stats/" + sample + "_mapped_ratio.txt"
filelist = "test_flagstat_filelist.txt"
path = "/proj/sllstore2017093/b2017093/b2017093_nobackup/jvs/dog_data/results/species_identification/stats/"
reads_dict = {}
target_mito="NC002008_4_CanFam6_mitochondrion"
target_reads=0

###########
## SHELL ##
###########

# open output file
with open(outfile, 'w') as out:
    # open file with list of flagstat files
    with open(filelist, 'r') as infile:
        for line in infile:
            line = line.strip()
            # store filename in variable
            filename = line
            if sample in filename:
                # save path and filename in variable
                flagstat = path + filename
                # open flagstat file
                with open(flagstat, 'r') as statfile: 
                    for line in statfile:
                        if "mapped (" in line:
                            stats=line.strip()
                            stats=line.split()
                            mapped_reads = stats[0]
                            #print(filename, mapped_reads)
                            if target_mito in filename:
                                # store reads in separate variable
                                target_reads = mapped_reads
                                # also add it to the dictionary
                                reads_dict[filename] = mapped_reads
                            else:
                                if filename in reads_dict:
                                    reads_dict[filename] += mapped_reads
                                else:
                                    reads_dict[filename] = mapped_reads
    
    # print target info
    print("\nTarget species mitogenome:", target_mito, "Mapped reads:", target_reads, "\n")
    
    # print dictionary
    for other_mitogenome, reads in reads_dict.items():
        mapped_ratio = (int(reads) / int(target_reads)) * 100
        mapped_ratio = round(mapped_ratio, 3)
        out.write("{} {}\n".format(other_mitogenome, mapped_ratio))
