#!/usr/bin/Rscript

# Feb10 - requires an additional parameter than adds option to output to current directory

options(stringsAsFactors=FALSE)

f <- commandArgs(TRUE)[1]
outputHere <- as.logical(commandArgs(TRUE)[2])

print(paste0("analyzing ", f))


if ( ! file.info(f)$size==0){
	
	distVals=read.table(f, skip=4, sep="", nrows=10, header=T)
	exonicGroups=c("CDS_Exons", "5'UTR_Exons", "3'UTR_Exons")
	exonicTagCount= sum(subset(distVals, Group %in% exonicGroups)$Tag_count)
	
	totalValsRaw=scan(f, what="list", sep="\n", comment.char="", nlines=3)
	readCountTimes2=as.numeric(gsub("[^0-9]*", "", totalValsRaw[grep("Total Reads", totalValsRaw)]))
	tagCount=as.numeric(gsub("[^0-9]*", "", totalValsRaw[grep("Total Tags", totalValsRaw)]))
	readsPerTag= round(readCountTimes2 /tagCount, 2)
	
	estExonicReadsTimes2= exonicTagCount*readsPerTag
	
	# values are divided by two because read_distribution.py counts the ends of a read separately
	readCount= readCountTimes2/2
	estExonicReads= estExonicReadsTimes2/2
	
	result=data.frame(input=f, uniqMappedNonDupeReadCount=readCount, estExonicUniqMappedNonDupeReadCount = estExonicReads)
	
	if (outputHere) f=basename(f)
	if(estExonicReads>10E6){
		result$qc="PASS"
		write.table(result, file=paste0(f, "_PASS_qc.txt"), quote=FALSE, sep="\t", row.names=FALSE)
	} else {
		result$qc="FAIL"
		write.table(result, file=paste0(f, "_FAIL_qc.txt"), quote=FALSE, sep="\t", row.names=FALSE)
	}

}

