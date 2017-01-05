build:
	docker build -t bam_qc .

test:
	docker run -it --rm \
		-v `pwd`/data:/data \
		-v `pwd`/TEST.sorted.bam:/data/rnaAligned.sortedByCoord.out.bam \
		bam_qc runQC.sh

verify:
	echo "Verifying output of test file"
	md5sum -c TEST.md5
