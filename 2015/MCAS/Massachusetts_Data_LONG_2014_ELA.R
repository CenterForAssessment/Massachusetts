############################################################
###
### Script for prepare 2014 ELA LONG file
###
############################################################

### Load packages

require(foreign)
require(data.table)
require(SGP)


### Load data

Massachusetts_LONG_2014_ELA <- as.data.table(read.spss("MCAS2014_ELA.sav", to.data.frame=TRUE))


### Change names

names(Massachusetts_LONG_2014_ELA) <- c("DISTRICT_NUMBER", "SCHOOL_NUMBER", "ID", "GRADE", "TEST_STATUS", "RAW_SCORE", "SCALE_SCORE_ACTUAL", 
	"SCALE_SCORE_LOW_SE", "SCALE_SCORE_HIGH_SE", "SCALE_SCORE", "STANDARD_ERROR")



### Tidy Up Data

levels(Massachusetts_LONG_2014_ELA$TEST_STATUS) <- sapply(levels(Massachusetts_LONG_2014_ELA$TEST_STATUS), capwords)
Massachusetts_LONG_2014_ELA <- subset(Massachusetts_LONG_2014_ELA, TEST_STATUS=="T")
Massachusetts_LONG_2014_ELA[,TEST_STATUS:=NULL]

Massachusetts_LONG_2014_ELA[,RAW_SCORE:=NULL]
Massachusetts_LONG_2014_ELA[,SCALE_SCORE_LOW_SE:=NULL]
Massachusetts_LONG_2014_ELA[,SCALE_SCORE_HIGH_SE:=NULL]

Massachusetts_LONG_2014_ELA[,SCHOOL_NUMBER := as.character(SCHOOL_NUMBER)]
Massachusetts_LONG_2014_ELA[,DISTRICT_NUMBER:= as.character(DISTRICT_NUMBER)]
Massachusetts_LONG_2014_ELA[,ID := as.character(ID)]
Massachusetts_LONG_2014_ELA[,GRADE:= as.character(as.numeric(GRADE))]

Massachusetts_LONG_2014_ELA[,CONTENT_AREA:="ELA"]
Massachusetts_LONG_2014_ELA[,YEAR:="2014"]


### Save results

save(Massachusetts_LONG_2014_ELA, file="Massachusetts_Data_LONG_2014_ELA.Rdata")
