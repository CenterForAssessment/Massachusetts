####################################################################
###
### Massachusetts SGP data for 2013
###
####################################################################

### Load SGP package

require(SGP)


### Load data

load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2013.Rdata")


### Merge 2013 data with prior data

Massachusetts_SGP@Data <- rbind.fill(Massachusetts_SGP@Data, Massachusetts_Data_LONG_2013)


### prepareSGP

Massachusetts_SGP <- prepareSGP(Massachusetts_SGP)


### analyzeSGP

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
			years="2013",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=TRUE,
			sgp.projections.baseline=TRUE,
			sgp.projections.lagged.baseline=TRUE)
#			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10)))

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")


### combineSGP

Massachusetts_SGP <- combineSGP(Massachusetts_SGP)


### save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
