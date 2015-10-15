####################################################################
###
### Massachusetts SGP data for 2015
###
####################################################################

### Load SGP package

require(SGP)
require(data.table)


### Load data

load("Data/Massachusetts_SGP_LONG_Data.Rdata")
load("Data/Massachusetts_SGP_Coefficient_Matrices_2015.Rdata")

### Create data sets

Massachusetts_SGP_LONG_Data[,STANDARD_ERROR:=NULL]
Massachusetts_SGP_LONG_Data_2015 <- Massachusetts_SGP_LONG_Data[YEAR=="2015", c("ID", "GRADE", "SCALE_SCORE_ACTUAL", "ACHIEVEMENT_LEVEL", "SCALE_SCORE", "VALID_CASE", "CONTENT_AREA", "YEAR"), with=FALSE]
Massachusetts_Data_LONG <- rbindlist(list(Massachusetts_SGP_LONG_Data[YEAR!="2015"], Massachusetts_SGP_LONG_Data_2015), fill=TRUE)


### Merge 2015 data with prior data

Massachusetts_SGP <- prepareSGP(Massachusetts_Data_LONG)
Massachusetts_SGP@SGP$Coefficient_Matrices <- Massachusetts_SGP_Coefficient_Matrices_2015


### prepareSGP

Massachusetts_SGP <- prepareSGP(Massachusetts_SGP)


### STEP 1: MATHEMATICS

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
			years="2015",
			content_areas="MATHEMATICS",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.use.my.coefficient.matrices=list(my.year="2015", my.subject="MATHEMATICS"))#,
#			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=6)))


### STEP 2: ELA

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
			years="2015",
			content_areas="ELA",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.use.my.coefficient.matrices=list(my.year="2015", my.subject="ELA"))#,
#			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=6)))


### combineSGP

Massachusetts_SGP <- combineSGP(Massachusetts_SGP, years="2015")


### outputSGP

outputSGP(Massachusetts_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"))
