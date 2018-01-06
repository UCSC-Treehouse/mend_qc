# Treehouse RNA-Seq QC
QC of aligned reads for the Treehouse RNA-Seq pipeline

## Overview
[samblaster](https://github.com/GregoryFaust/samblaster) is used to mark duplicates and [sambamba](http://lomereiter.github.io/sambamba/) is used to sort. Then [RSeqQC](http://rseqc.sourceforge.net/) calculates the reads distribution over exons skipping reads marked qc_failed, PCR duplicate, Unmapped, Non-primary (or secondary). Finally we apply a minimum threshold of 10 million to the estimated count of non-duplicate, uniquely mapped exonic reads.

## Output
* readDist.txt: The output of RSeqQC read_distribution.py (~1kb)
* bam_umend_qc.tsv: uniqMappedNonDupeReadCount, estExonicUniqMappedNonDupeReadCount and pass/fail
* bam_umend_qc.json: Same as bam_umend_qc.tsv but in json format

## Running 
via Docker:

```
docker run --rm \
  -v <path to bam file>:/inputs/sample.bam \
  -v <path to output>:/outputs \
  ucsctreehouse/bam-umend-qc \
    /inputs/sample.bam \
    /outputs
```

Directly:

  run.sh <path to bam> <path to output folder> 

NOTE: See Dockerfile for installation of required libraries

## Example expected stdout
