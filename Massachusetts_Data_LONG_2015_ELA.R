############################################################
###
### Script for prepare 2015 ELA LONG file
###
############################################################

### Load packages

require(foreign)
require(data.table)
require(SGP)


### Load data

Massachusetts_LONG_2015_ELA <- as.data.table(read.spss("MCAS2015_ELA_7.sav", to.data.frame=TRUE, trim.factor.names = TRUE))


### Change names

setnames(Massachusetts_LONG_2015_ELA, c("ID", "GRADE", "RAW_SCORE", "TEST_STATUS", "SCALE_SCORE_ACTUAL",
	"ACHIEVEMENT_LEVEL", "SCALE_SCORE", "STANDARD_ERROR", "VALID_CASE"))


### Tidy Up Data

levels(Massachusetts_LONG_2015_ELA$TEST_STATUS) <- toupper(sapply(levels(Massachusetts_LONG_2015_ELA$TEST_STATUS), capwords))
Massachusetts_LONG_2015_ELA <- subset(Massachusetts_LONG_2015_ELA, TEST_STATUS=="T")
Massachusetts_LONG_2015_ELA[,TEST_STATUS:=NULL]

Massachusetts_LONG_2015_ELA[,RAW_SCORE:=NULL]

levels(Massachusetts_LONG_2015_ELA$ID) <- sapply(levels(Massachusetts_LONG_2015_ELA$ID), capwords)
Massachusetts_LONG_2015_ELA[,ID := as.character(ID)]
levels(Massachusetts_LONG_2015_ELA$ACHIEVEMENT_LEVEL) <- sapply(levels(Massachusetts_LONG_2015_ELA$ACHIEVEMENT_LEVEL), capwords)
Massachusetts_LONG_2015_ELA[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]

Massachusetts_LONG_2015_ELA[,GRADE:= as.character(as.numeric(as.character(GRADE)))]

Massachusetts_LONG_2015_ELA[,CONTENT_AREA:="ELA"]
Massachusetts_LONG_2015_ELA[,YEAR:="2015"]

Massachusetts_LONG_2015_ELA[,VALID_CASE:=as.character(VALID_CASE)]
Massachusetts_LONG_2015_ELA[is.na(VALID_CASE), VALID_CASE:="INVALID_CASE"]
Massachusetts_LONG_2015_ELA[VALID_CASE==1, VALID_CASE:="VALID_CASE"]



### Save results

save(Massachusetts_LONG_2015_ELA, file="Massachusetts_Data_LONG_2015_ELA.Rdata")