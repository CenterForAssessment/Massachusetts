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

Massachusetts_Data_LONG_2015_ELA <- as.data.table(read.spss("Data/Base_Files/MCAS2015_ELA_8.sav", to.data.frame=TRUE, trim.factor.names = TRUE))


### Change names

setnames(Massachusetts_Data_LONG_2015_ELA, c("ID", "GRADE", "RAW_SCORE", "TEST_STATUS", "SCALE_SCORE_ACTUAL",
	"ACHIEVEMENT_LEVEL", "SCALE_SCORE", "STANDARD_ERROR", "VALID_CASE"))


### Tidy Up Data

levels(Massachusetts_Data_LONG_2015_ELA$TEST_STATUS) <- c("", "NTA", "NTL", "NTM", "NTO", "T", "TR")
Massachusetts_Data_LONG_2015_ELA <- subset(Massachusetts_Data_LONG_2015_ELA, TEST_STATUS=="T")
Massachusetts_Data_LONG_2015_ELA[,TEST_STATUS:=NULL]

Massachusetts_Data_LONG_2015_ELA[,RAW_SCORE:=NULL]

levels(Massachusetts_Data_LONG_2015_ELA$ID) <- sapply(levels(Massachusetts_Data_LONG_2015_ELA$ID), capwords)
Massachusetts_Data_LONG_2015_ELA[,ID := as.character(ID)]

levels(Massachusetts_Data_LONG_2015_ELA$ACHIEVEMENT_LEVEL) <- c(NA, "Advanced", "Needs Improvement", "Proficient", "Warning/Failing")
Massachusetts_Data_LONG_2015_ELA[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]

Massachusetts_Data_LONG_2015_ELA[,GRADE:= as.character(as.numeric(as.character(GRADE)))]

Massachusetts_Data_LONG_2015_ELA[,CONTENT_AREA:="ELA"]
Massachusetts_Data_LONG_2015_ELA[,YEAR:="2015"]

Massachusetts_Data_LONG_2015_ELA[,VALID_CASE:=as.character(VALID_CASE)]
Massachusetts_Data_LONG_2015_ELA[is.na(VALID_CASE), VALID_CASE:="INVALID_CASE"]
Massachusetts_Data_LONG_2015_ELA[VALID_CASE==1, VALID_CASE:="VALID_CASE"]


### Remove records with no scale score

Massachusetts_Data_LONG_2015_ELA <- Massachusetts_Data_LONG_2015_ELA[!is.na(SCALE_SCORE)]


### Save results

save(Massachusetts_Data_LONG_2015_ELA, file="Data/Massachusetts_Data_LONG_2015_ELA.Rdata")
