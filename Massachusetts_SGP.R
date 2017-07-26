#####################################################################################
###                                                                               ###
###           Calculate SGPs for 2017 Massachusetts MCAS 2.0                      ###
###                                                                               ###
#####################################################################################

### Load packages

require(SGP)


### Load data

load("Data/Massachusetts_Data_LONG.Rdata")


### Load configurations

source("SGP_CONFIG/2017/ELA.R")
source("SGP_CONFIG/2017/MATHEMATICS.R")

MA_2017.config <- c(MATHEMATICS_2017.config, ELA_2017.config)


### abcSGP

Massachusetts_SGP <- abcSGP(
            sgp_object=Massachusetts_Data_LONG,
            sgp.config = MA_2017.config,
            steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
            sgp.percentiles = TRUE,
            sgp.projections = FALSE,
            sgp.projections.lagged = FALSE,
            sgp.percentiles.baseline=FALSE,
            sgp.projections.baseline = FALSE,
            sgp.projections.lagged.baseline = FALSE,
            sgp.percentiles.equated = FALSE,
            simulate.sgps = FALSE,
            sgp.target.scale.scores = FALSE,
            save.intermediate.results=FALSE)#,
#            parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12)))


### Save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
