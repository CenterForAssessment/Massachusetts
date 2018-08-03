#####################################################################################
###                                                                               ###
###           Calculate SGPs for 2018 Massachusetts MCAS 2.0                      ###
###                                                                               ###
#####################################################################################

### Load packages

require(SGP)
options(warn=2)


### Load data

load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2018.Rdata")


### Load configurations

source("SGP_CONFIG/2018/ELA.R")
source("SGP_CONFIG/2018/MATHEMATICS.R")

MA_2018.config <- c(MATHEMATICS_2018.config, ELA_2018.config)


### abcSGP

Massachusetts_SGP <- updateSGP(
            Massachusetts_SGP,
            Massachusetts_Data_LONG_2018,
            sgp.config = MA_2018.config,
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
            parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12)))


### Save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
