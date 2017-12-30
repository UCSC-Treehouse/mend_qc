build:
	docker build -t bam_qc .

debug:
	docker run -it --rm \
		-v `pwd`:/app \
		--user `id -u`:`id -g` \
		-v ~/scratch:/data \
		--entrypoint /bin/bash \
		bam_qc

sort:
	time sambamba sort --tmpdir /data -t 4 --sort-by-name \
		--out /data/rnaAligned.sortedByName.bam /data/pipelines/outputs/expression/SRR5163668_1merged.sorted.bam

mark:
	time sambamba view -h /data/rnaAligned.sortedByName.bam  | \
		samblaster | \
		sambamba view --sam-input --format bam /dev/stdin > /data/rnaAligned.sortedByName.md.bam

coord:
	time sambamba sort --tmpdir /data --show-progress -t 4 \
		--out=/data/rnaAligned.sortedByCoord.md.bam /data/rnaAligned.sortedByName.md.bam

coverage:
	time python geneBody_coverage.py -i /data/rnaAligned.sortedByCoord.md.bam -r \
		/ref/hg38_GENCODE_v23.bed --out-prefix=/data/rnaAligned.out.md.sorted

distribution:
	time python read_distribution.py -i /data/rnaAligned.sortedByCoord.md.bam -r \
		/ref/hg38_GENCODE_v23.bed  > /data/readDist.txt

test:
	docker run -it --rm --name bamqc \
		-v `pwd`/data:/data \
		-v `pwd`/TEST.sorted.bam:/data/rnaAligned.sortedByCoord.out.bam \
		hbeale/treehouse_bam_qc:1.0 runQC.sh
	echo "Verifying output of test file"
	md5sum -c TEST.md5
