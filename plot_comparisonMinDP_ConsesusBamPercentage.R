# Tutorial from here: https://bookdown.org/skaltman/visualization-book/discrete-continuous.html
# Note! I did not load any packages based on the tutorial, but from here:
# http://www.sthda.com/english/articles/32-r-graphics-essentials/132-plot-grouped-data-box-plot-bar-plot-and-more/

# Created by: 2023-09-13, Johanna von Seth

# Script to plot the mitogenome coverage of consensus fasta files in relation to 
# the minimum depth threshold when calling a nucleotide.


# Load required packages and set the theme function theme_pubclean() [in ggpubr] 
# as the default theme

# NOTE! Not sure all these packages are actually needed...
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("ggpubr")

library(tidyverse) 
library(dplyr) 
library(ggplot2)
library(ggpubr)
theme_set(theme_pubclean())


###################################
## Grouped categorical variables ##
###################################

# - Demo dataset: 20230913_testConsensuPercComparison.txt. The categorical 
#                 variables to be used in the demo example are:
#                 - sampleID: all samples
#                 - minDP: min DP for calling consensus at site (6, 3, 1).


# 1. Load and group the data:
raw_data <- read.table("/Users/johannavonseth/Documents/programming/bioinformatics/projects/dogs/scripts/mitogenomes/r_scripts/plot_coverage/20230913_testConsensuPercComparison.txt", header = TRUE)
head(raw_data)
tail(raw_data)

dataframe <- raw_data[order(-raw_data$consPercCov),]
head(dataframe)

minDP_names <- c(
  `1` = "minDP1",
  `3` = "minDP3",
  `6` = "minDP6"
)

# 2. Plot the data and visualise immediately in R
p1 <- ggplot(data = dataframe, aes(x = consPercCov, 
                                   y = reorder(sampleID, consPercCov), 
                                   color = sampleID, fill = sampleID)) +
  geom_bar(stat = "identity") +
  # place each minDP percentage in a separate graph
  facet_grid(cols = vars(minDP),
             # rename minDP labels
             labeller = as_labeller(minDP_names)) +
  # Remove box with color legends on the right
  theme(legend.position = "none",
        panel.background = element_blank(),
        # remove the horizontal grid lines
        panel.grid.major.y = element_blank(),
        # explicitly set the vertical lines (or they will disappear too)
        panel.grid.major.x = element_line(linewidth = 0.1, color = "black"),
        # add axis lines
        axis.line = element_line(linewidth = 0.1, color = "black"),
        axis.text = element_text(size = 16)
        ) +
  # Fix axis labels
  xlab("Percentage of mitogenome covered in consensus") + ylab("Sample ID") +
  # Add bam estimates of percentage covered as black crosses
  geom_point(aes(x = dataframe$bamPerc, y = dataframe$sampleID), 
             colour = "black", 
             shape = 3, 
             size = 3)

p1

# 3. Plot the data and save to file.
pdf("/Users/johannavonseth/Documents/programming/bioinformatics/projects/dogs/data/intermediate_data/mtDNA_analysis/mitogenomes/KTH_coverage/comparison_bam_consensus/test_compMinDP.pdf",
    width = 20, height = 50)
par(mar = c(0, 0, 0, 0))
ggplot(data = dataframe, aes(x = consPercCov, 
                             y = reorder(sampleID, consPercCov), 
                             color = sampleID, fill = sampleID)) +
  geom_bar(stat = "identity") +
  # place each minDP percentage in a separate graph
  facet_grid(cols = vars(minDP),
             # rename minDP labels
             labeller = as_labeller(minDP_names)) +
  # Change size of facet_grid labels
  theme(strip.text.x = element_text(size = 16)) +
  # Fix axis labels
  xlab("Percentage of mitogenome covered in consensus") + ylab("Sample ID") +
  # Add bam estimates of percentage covered as black crosses
  geom_point(aes(x = dataframe$bamPerc, y = dataframe$sampleID), 
             colour = "black", 
             shape = 3, 
             size = 3) +
  # Remove box with color legends on the right
  theme(legend.position = "none",
        panel.background = element_blank(),
        # remove the horizontal grid lines
        panel.grid.major.y = element_blank(),
        # explicitly set the vertical lines (or they will disappear too)
        panel.grid.major.x = element_line(linewidth = 0.1, color = "black"),
        # add axis lines
        axis.line = element_line(linewidth = 0.1, color = "black"),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 20)) +
  scale_x_continuous(n.breaks = 10)
dev.off()
