default: build wipe test

build:
	docker build -t bam_qc .

wipe:
	# Delete the output in /data which is owned by root so using a 
	# hack to remove when running on shared systems w/o root access
	docker run -it --rm -v `pwd`/data:/data alpine rm -rf /data/*

test:
	echo "Running on TEST.sorted.bam"
	docker run -it --rm \
		-v `pwd`/data:/data \
		-v `pwd`/TEST.sorted.bam:/data/rnaAligned.sortedByCoord.out.bam \
		bam_qc runQC.sh
	echo "Verifying output of test file"
	md5sum -c TEST.md5
