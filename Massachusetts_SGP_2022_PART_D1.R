############################################################################################
###                                                                                      ###
###      SGP LAGGED COHORT-REFERENCED projections for skip year SGP analyses for 2022    ###
###                                                                                      ###
############################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Massachusetts_SGP.Rdata")

###   Load configurations
source("SGP_CONFIG/2022/PART_D/ELA.R")
source("SGP_CONFIG/2022/PART_D/MATHEMATICS.R")

MA_CONFIG <- c(ELA_2022.config, MATHEMATICS_2022.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("MA", "2022")
SGPstateData[["MA"]][["SGP_Configuration"]][["sgp.target.scale.scores.merge"]] <- NULL

#  Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["MA"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3=c(3, 4, 5, 6, 7, 8),
    ELA_GRADE_4=c(3, 4, 5, 6, 7, 8),
    ELA_GRADE_5=c(3, 4, 5, 6, 7, 8),
    ELA_GRADE_6=c(3, 4, 5, 6, 7, 8),
    ELA_GRADE_7=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS_GRADE_3=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS_GRADE_4=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS_GRADE_5=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS_GRADE_6=c(3, 4, 5, 6, 7, 8),
    MATHEMATICS_GRADE_7=c(3, 4, 5, 6, 7, 8))
SGPstateData[["MA"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3=rep("ELA", 6),
    ELA_GRADE_4=rep("ELA", 6),
    ELA_GRADE_5=rep("ELA", 6),
    ELA_GRADE_6=rep("ELA", 6),
    ELA_GRADE_7=rep("ELA", 6),
    MATHEMATICS_GRADE_3=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_4=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_5=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_6=rep("MATHEMATICS", 6),
    MATHEMATICS_GRADE_7=rep("MATHEMATICS", 6))
SGPstateData[["MA"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3=3,
    ELA_GRADE_4=3,
    ELA_GRADE_5=3,
    ELA_GRADE_6=3,
    ELA_GRADE_7=3,
    MATHEMATICS_GRADE_3=3,
    MATHEMATICS_GRADE_4=3,
    MATHEMATICS_GRADE_5=3,
    MATHEMATICS_GRADE_6=3,
    MATHEMATICS_GRADE_7=3)

###   Run analysis

Massachusetts_SGP <- abcSGP(
        Massachusetts_SGP,
        years = "2022",
        steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config=MA_CONFIG,
        sgp.percentiles=FALSE,
        sgp.projections=FALSE,
        sgp.projections.lagged=TRUE,
        sgp.percentiles.baseline=FALSE,
        sgp.projections.baseline=FALSE,
        sgp.projections.lagged.baseline=FALSE,
        sgp.target.scale.scores=TRUE,
        parallel.config=parallel.config
)

###   Save results
save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
