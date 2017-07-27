############################################################################################
###                                                                                      ###
###      Prepare and format the 2015, 2016, and 2017 Massachusetts MCAS 2.0/PARCC Data   ###
###                                                                                      ###
############################################################################################


### Load libraries

require(data.table)
require(foreign)
require(SGP)


### Load data

ELA_Data <- read.spss("Data/Base_Files/MCAS_ELA_Long_2017.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
MATH_Data <- read.spss("Data/Base_Files/MCAS_Math_Long_2017.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
load("Data/Base_Files/Massachusetts_Data_LONG_2014.Rdata")
Massachusetts_Data_LONG <- rbindlist(list(ELA_Data, MATH_Data), fill=TRUE)


### Tidy up data

setnames(Massachusetts_Data_LONG, toupper(names(Massachusetts_Data_LONG)))

Massachusetts_Data_LONG[,GRADE:=as.character(as.numeric(as.character(GRADE)))]

Massachusetts_Data_LONG[,ID:=as.character(ID)]

setattr(Massachusetts_Data_LONG$CONTENT_AREA, "levels", c("ELA", "ALGEBRA_I", "MATHEMATICS"))
Massachusetts_Data_LONG[CONTENT_AREA=="",CONTENT_AREA:=NA]
Massachusetts_Data_LONG[,CONTENT_AREA:=as.character(CONTENT_AREA)]

setattr(Massachusetts_Data_LONG$ACHIEVEMENT_LEVEL, "levels", c("", "Advanced", "Needs Improvement", "Proficient", "Warning/Failing"))
Massachusetts_Data_LONG[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]
Massachusetts_Data_LONG[ACHIEVEMENT_LEVEL=="",ACHIEVEMENT_LEVEL:=NA]

Massachusetts_Data_LONG[,YEAR:=as.character(YEAR)]

setattr(Massachusetts_Data_LONG$ASSESSMENT_PROGRAM, "levels", c("", "MCAS", "PARCC"))
Massachusetts_Data_LONG[ASSESSMENT_PROGRAM=="",ASSESSMENT_PROGRAM:=NA]
Massachusetts_Data_LONG[,ASSESSMENT_PROGRAM:=as.factor(as.character(ASSESSMENT_PROGRAM))]

setnames(Massachusetts_Data_LONG, "MODE", "TEST_MODE")
setattr(Massachusetts_Data_LONG$TEST_MODE, "levels", c("", "Online", "Paper/Pencil"))
Massachusetts_Data_LONG[TEST_MODE=="", TEST_MODE:=NA]
Massachusetts_Data_LONG[,TEST_MODE:=as.factor(as.character(TEST_MODE))]

setnames(Massachusetts_Data_LONG, "SCALE_SCORE_ORIGINAL", "SCALE_SCORE_NON_MODE_ADJUSTED")

setnames(Massachusetts_Data_LONG, "SCALE_SCORE_STANDARD_ERROR", "SCALE_SCORE_CSEM")

setnames(Massachusetts_Data_LONG, "SCALE_SCORE2", "SCALE_SCORE_ACTUAL")

Massachusetts_Data_LONG[,VALID_CASE:="VALID_CASE"]


### rbind 2015, 2016, and 2017 data with 2014 data

Massachusetts_Data_LONG <- rbindlist(list(Massachusetts_Data_LONG_2014, Massachusetts_Data_LONG), fill=TRUE)

### Setkey and look for duplicates

setkey(Massachusetts_Data_LONG, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

### Save results

save(Massachusetts_Data_LONG, file="Data/Massachusetts_Data_LONG.Rdata")


###  Create knots and boundaries

Massachusetts_Data_LONG[YEAR %in% c("2015", "2016"), CONTENT_AREA := paste0(CONTENT_AREA, ".2015")]
Massachusetts_Data_LONG[YEAR=="2017", CONTENT_AREA := paste0(CONTENT_AREA, ".2017")]
MA_2017_Knots_Boundaries <- createKnotsBoundaries(Massachusetts_Data_LONG)
save(MA_2017_Knots_Boundaries, file="MA_2017_Knots_Boundaries.Rdata")
