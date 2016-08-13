#####################################################################################
###                                                                               ###
###      Prepare and format the 2015 and 2016 Massachusetts MCAS/PARCC Data       ###
###                                                                               ###
#####################################################################################


### Load libraries

require(data.table)
require(foreign)
require(SGP)

### Load data

ELA_15 <- read.spss("Data/Base_Files/Combined ELA 2015.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
ELA_16 <- read.spss("Data/Base_Files/Combined ELA 2016.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
MATH_15<- read.spss("Data/Base_Files/Combined Math 2015.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
MATH_16<- read.spss("Data/Base_Files/Combined Math 2016.sav", to.data.frame=TRUE, trim.factor.names=TRUE)
levels(MATH_15$content_area) <- c("ALGEBRA_I", "MATHEMATICS")
levels(MATH_16$content_area) <- c("ALGEBRA_I", "MATHEMATICS")

ELA_15[sapply(ELA_15, is.factor)] <- lapply(ELA_15[sapply(ELA_15, is.factor)], as.character)
ELA_16[sapply(ELA_16, is.factor)] <- lapply(ELA_16[sapply(ELA_16, is.factor)], as.character)
MATH_15[sapply(MATH_15, is.factor)] <- lapply(MATH_15[sapply(MATH_15, is.factor)], as.character)
MATH_16[sapply(MATH_16, is.factor)] <- lapply(MATH_16[sapply(MATH_16, is.factor)], as.character)

trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)

ELA_15[sapply(ELA_15, is.character)] <- lapply(ELA_15[sapply(ELA_15, is.character)], trimWhiteSpace)
ELA_16[sapply(ELA_16, is.character)] <- lapply(ELA_16[sapply(ELA_16, is.character)], trimWhiteSpace)
MATH_15[sapply(MATH_15, is.character)] <- lapply(MATH_15[sapply(MATH_15, is.character)], trimWhiteSpace)
MATH_16[sapply(MATH_16, is.character)] <- lapply(MATH_16[sapply(MATH_16, is.character)], trimWhiteSpace)

setnames(ELA_15, toupper(names(ELA_15)))
setnames(MATH_15, toupper(names(MATH_15)))
setnames(ELA_16, toupper(names(ELA_16)))
setnames(MATH_16, toupper(names(MATH_16)))

Massachusetts_Data_LONG_2015 <- rbindlist(list(ELA_15, MATH_15), fill=TRUE)
Massachusetts_Data_LONG_2016 <- rbindlist(list(ELA_16, MATH_16), fill=TRUE)

Massachusetts_Data_LONG_2015[, GRADE := as.character(as.numeric(GRADE))]
Massachusetts_Data_LONG_2016[, GRADE := as.character(as.numeric(GRADE))]

Massachusetts_Data_LONG_2015[which(ACHIEVEMENT_LEVEL=="Warning_Failing"), ACHIEVEMENT_LEVEL := "Warning/Failing"]
Massachusetts_Data_LONG_2016[which(ACHIEVEMENT_LEVEL=="Warning_Failing"), ACHIEVEMENT_LEVEL := "Warning/Failing"]


Massachusetts_Data_LONG_2015[, VALID_CASE := "VALID_CASE"]
Massachusetts_Data_LONG_2016[, VALID_CASE := "VALID_CASE"]

Massachusetts_Data_LONG_2015[which(is.na(SCALE_SCORE)), VALID_CASE := "INVALID_CASE"]
Massachusetts_Data_LONG_2016[which(is.na(SCALE_SCORE)), VALID_CASE := "INVALID_CASE"]

###  Invalidate duplicates - take highest score if same GRADE
setkey(Massachusetts_Data_LONG_2016, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID, SCALE_SCORE)
setkey(Massachusetts_Data_LONG_2016, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
# sum(duplicated(Massachusetts_Data_LONG_2016[VALID_CASE != "INVALID_CASE"])) # 59 duplicates with valid IDs - take the highest score
# dups <- data.table(Massachusetts_Data_LONG_2016[unique(c(which(duplicated(Massachusetts_Data_LONG_2016))-1, which(duplicated(Massachusetts_Data_LONG_2016)))), ], key=key(Massachusetts_Data_LONG_2016))
Massachusetts_Data_LONG_2016[which(duplicated(Massachusetts_Data_LONG_2016))-1, VALID_CASE := "INVALID_CASE"]

###  Invalidate duplicates - take highest GRADE if different GRADE
setkey(Massachusetts_Data_LONG_2016, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
setkey(Massachusetts_Data_LONG_2016, VALID_CASE, CONTENT_AREA, YEAR, ID)
sum(duplicated(Massachusetts_Data_LONG_2016[VALID_CASE != "INVALID_CASE"])) # 3 duplicates (2 students) with valid IDs - take the highest GRADE
dups <- data.table(Massachusetts_Data_LONG_2016[unique(c(which(duplicated(Massachusetts_Data_LONG_2016))-1, which(duplicated(Massachusetts_Data_LONG_2016)))), ], key=key(Massachusetts_Data_LONG_2016))
Massachusetts_Data_LONG_2016[intersect(which(ID=='1017074914'), which(duplicated(Massachusetts_Data_LONG_2016))-1), VALID_CASE := "INVALID_CASE"]

setkey(Massachusetts_Data_LONG_2016, VALID_CASE, CONTENT_AREA, YEAR, ID, GRADE)
setkey(Massachusetts_Data_LONG_2016, VALID_CASE, CONTENT_AREA, YEAR, ID)
Massachusetts_Data_LONG_2016[intersect(which(ID=='1034018324'), which(duplicated(Massachusetts_Data_LONG_2016))), VALID_CASE := "INVALID_CASE"]

save(Massachusetts_Data_LONG_2015, file="/Users/avi/Dropbox (SGP)/SGP/Massachusetts/Data/Massachusetts_Data_LONG_2015.Rdata")
save(Massachusetts_Data_LONG_2016, file="/Users/avi/Dropbox (SGP)/SGP/Massachusetts/Data/Massachusetts_Data_LONG_2016.Rdata")

###  Create knots and boundaries

Massachusetts_Data_LONG <- rbindlist(list(Massachusetts_Data_LONG_2015, Massachusetts_Data_LONG_2016[,names(Massachusetts_Data_LONG_2015), with=F]), fill=TRUE)
Massachusetts_Data_LONG[, CONTENT_AREA := paste0(CONTENT_AREA, ".2015")]

MA_2016_Knots_Boundaries <- createKnotsBoundaries(Massachusetts_Data_LONG)
save(MA_2016_Knots_Boundaries, file="/Users/avi/Dropbox (SGP)/Github_Repos/Packages/SGPstateData/Knots_Boundaries/MA_2016_Knots_Boundaries.Rdata")
