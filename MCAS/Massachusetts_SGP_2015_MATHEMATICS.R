####################################################################
###
### Massachusetts SGP data for 2015
###
####################################################################

### Load SGP package

require(SGP)
require(data.table)


### NULL out assessment transition

SGPstateData[["MA"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL


### Load data

load("Data/Massachusetts_SGP_LONG_Data.Rdata")
load("Data/Massachusetts_Data_LONG_2015_MATHEMATICS.Rdata")


### Merge 2015 data with prior data

Massachusetts_SGP@Data <- rbindlist(list(Massachusetts_SGP@Data, Massachusetts_Data_LONG_2015), fill=TRUE)


### prepareSGP

Massachusetts_SGP <- prepareSGP(Massachusetts_SGP)


### STEP 1: analyzeSGP with SAMPLE to generate coefficient matrices

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
			years="2015",
			content_areas="MATHEMATICS",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE)#,
#			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=6)))

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")


### STEP 2: analyzeSGP with entire data set

Massachusetts_SGP@Data$VALID_CASE[Massachusetts_SGP@Data$YEAR=="2015"] <- "VALID_CASE"
Massachusetts_SGP@SGP$SGPercentiles$MATHEMATICS.2015 <- NULL
Massachusetts_SGP@SGP$Goodness_of_Fit$MATHEMATICS.2015 <- NULL
Massachusetts_SGP@SGP$Simulated_SGPs$MATHEMATICS.2015 <- NULL

Massachusetts_SGP <- prepareSGP(Massachusetts_SGP)

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

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")


### combineSGP

Massachusetts_SGP <- combineSGP(Massachusetts_SGP, years="2015")


### outputSGP

outputSGP(Massachusetts_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"))


### save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
