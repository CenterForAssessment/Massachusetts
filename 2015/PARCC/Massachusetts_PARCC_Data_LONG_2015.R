############################################################
###
### Script for prepare 2015 LONG file: PARCC
###
############################################################

### Load packages

require(foreign)
require(data.table)
require(SGP)


### Load data

Massachusetts_PARCC_Data_LONG_2015_ELA_PARCC <- as.data.table(read.spss("Data/Base_Files/PARCC2015_ELA.sav", to.data.frame=TRUE, trim.factor.names = TRUE))
Massachusetts_PARCC_Data_LONG_2015_MATH_PARCC <- as.data.table(read.spss("Data/Base_Files/PARCC2015_Math.sav", to.data.frame=TRUE, trim.factor.names = TRUE))


### Initial tidying up

Massachusetts_PARCC_Data_LONG_2015_ELA_PARCC[,testcode2:="ELA"]
setcolorder(Massachusetts_PARCC_Data_LONG_2015_ELA_PARCC, c(1,10,2:9))


### Stack Data

Massachusetts_PARCC_Data_LONG_2015 <- rbindlist(list(Massachusetts_PARCC_Data_LONG_2015_ELA_PARCC, Massachusetts_PARCC_Data_LONG_2015_MATH_PARCC))


### Change names

setnames(Massachusetts_PARCC_Data_LONG_2015, c("ID", "CONTENT_AREA", "GRADE", "RAW_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM",
	"ACHIEVEMENT_LEVEL", "SCALE_SCORE", "STANDARD_ERROR", "VALID_CASE"))


### Tidy Up Data

Massachusetts_PARCC_Data_LONG_2015[,RAW_SCORE:=NULL]

levels(Massachusetts_PARCC_Data_LONG_2015$ID) <- sapply(levels(Massachusetts_PARCC_Data_LONG_2015$ID), capwords)
Massachusetts_PARCC_Data_LONG_2015[,ID := as.character(ID)]

levels(Massachusetts_PARCC_Data_LONG_2015$CONTENT_AREA) <- sapply(levels(Massachusetts_PARCC_Data_LONG_2015$CONTENT_AREA), capwords)
Massachusetts_PARCC_Data_LONG_2015[,CONTENT_AREA:=as.character(CONTENT_AREA)]
Massachusetts_PARCC_Data_LONG_2015[CONTENT_AREA %in% c("Mat03", "Mat04", "Mat05", "Mat06", "Mat07", "Mat08"), CONTENT_AREA:="MATHEMATICS"]
Massachusetts_PARCC_Data_LONG_2015[CONTENT_AREA %in% c("Alg01-G8"), CONTENT_AREA:="ALGEBRA_I"]

Massachusetts_PARCC_Data_LONG_2015[,GRADE:= as.character(as.numeric(as.character(GRADE)))]

Massachusetts_PARCC_Data_LONG_2015[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]
Massachusetts_PARCC_Data_LONG_2015[!is.na(ACHIEVEMENT_LEVEL), ACHIEVEMENT_LEVEL := paste("Level", ACHIEVEMENT_LEVEL)]

Massachusetts_PARCC_Data_LONG_2015[,YEAR:="2015"]

Massachusetts_PARCC_Data_LONG_2015[,VALID_CASE:=as.character(VALID_CASE)]
Massachusetts_PARCC_Data_LONG_2015[is.na(VALID_CASE), VALID_CASE:="INVALID_CASE"]
Massachusetts_PARCC_Data_LONG_2015[VALID_CASE==1, VALID_CASE:="VALID_CASE"]

Massachusetts_PARCC_Data_LONG_2015[,ASSESSMENT_PROGRAM:="PARCC"]


### Remove records with no scale score

Massachusetts_PARCC_Data_LONG_2015 <- Massachusetts_PARCC_Data_LONG_2015[!is.na(SCALE_SCORE)]


### Save results

save(Massachusetts_PARCC_Data_LONG_2015, file="Data/Massachusetts_PARCC_Data_LONG_2015.Rdata")
