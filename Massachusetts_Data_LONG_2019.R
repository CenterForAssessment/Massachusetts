################################################################
###                                                          ###
###      Create 2019 LONG data from completed Data           ###
###                                                          ###
################################################################


### Load libraries
require(data.table)
require(SGP)


### Load data
load("Data/Base_Files/Massachusetts_SGP_LONG_Data_2019.Rdata")

### Tidy up data
variables.to.keep <- c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "ASSESSMENT_PROGRAM", "TEST_MODE", "SCALE_SCORE_CSEM", "SCALE_SCORE_NON_MODE_ADJUSTED", "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL_ORIGINAL")
Massachusetts_Data_LONG_2019 <- Massachusetts_SGP_LONG_Data_2019[,variables.to.keep, with=FALSE]

### Pull in scores that extent beyond loss/hoss

for (content_area.iter in c("ELA", "MATHEMATICS")) {
    for (grade.iter in as.character(c(3:8, 10))) {
        tmp.loss.hoss <- SGPstateData[['MA']][['Achievement']][['Knots_Boundaries']][[paste(content_area.iter, "2017", sep=".")]][[paste("loss.hoss", grade.iter, sep="_")]]
        Massachusetts_Data_LONG_2019[SCALE_SCORE <= tmp.loss.hoss[1], SCALE_SCORE:=tmp.loss.hoss[1]]
        Massachusetts_Data_LONG_2019[SCALE_SCORE >= tmp.loss.hoss[2], SCALE_SCORE:=tmp.loss.hoss[2]]
    }
}

### Setkey and look for duplicates
setkey(Massachusetts_Data_LONG_2019, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
table(duplicated(Massachusetts_Data_LONG_2019, by=key(Massachusetts_Data_LONG_2019)))

### Save results

save(Massachusetts_Data_LONG_2019, file="Data/Massachusetts_Data_LONG_2019.Rdata")
