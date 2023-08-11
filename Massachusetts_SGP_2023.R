####################################################################################################
###                                                                                              ###
###          SGP STRAIGHT BASELINE-REFERENCED projections for skip year SGP analyses for 2023    ###
###                                                                                              ###
####################################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2023.Rdata")

###   Load configurations
source("SGP_CONFIG/2023/ELA.R")
source("SGP_CONFIG/2023/MATHEMATICS.R")

MA_CONFIG <- c(ELA_2023.config, MATHEMATICS_2023.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("MA", "2023")

#  Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["MA"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3=c(3, 4, 5, 6, 7, 8, 10),
    ELA_GRADE_4=c(3, 4, 5, 6, 7, 8, 10),
    ELA_GRADE_5=c(3, 4, 5, 6, 7, 8, 10),
    ELA_GRADE_6=c(3, 4, 5, 6, 7, 8, 10),
    ELA_GRADE_7=c(3, 4, 5, 6, 7, 8, 10),
    ELA_GRADE_8=c(3, 4, 5, 6, 7, 8, 10),
    ELA_GRADE_10=c(3, 4, 5, 6, 7, 8, 10),
    MATHEMATICS_GRADE_3=c(3, 4, 5, 6, 7, 8, 10),
    MATHEMATICS_GRADE_4=c(3, 4, 5, 6, 7, 8, 10),
    MATHEMATICS_GRADE_5=c(3, 4, 5, 6, 7, 8, 10),
    MATHEMATICS_GRADE_6=c(3, 4, 5, 6, 7, 8, 10),
    MATHEMATICS_GRADE_7=c(3, 4, 5, 6, 7, 8, 10),
    MATHEMATICS_GRADE_8=c(3, 4, 5, 6, 7, 8, 10),
    MATHEMATICS_GRADE_10=c(3, 4, 5, 6, 7, 8, 10))
SGPstateData[["MA"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3=rep("ELA", 7),
    ELA_GRADE_4=rep("ELA", 7),
    ELA_GRADE_5=rep("ELA", 7),
    ELA_GRADE_6=rep("ELA", 7),
    ELA_GRADE_7=rep("ELA", 7),
    ELA_GRADE_8=rep("ELA", 7),
    ELA_GRADE_10=rep("ELA", 7),
    MATHEMATICS_GRADE_3=rep("MATHEMATICS", 7),
    MATHEMATICS_GRADE_4=rep("MATHEMATICS", 7),
    MATHEMATICS_GRADE_5=rep("MATHEMATICS", 7),
    MATHEMATICS_GRADE_6=rep("MATHEMATICS", 7),
    MATHEMATICS_GRADE_7=rep("MATHEMATICS", 7),
    MATHEMATICS_GRADE_8=rep("MATHEMATICS", 7),
    MATHEMATICS_GRADE_10=rep("MATHEMATICS", 7))
SGPstateData[["MA"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3=3,
    ELA_GRADE_4=3,
    ELA_GRADE_5=3,
    ELA_GRADE_6=3,
    ELA_GRADE_7=3,
    ELA_GRADE_8=3,
    ELA_GRADE_10=3,
    MATHEMATICS_GRADE_3=3,
    MATHEMATICS_GRADE_4=3,
    MATHEMATICS_GRADE_5=3,
    MATHEMATICS_GRADE_6=3,
    MATHEMATICS_GRADE_7=3,
    MATHEMATICS_GRADE_8=3,
    MATHEMATICS_GRADE_10=3)

###   Run analysis

Massachusetts_SGP <- updateSGP(
        Massachusetts_SGP,
	Massachusetts_Data_LONG_2023,
        steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config=MA_CONFIG,
        sgp.percentiles=TRUE,
        sgp.projections=TRUE,
        sgp.projections.lagged=TRUE,
        sgp.percentiles.baseline=TRUE,
        sgp.projections.baseline=TRUE,
        sgp.projections.lagged.baseline=TRUE,
        sgp.target.scale.scores=TRUE,
        parallel.config=parallel.config
)

###   Save results
#save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
