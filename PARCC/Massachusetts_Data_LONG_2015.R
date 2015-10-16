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

Massachusetts_Data_LONG_2015_ELA_PARCC <- as.data.table(read.spss("Data/Base_Files/PARCC2015_ELA.sav", to.data.frame=TRUE, trim.factor.names = TRUE))
Massachusetts_Data_LONG_2015_MATH_PARCC <- as.data.table(read.spss("Data/Base_Files/PARCC2015_Math.sav", to.data.frame=TRUE, trim.factor.names = TRUE))


### Initial tidying up

Massachusetts_Data_LONG_2015_ELA_PARCC[,testcode2:="ELA"]
setcolorder(Massachusetts_Data_LONG_2015_ELA_PARCC, c(1,10,2:9))


### Stack Data

Massachusetts_Data_LONG_2015_PARCC <- rbindlist(list(Massachusetts_Data_LONG_2015_ELA_PARCC, Massachusetts_Data_LONG_2015_MATH_PARCC))


### Change names

setnames(Massachusetts_Data_LONG_2015_PARCC, c("ID", "CONTENT_AREA", "GRADE", "RAW_SCORE", "SCALE_SCORE_ACTUAL", "SCALE_SCORE_CSEM",
	"ACHIEVEMENT_LEVEL", "SCALE_SCORE", "STANDARD_ERROR", "VALID_CASE"))


### Tidy Up Data

Massachusetts_Data_LONG_2015_PARCC[,RAW_SCORE:=NULL]

levels(Massachusetts_Data_LONG_2015_PARCC$ID) <- sapply(levels(Massachusetts_Data_LONG_2015_PARCC$ID), capwords)
Massachusetts_Data_LONG_2015_PARCC[,ID := as.character(ID)]

levels(Massachusetts_Data_LONG_2015_PARCC$CONTENT_AREA) <- sapply(levels(Massachusetts_Data_LONG_2015_PARCC$CONTENT_AREA), capwords)
Massachusetts_Data_LONG_2015_PARCC[,CONTENT_AREA:=as.character(CONTENT_AREA)]
Massachusetts_Data_LONG_2015_PARCC[CONTENT_AREA %in% c("Mat03", "Mat04", "Mat05", "Mat06", "Mat07", "Mat08"), CONTENT_AREA:="MATHEMATICS"]
Massachusetts_Data_LONG_2015_PARCC[CONTENT_AREA %in% c("Alg01-G8"), CONTENT_AREA:="ALGEBRA_I"]

Massachusetts_Data_LONG_2015_PARCC[,GRADE:= as.character(as.numeric(as.character(GRADE)))]

Massachusetts_Data_LONG_2015_PARCC[,ACHIEVEMENT_LEVEL := as.character(ACHIEVEMENT_LEVEL)]
Massachusetts_Data_LONG_2015_PARCC[!is.na(ACHIEVEMENT_LEVEL), ACHIEVEMENT_LEVEL := paste("Level", ACHIEVEMENT_LEVEL)]

Massachusetts_Data_LONG_2015_PARCC[,YEAR:="2015"]

Massachusetts_Data_LONG_2015_PARCC[,VALID_CASE:=as.character(VALID_CASE)]
Massachusetts_Data_LONG_2015_PARCC[is.na(VALID_CASE), VALID_CASE:="INVALID_CASE"]
Massachusetts_Data_LONG_2015_PARCC[VALID_CASE==1, VALID_CASE:="VALID_CASE"]

Massachusetts_Data_LONG_2015_PARCC[,ASSESSMENT_PROGRAM:="PARCC"]


### Remove records with no scale score

Massachusetts_Data_LONG_2015_PARCC <- Massachusetts_Data_LONG_2015_PARCC[!is.na(SCALE_SCORE)]


### Save results

save(Massachusetts_Data_LONG_2015_PARCC, file="Data/Massachusetts_Data_LONG_2015_PARCC.Rdata")
