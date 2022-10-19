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

###   Reading SGP Configuration Scripts for Skip-Two Year Analyses and Combine
source("SGP_CONFIG/2022/PART_B/ELA_SKIP_2_YEAR.R")
source("SGP_CONFIG/2022/PART_B/MATHEMATICS_SKIP_2_YEAR.R")

MA_BASELINE_SKIP_2_YEAR_CONFIG <- c(
  ELA_2022_SKIP_2_YEAR.config,
  MATHEMATICS_2022_SKIP_2_YEAR.config
)

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_B/ELA.R")
source("SGP_CONFIG/2022/PART_B/MATHEMATICS.R")

MA_CONFIG <- c(ELA_2022.config, MATHEMATICS_2022.config)
MA_BASELINE_CONFIG <- c(ELA_Baseline_2022.config, MATHEMATICS_Baseline_2022.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2, BASELINE_PERCENTILES=2, PROJECTIONS=2, LAGGED_PROJECTIONS=2, SGP_SCALE_SCORE_TARGETS=2))

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
###   Run abcSGP baseline-referenced analysis skip 2-year
#####

Massachusetts_SGP <- abcSGP(
        sgp_object = Massachusetts_SGP,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = MA_BASELINE_SKIP_2_YEAR_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

####   Rename the skip-2-year SGP variables and objects
from.variable.names.sgp.baseline <- c("SGP_BASELINE", "SGP_BASELINE_ORDER_1", "SGP_BASELINE_ORDER_1_STANDARD_ERROR", "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE", "SGP_BASELINE_STANDARD_ERROR")
to.variable.names.sgp.baseline <- paste(c("SGP_BASELINE", "SGP_BASELINE_ORDER_1", "SGP_BASELINE_ORDER_1_STANDARD_ERROR", "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE", "SGP_BASELINE_STANDARD_ERROR"), "SKIP_2_YEAR", sep="_")
Massachusetts_SGP@Data[YEAR=="2022", (to.variable.names.sgp.baseline):=.SD, .SDcols=from.variable.names.sgp.baseline]

sgps.2022.baseline <- grep(".2022.BASELINE", names(Massachusetts_SGP@SGP[["SGPercentiles"]]))
names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2022.baseline] <- gsub(".2022.BASELINE", ".2022.BASELINE.SKIP_2_YEAR", names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2022.baseline])

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
