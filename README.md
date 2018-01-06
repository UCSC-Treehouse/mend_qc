# BAM UMEND QC
Calculates the number of Uniquely Mapped Exonic Non-Duplicate (UMEND) reads in a bam file.

Treehouse applies a threshold of 10 million UMEND reads to triage incoming sample files.

## Overview
[samblaster](https://github.com/GregoryFaust/samblaster) is used to mark duplicates and [sambamba](http://lomereiter.github.io/sambamba/) is used to sort. Then [RSeqQC](http://rseqc.sourceforge.net/) calculates the reads distribution over exons skipping reads marked qc_failed, PCR duplicate, Unmapped, Non-primary (or secondary).

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

```
run.sh <path to bam> <path to output folder>
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
