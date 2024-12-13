# MEND QC
Calculates the number of Mapped Exonic Non-Duplicate (MEND) reads in a bam file containing RNA-Seq data.

## Overview
[samblaster](https://github.com/GregoryFaust/samblaster) is used to mark duplicates and [sambamba](http://lomereiter.github.io/sambamba/) is used to sort. Then [RSeqQC](http://rseqc.sourceforge.net/) calculates the reads distribution over exons skipping reads marked qc_failed, PCR duplicate, Unmapped, Non-primary (or secondary). The [MEND qc](https://github.com/UCSC-Treehouse/mend_qc)script parseReadDist.R estimates the number of MEND reads by counting tags in CDS exons, 5' UTR exons and 3' UTR exons and multiplying by reads per tag. 

## Output
* readDist.txt: The output of RSeqQC read_distribution.py (~1kb)
* bam_mend_qc.tsv: MND, MEND and treehouse_compendium_qc (PASS/FAIL)
* bam_mend_qc.json: Same as bam_mend_qc.tsv but in json format
* sortedByCoord.md.bam: BAM with duplicates marked sorted by coordinate
* sortedByCoord.md.bam.bai: Index for sortedByCoord.md.bam

## Running 
via Docker:

```
docker run --rm \
  -v <path to bam file>:/inputs/sample.bam \
  -v <path to output>:/outputs \
  -v <path to tmp space>:/tmp \
  ucsctreehouse/bam-mend-qc \
    /inputs/sample.bam \
    /outputs
```

Optionally, specify a bed file as the third argument (after "/outputs"). The bed file needs to be formatted as specified by RSeQC. If not specified, is uses a bed file containing exon definitions specified by GENCODE_v23_basic in hg38 coordinates.

Note: Intermediate bam files are created under /tmp within the docker container.

Directly:

```
run.sh <path to bam> <path to output folder> <optionally: path to bed file>
```

NOTE: See Dockerfile for installation of required libraries

## Example expected stdout
```
Sorting by name...
Marking duplicates...
samblaster: Version 0.1.24
samblaster: Inputting from stdin
samblaster: Outputting to stdout
samblaster: Loaded 195 header sequence entries.
samblaster: Marked 1 of 999 (0.10%) read ids as duplicates using 1340k memory in 0.005S CPU seconds and 0S wall tim
e.
Sorting by coordinate...
Writing sorted chunks to temporary directory...
[==============================================================================]
Counting reads...
processing /ref/hg38_GENCODE_v23_basic.bed ... Done
processing /tmp/TEST.bam.sortedByCoord.md.bam ... Finished

[1] "analyzing /data/readDist.txt"
Read 3 items
```
