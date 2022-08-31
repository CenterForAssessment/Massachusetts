####################################################################################
###                                                                              ###
###          Massachusetts 2019 consecutive-year BASELINE SGP analyses           ###
###          NOTE: Doing this in 2022 thus the file name                         ###
###                                                                              ###
####################################################################################

###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

###   Load data
load("Data/Massachusetts_SGP.Rdata")

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("MA", "2022")
SGPstateData[["MA"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

###   Rename the skip-year SGP variables and objects

##    We can simply rename the BASELINE variables. We only have 2019/21 skip yr
# table(Massachusetts_SGP@Data[!is.na(SGP_BASELINE),
#         .(CONTENT_AREA, YEAR), GRADE], exclude = NULL)
baseline.names <- grep("BASELINE", names(Massachusetts_SGP@Data), value = TRUE)
setnames(Massachusetts_SGP@Data,
         baseline.names,
         paste0(baseline.names, "_SKIP_YEAR"))

sgps.2019 <- grep(".2019.BASELINE", names(Massachusetts_SGP@SGP[["SGPercentiles"]]))
names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019] <-
    gsub(".2019.BASELINE",
         ".2019.SKIP_YEAR_BASELINE",
         names(Massachusetts_SGP@SGP[["SGPercentiles"]])[sgps.2019])


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
###   Run abcSGP analysis
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
