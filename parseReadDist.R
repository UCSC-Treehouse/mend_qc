#!/usr/bin/Rscript

options(stringsAsFactors=FALSE)

f <- commandArgs(TRUE)[1]
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
	
	result=data.frame(input=basename(f), 
	                  MND=readCount,
                    MEND=estExonicReads)
	
	if(estExonicReads>10E6) {
		result$treehouse_compendium_qc="PASS"
	} else {
		result$treehouse_compendium_qc="FAIL"
	}
  write.table(result, file=paste0(dirname(f), "/bam_mend_qc.tsv"), quote=FALSE, sep="\t", row.names=FALSE)

  library(rjson)
  sink(paste0(dirname(f), "/bam_mend_qc.json"))
  cat(toJSON(result))
  sink()
}

