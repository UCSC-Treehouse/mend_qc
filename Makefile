build:
	docker build -t ucsctreehouse/bam-mend-qc .

debug:
	docker run -it --rm --user `id -u`:`id -g` \
		-v `pwd`/data:/data \
		-v ~/scratch/tmp:/tmp \
		-v `pwd`:/app \
		--entrypoint /bin/bash \
		ucsctreehouse/bam-mend-qc

test:
	docker run -it --rm --user `id -u`:`id -g` \
		-v `pwd`/data:/outputs \
		-v ~/scratch/tmp:/tmp \
		ucsctreehouse/bam-mend-qc /app/TEST.bam /outputs
	md5sum -c TEST.md5

concordance:
	docker run -it --rm --user `id -u`:`id -g` \
		-v `pwd`/data:/outputs \
		-v ~/scratch/tmp:/tmp \
		-v /pod/pstore/groups/treehouse/archive/downstream/TH27_0702_S01/expression/sortedByCoord.md.bam:/sample.bam:ro \
		ucsctreehouse/bam-mend-qc /sample.bam /outputs
	diff -s data/readDist.txt /pod/pstore/groups/treehouse/archive/downstream/TH27_0702_S01/expression/QC/bamQC/readDist.txt
