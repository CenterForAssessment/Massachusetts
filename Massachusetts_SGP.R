####################################################################
###
### Update of Massachusetts SGP data
###
####################################################################

### Load SGP package

require(SGP)


### Load data

load("Data/Base_Files/Massachusetts_SGP.Rdata")


### analyzeSGP

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
			years="2012",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=TRUE,
			sgp.projections.baseline=TRUE,
			sgp.projections.lagged.baseline=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10)))

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")


### combineSGP

Massachusetts_SGP <- combineSGP(Massachusetts_SGP)


### save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")

