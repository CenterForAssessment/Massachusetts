####################################################################################
###                                                                              ###
###          Massachusetts 2019 consecutive-year BASELINE SGP analyses           ###
###           and Skip-Two Year BASELINE SGP analyses                            ###
###          NOTE: Doing this in 2022 thus the file name                         ###
###                                                                              ###
####################################################################################


###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

###   Load data
load("Data/Massachusetts_SGP.Rdata")
Massachusetts_SGP@SGP[['SGPercentiles']][['ELA.2019.BASELINE']] <- NULL
Massachusetts_SGP@SGP[['SGPercentiles']][['MATHEMATICS.2019.BASELINE']] <- NULL

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("MA", "2022")
SGPstateData[["MA"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

###   Rename the skip-year SGP variables and objects (finished in May, 2022)
# ##    We can simply rename the BASELINE variables. We only have 2019/21 skip yr
# table(Massachusetts_SGP@Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
# baseline.names <- grep("BASELINE", names(Massachusetts_SGP@Data), value = TRUE)
# setnames(Massachusetts_SGP@Data,
#          baseline.names,
#          paste0(baseline.names, "_SKIP_YEAR"))

# sgps.2019 <- grep(".2019.BASELINE", names(Massachusetts_SGP@SGP[["SGPercentiles"]]))
# names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019] <-
#     gsub(".2019.BASELINE",
#          ".2019.SKIP_YEAR_BASELINE",
#          names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019])

###   Read in SGP Configuration Scripts for Skip-Two Year Analyses and Combine
source("SGP_CONFIG/2022/PART_A/ELA_SKIP_2_YEAR.R")
source("SGP_CONFIG/2022/PART_A/MATHEMATICS_SKIP_2_YEAR.R")

MA_Baseline_SKIP_2_YEAR_2019_Config <- c(
  ELA_2019_SKIP_2_YEAR.config,
  MATHEMATICS_2019_SKIP_2_YEAR.config
)

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2022/PART_A/ELA.R")
source("SGP_CONFIG/2022/PART_A/MATHEMATICS.R")

MA_Baseline_Config_2019 <- c(
  ELA_2019.config,
  MATHEMATICS_2019.config
)

###   Parallel Config
parallel.config <- list(BACKEND = "PARALLEL",
                        WORKERS = list(BASELINE_PERCENTILES = 4))

#####
###   Run abcSGP analysis for SKIP_2_YEAR
#####

Massachusetts_SGP <-
    abcSGP(sgp_object = Massachusetts_SGP,
           years = "2019",
           steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
           sgp.config = MA_Baseline_SKIP_2_YEAR_2019_Config,
           sgp.percentiles = FALSE,
           sgp.projections = FALSE,
           sgp.projections.lagged = FALSE,
           sgp.percentiles.baseline = TRUE,
           sgp.projections.baseline = FALSE,
           sgp.projections.lagged.baseline = FALSE,
           simulate.sgps = FALSE,
           goodness.of.fit.print = FALSE,
           parallel.config = parallel.config)
stop("I'M HERE")
####   Rename the skip-2-year SGP variables and objects
from.variable.names.sgp.baseline <- c("SGP_BASELINE", "SGP_BASELINE_ORDER_1", "SGP_BASELINE_ORDER_1_STANDARD_ERROR", "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE", "SGP_BASELINE_STANDARD_ERROR")
to.variable.names.sgp.baseline <- paste(c("SGP_BASELINE", "SGP_BASELINE_ORDER_1", "SGP_BASELINE_ORDER_1_STANDARD_ERROR", "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE", "SGP_BASELINE_STANDARD_ERROR"), "SKIP_2_YEAR", sep="_")
Massachusetts_SGP@Data[YEAR=="2019", (to.variable.names.sgp.baseline):=.SD, .SDcols=from.variable.names.sgp.baseline]

sgps.2019.baseline <- grep(".2019.BASELINE", names(Massachusetts_SGP@SGP[["SGPercentiles"]]))
names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019.baseline] <- gsub(".2019.BASELINE", ".2019.BASELINE.SKIP_2_YEAR", names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019.baseline])


#####
###   Run abcSGP analysis for Consecutive Year
#####

Massachusetts_SGP <-
    abcSGP(sgp_object = Massachusetts_SGP,
           years = "2019",
           steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
           sgp.config = MA_Baseline_Config_2019,
           sgp.percentiles = FALSE,
           sgp.projections = FALSE,
           sgp.projections.lagged = FALSE,
           sgp.percentiles.baseline = TRUE,
           sgp.projections.baseline = FALSE,
           sgp.projections.lagged.baseline = FALSE,
           simulate.sgps = FALSE,
           parallel.config = parallel.config)

###   Save results
save(Massachusetts_SGP, file = "Data/Massachusetts_SGP.Rdata")
