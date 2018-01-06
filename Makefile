build:
	docker build -t ucsctreehouse/bam-umend-qc .

debug:
	docker run -it --rm --user `id -u`:`id -g` \
		-v `pwd`/data:/data \
		-v `pwd`:/app \
		--entrypoint /bin/bash \
		ucsctreehouse/bam-umend-qc

test:
	docker run -it --rm --user `id -u`:`id -g` \
		-v `pwd`/data:/data \
		ucsctreehouse/bam-umend-qc TEST.bam /data
	md5sum -c TEST.md5

concordance:
	docker run -it --rm --user `id -u`:`id -g` \
		-v /scratch/rcurrie:/data \
		-v /pod/pstore/groups/treehouse/archive/downstream/TH27_0702_S01/expression/sortedByCoord.md.bam:/data/rnaAligned.sortedByCoord.out.bam:ro \
		--entrypoint /bin/bash \
		ucsctreehouse/bam-umend-qc run.sambamba.sh
	diff -s /scratch/rcurrie/readDist.txt /pod/pstore/groups/treehouse/archive/downstream/TH27_0702_S01/expression/QC/bamQC/readDist.txt
