#####################################################################################
###                                                                               ###
###           Calculate SGPs for 2019 Massachusetts MCAS 2.0                      ###
###                                                                               ###
#####################################################################################

### Load packages

require(SGP)
options(warn=2)


### Load data

load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2019.Rdata")


### Load configurations

source("SGP_CONFIG/2019/ELA.R")
source("SGP_CONFIG/2019/MATHEMATICS.R")

MA_2019.config <- c(MATHEMATICS_2019.config, ELA_2019.config)


### abcSGP

Massachusetts_SGP <- updateSGP(
            Massachusetts_SGP,
            Massachusetts_Data_LONG_2019,
            sgp.config = MA_2019.config,
            steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
            sgp.percentiles=TRUE,
            sgp.projections=TRUE,
            sgp.projections.lagged=TRUE,
            sgp.percentiles.baseline=FALSE,
            sgp.projections.baseline=FALSE,
            sgp.projections.lagged.baseline=FALSE,
            sgp.percentiles.equated=FALSE,
            simulate.sgps=TRUE,
            sgp.target.scale.scores=TRUE,
            save.intermediate.results=FALSE,
            parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4, SUMMARY=2, GA_PLOTS=2, SG_PLOTS=1)))


### Save results

#save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
