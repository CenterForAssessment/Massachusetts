#####################################################################################
###                                                                               ###
###           Calculate SGPs for 2017 Massachusetts MCAS 2.0                      ###
###                                                                               ###
#####################################################################################

### Load packages

require(SGP)
options(warn=2)


### Load data

load("Data/Massachusetts_Data_LONG.Rdata")


### Load Knots and Boundaries

#load("MA_2017_Knots_Boundaries.Rdata")
#SGPstateData[["MA"]][["Achievement"]][["Knots_Boundaries"]] <- MA_2017_Knots_Boundaries


### Load configurations

source("SGP_CONFIG/2017/ELA.R")
source("SGP_CONFIG/2017/MATHEMATICS.R")

MA_2017.config <- c(MATHEMATICS_2017.config, ELA_2017.config)


### NULL out Cutscores for the time being:

SGPstateData[["MA"]][["Achievement"]][["Cutscores"]] <- NULL


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
            simulate.sgps = TRUE,
            sgp.target.scale.scores = FALSE,
            save.intermediate.results = FALSE,
            parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12)))


### Save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
