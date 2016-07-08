####################################################################
###
### Massachusetts SGP data for 2015 PARCC
###
####################################################################

### Load SGP package

require(SGP)
require(data.table)


### Load data

load("Data/Massachusetts_SGP_LONG_Data.Rdata")
load("Data/Massachusetts_PARCC_Data_LONG_2015.Rdata")


### Merge 2015 data with prior data

Massachusetts_PARCC_SGP_LONG_Data <- rbindlist(list(Massachusetts_SGP_LONG_Data, Massachusetts_PARCC_Data_LONG_2015), fill=TRUE)


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
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.percentiles.equating.method=c("identity", "mean", "linear", "equipercentile"),
			sgp.config=MA_PARCC_CONFIG,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8)))

save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")


### STEP 2: analyzeSGP with entire data set

Massachusetts_PARCC_SGP@Data$VALID_CASE[Massachusetts_PARCC_SGP@Data$YEAR=="2015"] <- "VALID_CASE"

Massachusetts_PARCC_SGP <- updateSGP(Massachusetts_PARCC_SGP,
			years="2015",
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "visualizeSGP", "outputSGP"),
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.target.scale.scores=TRUE,
			sgp.config=MA_PARCC_CONFIG,
			plot.types="studentGrowthPlot",
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8, PROJECTIONS=8, LAGGED_PROJECTIONS=8, SGP_SCALE_SCORE_TARGETS=8, SG_PLOTS=1)))


### save results

save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")
