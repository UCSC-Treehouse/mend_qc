#!/usr/bin/Rscript

f <- "/Users/hbeale/Documents/Dropbox/ucsc/projects/revamp_parse_ReadDist/C021_0006_RNA.md.readDist.txt"

# options(stringsAsFactors=FALSE)

f <- commandArgs(TRUE)[1]
print(paste0("analyzing ", f))

library(tidyverse)

exonic_groups <- c("CDS_Exons", "5'UTR_Exons", "3'UTR_Exons")

treehouse_compendium_threshold <- 10E6

if ( ! file.info(f)$size==0){
	
  # import tags per read (top table)
  lines_for_tags_per_read <- readr::read_lines(f, n_max = 3)  
  tags_per_read <- readr::read_fwf(lines_for_tags_per_read,
                                   readr::fwf_empty(gsub("\\b \\b", "\x1F", lines_for_tags_per_read),
                                                    col_names = c("Measurement", "Count")))
  # gsub("\\b \\b", "\x1F",...) transforms the single spaces to the ascii unit separator character
  # str_replace doesn't work here
  
  read_count_doubled <- tags_per_read %>%
    filter(Measurement == "Total Reads") %>%
    pull(Count)
  
  tag_count <- tags_per_read %>%
    filter(Measurement == "Total Tags") %>%
    pull(Count)
  
  reads_per_tag <- round(read_count_doubled / tag_count, 2)

  # import tags per read (bottom table)  
    tags_by_group <- readr::read_lines(f, skip = 4, n_max = 11) %>%
    read_table()
  
  exonic_tag_count <- tags_by_group %>%
    filter(Group %in% exonic_groups) %>%
    pull(Tag_count) %>%
    sum
  
  mend_count_doubled <- exonic_tag_count * reads_per_tag
  
  mend_count <- mend_count_doubled / 2
  
  mnd_count <-  read_count_doubled / 2

  result <- tibble(input = basename (f), 
                   MND = mnd_count, 
                   MEND = mend_count,
                   treehouse_compendium_qc = ifelse(MEND > treehouse_compendium_threshold, "PASS", "FAIL"))
 
  write_tsv(result, file.path(dirname(f), "/bam_mend_qc.tsv"))

  library(rjson)
  toJSON(result) %>% write(file.path(dirname(f), "/bam_umend_qc.json"))
  
}



