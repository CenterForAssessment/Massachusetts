####################################################################################
###                                                                              ###
###          Massachusetts 2019 Skip-Two Year BASELINE SGP analyses              ###
###                                                                              ###
####################################################################################


###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

###   Load data and remove years that will not be used.
load("Data/Massachusetts_SGP_LONG_Data.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("MA", "2021")
SGPstateData[["MA"]][["Assessment_Program_Information"]][["CSEM"]] <- "SCALE_SCORE_CSEM" 

###   Read in SGP Configuration Scripts for Skip-Two Year Analyses and Combine
source("SGP_CONFIG/2019/BASELINE/Percentiles_SKIP_2_YEAR/ELA_SKIP_2_YEAR.R")
source("SGP_CONFIG/2019/BASELINE/Percentiles_SKIP_2_YEAR/MATHEMATICS_SKIP_2_YEAR.R")

MA_SKIP_2_YEAR_2019_Config <- c(
  ELA_2019_SKIP_2_YEAR.config,
  MATHEMATICS_2019_SKIP_2_YEAR.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS = list(BASELINE_PERCENTILES = 4))

#####
###   Run abcSGP analysis for SKIP_2_YEAR
#####

Massachusetts_SGP <-
    abcSGP(sgp_object = Massachusetts_SGP_LONG_Data,
           years = "2019",
           steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
           sgp.config = MA_SKIP_2_YEAR_2019_Config,
           sgp.percentiles = FALSE,
           sgp.projections = FALSE,
           sgp.projections.lagged = FALSE,
           sgp.percentiles.baseline = TRUE,
           sgp.projections.baseline = FALSE,
           sgp.projections.lagged.baseline = FALSE,
           simulate.sgps = TRUE,
           goodness.of.fit.print = FALSE,
           parallel.config = parallel.config)

####   Rename the skip-2-year SGP variables and objects
from.variable.names.sgp.baseline <- c("SGP_BASELINE", "SGP_BASELINE_ORDER_1", "SGP_BASELINE_ORDER_1_STANDARD_ERROR", "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE", "SGP_BASELINE_STANDARD_ERROR")
to.variable.names.sgp.baseline <- paste(c("SGP_BASELINE", "SGP_BASELINE_ORDER_1", "SGP_BASELINE_ORDER_1_STANDARD_ERROR", "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE", "SGP_BASELINE_STANDARD_ERROR"), "SKIP_2_YEAR", sep="_")
Massachusetts_SGP@Data[YEAR=="2019", (to.variable.names.sgp.baseline):=.SD, .SDcols=from.variable.names.sgp.baseline]

sgps.2019.baseline <- grep(".2019.BASELINE", names(Massachusetts_SGP@SGP[["SGPercentiles"]]))
names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019.baseline] <- gsub(".2019.BASELINE", ".2019.BASELINE.SKIP_2_YEAR", names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019.baseline])

###   Save results
save(Massachusetts_SGP, file = "Data/Massachusetts_SGP.Rdata")
