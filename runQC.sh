#!/bin/bash
sambamba sort --tmpdir /data -t 4 --sort-by-name --out  /data/rnaAligned.sortedByName.bam /data/rnaAligned.sortedByCoord.out.bam
sambamba view -h /data/rnaAligned.sortedByName.bam  | samblaster | sambamba view --sam-input --format bam /dev/stdin > /data/rnaAligned.sortedByName.md.bam
sambamba sort --tmpdir  /data --show-progress -t 4 --out=/data/rnaAligned.sortedByCoord.md.bam /data/rnaAligned.sortedByName.md.bam
geneBody_coverage.py -i /data/rnaAligned.sortedByCoord.md.bam -r /ref/hg38_GENCODE_v23.bed --out-prefix=/data/rnaAligned.out.md.sorted
read_distribution.py -i /data/rnaAligned.sortedByCoord.md.bam -r  /ref/hg38_GENCODE_v23.bed  > /data/readDist.txt 
Rscript --vanilla parseReadDist.R /data/readDist.txt
