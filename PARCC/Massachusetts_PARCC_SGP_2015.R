####################################################################
###
### Massachusetts SGP data for 2015 PARCC
###
####################################################################

### Load SGP package

require(SGP)
require(data.table)


### Load data

load("Data/OLD_Data/Massachusetts_SGP_LONG_Data.Rdata")
load("Data/OLD_Data/Massachusetts_Data_LONG_2015.Rdata")


### Merge 2015 data with prior data

Massachusetts_PARCC_SGP_LONG_Data <- rbindlist(list(Massachusetts_SGP_LONG_Data, Massachusetts_Data_LONG_2015), fill=TRUE)


### Load configurations

source("SGP_CONFIG/2015/ELA.R")
source("SGP_CONFIG/2015/MATHEMATICS.R")
MA_PARCC_CONFIG <- c(ELA_2015.config, MATHEMATICS_2015.config)


### prepareSGP

Massachusetts_PARCC_SGP <- prepareSGP(Massachusetts_PARCC_SGP_LONG_Data)


### STEP 1: analyzeSGP with SAMPLE to generate coefficient matrices

Massachusetts_PARCC_SGP <- analyzeSGP(Massachusetts_PARCC_SGP,
			years="2015",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.config=MA_PARCC_CONFIG,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8)))

save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")


### STEP 2: analyzeSGP with entire data set

Massachusetts_PARCC_SGP@Data$VALID_CASE[Massachusetts_PARCC_SGP@Data$YEAR=="2015"] <- "VALID_CASE"
Massachusetts_PARCC_SGP@SGP$SGPercentiles$MATHEMATICS.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$SGPercentiles$ELA.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$SGPercentiles$ALGEBRA_I.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$Goodness_of_Fit$MATHEMATICS.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$Goodness_of_Fit$ELA.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$Goodness_of_Fit$ALGEBRA_I.2015 <- NULL

Massachusetts_PARCC_SGP <- prepareSGP(Massachusetts_PARCC_SGP)

debug(analyzeSGP)
Massachusetts_PARCC_SGP <- analyzeSGP(Massachusetts_PARCC_SGP,
			years="2015",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.config=MA_PARCC_CONFIG,
			sgp.use.my.coefficient.matrices=TRUE)#,
#			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8)))

save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")


### combineSGP

Massachusetts_PARCC_SGP <- combineSGP(Massachusetts_PARCC_SGP, years="2015")


### outputSGP

outputSGP(Massachusetts_PARCC_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"))


### save results

save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")
