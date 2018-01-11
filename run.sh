#!/bin/bash
UUID=$(cat /proc/sys/kernel/random/uuid)

echo "Sorting by name..."
sambamba sort -t 4 --sort-by-name --out /tmp/$UUID.sortedByName.bam $1

echo "Marking duplicates..."
sambamba view -h /tmp/$UUID.sortedByName.bam | samblaster \
  | sambamba view --sam-input --format bam /dev/stdin > /tmp/$UUID.sortedByName.md.bam
rm /tmp/$UUID.sortedByName.bam

echo "Sorting by coordinate..."
sambamba sort --show-progress -t 4 --out=/tmp/$UUID.sortedByCoord.md.bam /tmp/$UUID.sortedByName.md.bam
rm /tmp/$UUID.sortedByName.md.bam

echo "Counting reads..."
read_distribution.py -i /tmp/$UUID.sortedByCoord.md.bam -r /ref/hg38_GENCODE_v23_basic.bed  > $2/readDist.txt 
Rscript --vanilla parseReadDist.R $2/readDist.txt
rm /tmp/$UUID.sortedByCoord.md.bam
