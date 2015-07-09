############################################################
###
### Script for prepare 2015 MATHEMATICS LONG file
###
############################################################

### Load packages

require(foreign)
require(data.table)
require(SGP)


### Load data

Massachusetts_Data_LONG_2015_MATHEMATICS <- as.data.table(read.spss("Data/Base_Files/MCAS2015_MATHEMATICS_8.sav", to.data.frame=TRUE, trim.factor.names = TRUE))


### Change names

setnames(Massachusetts_Data_LONG_2015_MATHEMATICS, c("ID", "GRADE", "RAW_SCORE", "TEST_STATUS", "SCALE_SCORE_ACTUAL",
	"ACHIEVEMENT_LEVEL", "SCALE_SCORE", "STANDARD_ERROR", "VALID_CASE"))


### Tidy Up Data

levels(Massachusetts_Data_LONG_2015_MATHEMATICS$TEST_STATUS) <- c("", "NTA", "NTL", "NTM", "NTO", "T", "TR")
Massachusetts_Data_LONG_2015_MATHEMATICS <- subset(Massachusetts_Data_LONG_2015_MATHEMATICS, TEST_STATUS=="T")
Massachusetts_Data_LONG_2015_MATHEMATICS[,TEST_STATUS:=NULL]

Massachusetts_Data_LONG_2015_MATHEMATICS[,RAW_SCORE:=NULL]

levels(Massachusetts_Data_LONG_2015_MATHEMATICS$ID) <- sapply(levels(Massachusetts_Data_LONG_2015_MATHEMATICS$ID), capwords)
Massachusetts_Data_LONG_2015_MATHEMATICS[,ID := as.character(ID)]

levels(Massachusetts_Data_LONG_2015_MATHEMATICS$ACHIEVEMENT_LEVEL) <- c(NA, "Advanced", "Needs Improvement", "Proficient", "Warning/Failing")
Massachusetts_Data_LONG_2015_MATHEMATICS[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]

Massachusetts_Data_LONG_2015_MATHEMATICS[,GRADE:= as.character(as.numeric(as.character(GRADE)))]

Massachusetts_Data_LONG_2015_MATHEMATICS[,CONTENT_AREA:="MATHEMATICS"]
Massachusetts_Data_LONG_2015_MATHEMATICS[,YEAR:="2015"]

Massachusetts_Data_LONG_2015_MATHEMATICS[,VALID_CASE:=as.character(VALID_CASE)]
Massachusetts_Data_LONG_2015_MATHEMATICS[is.na(VALID_CASE), VALID_CASE:="INVALID_CASE"]
Massachusetts_Data_LONG_2015_MATHEMATICS[VALID_CASE==1, VALID_CASE:="VALID_CASE"]


### Save results

#save(Massachusetts_Data_LONG_2015_MATHEMATICS, file="Data/Massachusetts_Data_LONG_2015_MATHEMATICS.Rdata")
