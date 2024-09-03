##############################################################################################
###                                                                                        ###
###   Massachusetts Learning Loss Analyses -- 2019 Consecutive Year Growth Percentiles     ###
###                                                                                        ###
##############################################################################################

###   Load packages
require(SGP)
require(data.table)

###   Load data and remove years that will not be used.
load("Data/Massachusetts_SGP.Rdata")

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- SGPmatrices::addBaselineMatrices("MA", "2021")

### NULL out assessment transition in 2019 (since already dealth with)
SGPstateData[["MA"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL
SGPstateData[["MA"]][["Assessment_Program_Information"]][["Scale_Change"]] <- NULL

###   Read in BASELINE percentiles configuration scripts and combine
source("SGP_CONFIG/2019/BASELINE/Percentiles/ELA.R")
source("SGP_CONFIG/2019/BASELINE/Percentiles/MATHEMATICS.R")

MA_2019_Config <- c(
	ELA_2019.config,
	MATHEMATICS_2019.config
)

#####
###   Run BASELINE SGP analysis - create new Massachusetts_SGP object with historical data
#####

SGPstateData[["MA"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

Massachusetts_SGP <- abcSGP(
        sgp_object = Massachusetts_SGP,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = MA_2019_Config,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = FALSE, #  Calculated in next step
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
				BACKEND = "PARALLEL",
				WORKERS=list(PERCENTILES=8, BASELINE_PERCENTILES=8))
)

###   Save results
save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
