#!/bin/bash
UUID=$(cat /proc/sys/kernel/random/uuid)

if [ -z "$3" ]; then
bed_file=/ref/hg38_GENCODE_v23_basic.bed
else
bed_file=$3
fi

echo "Sorting by name..."
sambamba sort -t 4 --sort-by-name --out /tmp/$UUID.sortedByName.bam $1

echo "Marking duplicates..."
sambamba view -h /tmp/$UUID.sortedByName.bam | samblaster \
  | sambamba view --sam-input --format bam /dev/stdin > /tmp/$UUID.sortedByName.md.bam
rm /tmp/$UUID.sortedByName.bam

echo "Sorting by coordinate..."
sambamba sort -t 4 --out=/tmp/$UUID.sortedByCoord.md.bam /tmp/$UUID.sortedByName.md.bam
rm /tmp/$UUID.sortedByName.md.bam

echo "Counting reads..."
read_distribution.py -i /tmp/$UUID.sortedByCoord.md.bam -r $bed_file  > $2/readDist.txt 
Rscript --vanilla parseReadDist.R $2/readDist.txt
mv /tmp/$UUID.sortedByCoord.md.bam $2/sortedByCoord.md.bam
mv /tmp/$UUID.sortedByCoord.md.bam.bai $2/sortedByCoord.md.bam.bai
