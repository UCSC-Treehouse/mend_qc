#!/bin/bash
echo "Sorting by name..."
sambamba sort -t 4 --sort-by-name --out /tmp/$1.sortedByName.bam $1

echo "Marking duplicates..."
sambamba view -h /tmp/$1.sortedByName.bam | samblaster \
  | sambamba view --sam-input --format bam /dev/stdin > /tmp/$1.sortedByName.md.bam

echo "Sorting by coordinate..."
sambamba sort --show-progress -t 4 --out=/tmp/$1.sortedByCoord.md.bam /tmp/$1.sortedByName.md.bam

echo "Counting reads..."
read_distribution.py -i /tmp/$1.sortedByCoord.md.bam -r /ref/hg38_GENCODE_v23_basic.bed  > $2/readDist.txt 
Rscript --vanilla parseReadDist.R $2/readDist.txt
