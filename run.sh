#!/bin/bash
echo "Sorting by name..."
sambamba sort -t 4 --sort-by-name --out /tmp/sortedByName.bam $1

echo "Marking duplicates..."
sambamba view -h /tmp/sortedByName.bam | samblaster \
  | sambamba view --sam-input --format bam /dev/stdin > /tmp/sortedByName.md.bam

echo "Sorting by coordinate..."
sambamba sort --show-progress -t 4 --out=/tmp/sortedByCoord.md.bam /tmp/sortedByName.md.bam

echo "Counting reads..."
read_distribution.py -i /tmp/sortedByCoord.md.bam -r /ref/hg38_GENCODE_v23_basic.bed  > $2/readDist.txt 
Rscript --vanilla parseReadDist.R $2/readDist.txt
