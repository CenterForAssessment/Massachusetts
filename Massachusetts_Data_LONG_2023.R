################################################################
###                                                          ###
###      Create 2023 LONG data from completed Data           ###
###                                                          ###
################################################################


### Load libraries
require(data.table)
require(foreign)


### Load data
tmp.math <- as.data.table(read.spss("Data/Base_Files/Math17_22.sav", to.data.frame=TRUE, trim.factor.names=TRUE))
tmp.ela <- as.data.table(read.spss("Data/Base_Files/ELA17_22.sav", to.data.frame=TRUE, trim.factor.names=TRUE))
tmp.math[,content_area:="MATHEMATICS"]
tmp.ela[,content_area:="ELA"]

Massachusetts_Data_LONG_2017_to_2023 <- rbindlist(list(tmp.math, tmp.ela))


### Tidy up data
setnames(Massachusetts_Data_LONG_2017_to_2023, toupper(names(Massachusetts_Data_LONG_2017_to_2023)))
setnames(Massachusetts_Data_LONG_2017_to_2023, "SCALE_SCORE2", "SCALE_SCORE_ACTUAL")
setnames(Massachusetts_Data_LONG_2017_to_2023, "SCALE_SCORE_STANDARD_ERROR", "SCALE_SCORE_CSEM")

Massachusetts_Data_LONG_2017_to_2023[,GRADE:=as.character(as.numeric(GRADE))]

Massachusetts_Data_LONG_2017_to_2023[,ACHIEVEMENT_LEVEL:=as.factor(ACHIEVEMENT_LEVEL)]
levels(Massachusetts_Data_LONG_2017_to_2023$ACHIEVEMENT_LEVEL) <- c("Level 1", "Level 2", "Level 3", "Level 4")
Massachusetts_Data_LONG_2017_to_2023[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]

Massachusetts_Data_LONG_2017_to_2023[,YEAR:=as.character(YEAR)]

Massachusetts_Data_LONG_2017_to_2023[,ASSESSMENT_PROGRAM:=NULL]

Massachusetts_Data_LONG_2017_to_2023[,MODE:=as.factor(MODE)]
levels(Massachusetts_Data_LONG_2017_to_2023$MODE) <- c("Online", "Paper", "Remote")
Massachusetts_Data_LONG_2017_to_2023[,MODE:=as.character(MODE)]

Massachusetts_Data_LONG_2017_to_2023[,ACHIEVEMENT_LEVEL_ORIGINAL:=as.factor(ACHIEVEMENT_LEVEL_ORIGINAL)]
levels(Massachusetts_Data_LONG_2017_to_2023$ACHIEVEMENT_LEVEL_ORIGINAL) <- c("Advanced", "Exceeding", "Meeting", "Needs Improvement", "Not Meeting", "Partially Meeting", "Proficient", "Warning/Failing", "Warning/Failing")
Massachusetts_Data_LONG_2017_to_2023[,ACHIEVEMENT_LEVEL_ORIGINAL:=as.character(ACHIEVEMENT_LEVEL_ORIGINAL)]

Massachusetts_Data_LONG_2017_to_2023[,VALID_CASE:="VALID_CASE"]

### Setkey and look for duplicates
setkey(Massachusetts_Data_LONG_2017_to_2023, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
table(duplicated(Massachusetts_Data_LONG_2017_to_2023, by=key(Massachusetts_Data_LONG_2017_to_2023)))

### Reorder columns

my.order <- c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "SCALE_SCORE_CSEM",
            "SCALE_SCORE_ORIGINAL", "ACHIEVEMENT_LEVEL_ORIGINAL", "SCALE_SCORE_ACTUAL", "MODE")
setcolorder(Massachusetts_Data_LONG_2017_to_2023, my.order)

### Create 2021 Data

Massachusetts_Data_LONG_2023 <- Massachusetts_Data_LONG_2017_to_2023[YEAR=="2023"]

### Save results
save(Massachusetts_Data_LONG_2023, file="Data/Massachusetts_Data_LONG_2023.Rdata")
save(Massachusetts_Data_LONG_2017_to_2023, file="Data/Massachusetts_Data_LONG_2017_to_2023.Rdata")
