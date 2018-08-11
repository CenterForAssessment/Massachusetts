################################################################
###                                                          ###
###      Prepare and format the 2018 MCAS 2.0 Data           ###
###                                                          ###
################################################################


### Load libraries

require(data.table)
require(foreign)
require(SGP)


### Load data

ELA_Data <- read.spss("Data/Base_Files/MCAS ELA_Long2.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
MATH_Data <- read.spss("Data/Base_Files/MCAS Math_Long2.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
Massachusetts_Data_LONG_2018 <- rbindlist(list(ELA_Data, MATH_Data), fill=TRUE)


### Tidy up data

setnames(Massachusetts_Data_LONG_2018, toupper(names(Massachusetts_Data_LONG_2018)))

Massachusetts_Data_LONG_2018[,GRADE:=as.character(as.numeric(as.character(GRADE)))]

Massachusetts_Data_LONG_2018[,ID:=as.character(ID)]

setattr(Massachusetts_Data_LONG_2018$CONTENT_AREA, "levels", c("ELA", "ALGEBRA_I", "MATHEMATICS"))
Massachusetts_Data_LONG_2018[CONTENT_AREA=="",CONTENT_AREA:=NA]
Massachusetts_Data_LONG_2018[,CONTENT_AREA:=as.character(CONTENT_AREA)]

setattr(Massachusetts_Data_LONG_2018$ACHIEVEMENT_LEVEL, "levels", c("", "Level 1", "Level 2", "Level 3", "Level 4"))
Massachusetts_Data_LONG_2018[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]
Massachusetts_Data_LONG_2018[ACHIEVEMENT_LEVEL=="",ACHIEVEMENT_LEVEL:=NA]

Massachusetts_Data_LONG_2018[,YEAR:=as.character(YEAR)]

setattr(Massachusetts_Data_LONG_2018$ASSESSMENT_PROGRAM, "levels", c("", "MCAS", "PARCC"))
Massachusetts_Data_LONG_2018[ASSESSMENT_PROGRAM=="",ASSESSMENT_PROGRAM:=NA]
Massachusetts_Data_LONG_2018[,ASSESSMENT_PROGRAM:=as.factor(as.character(ASSESSMENT_PROGRAM))]

setnames(Massachusetts_Data_LONG_2018, "MODE", "TEST_MODE")
setattr(Massachusetts_Data_LONG_2018$TEST_MODE, "levels", c("", "Online", "Paper/Pencil"))
Massachusetts_Data_LONG_2018[TEST_MODE=="", TEST_MODE:=NA]
Massachusetts_Data_LONG_2018[,TEST_MODE:=as.factor(as.character(TEST_MODE))]

setnames(Massachusetts_Data_LONG_2018, "SCALE_SCORE_ORIGINAL", "SCALE_SCORE_NON_MODE_ADJUSTED")

setnames(Massachusetts_Data_LONG_2018, "SCALE_SCORE_STANDARD_ERROR", "SCALE_SCORE_CSEM")

setnames(Massachusetts_Data_LONG_2018, "SCALE_SCORE2", "SCALE_SCORE_ACTUAL")

Massachusetts_Data_LONG_2018[,VALID_CASE:="VALID_CASE"]


### Setkey and look for duplicates

setkey(Massachusetts_Data_LONG_2018, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
table(duplicated(Massachusetts_Data_LONG_2018, by=key(Massachusetts_Data_LONG_2018)))

### Save results

save(Massachusetts_Data_LONG_2018, file="Data/Massachusetts_Data_LONG_2018.Rdata")
