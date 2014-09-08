####################################################################
###
### Massachusetts SGP data for 2014
###
####################################################################

### Load SGP package

require(SGP)
require(data.table)


### Load data

load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2014.Rdata")


### Merge 2014 data with prior data

Massachusetts_SGP@Data <- rbind.fill(Massachusetts_SGP@Data, Massachusetts_Data_LONG_2014)


### prepareSGP

Massachusetts_SGP <- prepareSGP(Massachusetts_SGP)


### analyzeSGP

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
			years="2014",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12, BASELINE_PERCENTILES=12, PROJECTIONS=12, LAGGED_PROJECTIONS=12)))

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")


### combineSGP

Massachusetts_SGP <- combineSGP(Massachusetts_SGP, years="2014")


### save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
