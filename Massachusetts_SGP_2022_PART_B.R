######################################################################
###                                                                ###
###                Massachusetts SGP analyses for 2022             ###
###                                                                ###
######################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2022.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("MA", "2022")

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_A/ELA.R")
source("SGP_CONFIG/2022/PART_A/MATHEMATICS.R")

MA_CONFIG <- c(ELA_2022.config, MATHEMATICS_2022.config)
MA_BASELINE_CONFIG <- c(ELA_Baseline_2022.config, MATHEMATICS_Baseline_2022.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   Run updateSGP cohort-referenced analysis
#####

Massachusetts_SGP <- updateSGP(
        what_sgp_object = Massachusetts_SGP,
        with_sgp_data_LONG = Massachusetts_Data_LONG_2022,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = MA_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = FALSE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)


#####
###   Run abcSGP baseline-referenced analysis
#####

Massachusetts_SGP <- abcSGP(
        sgp_object = Massachusetts_SGP,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = MA_BASELINE_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
#save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
