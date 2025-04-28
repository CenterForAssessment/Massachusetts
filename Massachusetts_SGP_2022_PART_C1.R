############################################################################################
###                                                                                      ###
###    SGP STRAIGHT COHORT-REFERENCED projections for skip year SGP analyses for 2022    ###
###                                                                                      ###
############################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Massachusetts_SGP.Rdata")

###   Load configurations
source("SGP_CONFIG/2022/PART_C/ELA.R")
source("SGP_CONFIG/2022/PART_C/MATHEMATICS.R")

MA_CONFIG <- c(ELA_2022.config, MATHEMATICS_2022.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("MA", "2022")
SGPstateData[["MA"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <- NULL

#  Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["MA"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS=c(3, 4, 5, 6, 7, 8))
SGPstateData[["MA"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA=rep("ELA", 6),
    MATHEMATICS=rep("MATHEMATICS", 6))
SGPstateData[["MA"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA=6,
    MATHEMATICS=6)

###   Run analysis

Massachusetts_SGP <- abcSGP(
        Massachusetts_SGP,
        years = "2022", # need to add years now (after adding 2019 baseline projections).  Why?
        steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config=MA_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=TRUE,
        sgp.projections.lagged=FALSE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=FALSE,
        sgp.projections.lagged.baseline=FALSE,
        sgp.target.scale.scores=TRUE,
        parallel.config=parallel.config
)

###   Save results
save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
