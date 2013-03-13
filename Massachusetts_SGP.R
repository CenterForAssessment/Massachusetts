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
			sgp.percentiles=FALSE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=TRUE,
			sgp.projections.baseline=TRUE,
			sgp.projections.lagged.baseline=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=30, BASELINE_PERCENTILES=8, PROJECTIONS=6, LAGGED_PROJECTIONS=6, SUMMARY=30, GA_PLOTS=10, SG_PLOTS=1)))

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")


### combineSGP

Massachusetts_SGP <- combineSGP(Massachusetts_SGP)


### save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")

