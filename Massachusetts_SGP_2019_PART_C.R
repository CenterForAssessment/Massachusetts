###############################################################################################
###                                                 .                                       ###
###   Massachusetts Learning Loss Analyses -- 2019 Skip-Year Growth Percentiles             ###
###                                                                                         ###
###############################################################################################

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
source("SGP_CONFIG/2019/BASELINE/Percentiles_SKIP_YEAR/ELA.R")
source("SGP_CONFIG/2019/BASELINE/Percentiles_SKIP_YEAR/MATHEMATICS.R")

MA_2019_Skip_Year_Config <- c(
	ELA_2019.config,
	MATHEMATICS_2019.config
)

#####
###   Run BASELINE SGP analysis - create new Massachusetts_SGP object with historical data
#####

SGPstateData[["MA"]][["Assessment_Program_Information"]][["CSEM"]] <- "SCALE_SCORE_CSEM" 

Massachusetts_SGP <- abcSGP(
        sgp_object = Massachusetts_SGP,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = MA_2019_Skip_Year_Config,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,  #  Skip year SGPs for 2021 comparisons
        sgp.projections.baseline = FALSE, #  Calculated in next step
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
					BACKEND = "PARALLEL",
					WORKERS=list(PERCENTILES=8, BASELINE_PERCENTILES=8))
)

### Copy 2019 SGP data to SKIP_YEAR variables 
variables.to.rename <- c("SGP_ORDER_1", "SGP_ORDER_2", "SGP", "SGP_LEVEL", "SGP_ORDER_1_STANDARD_ERROR", "SGP_ORDER_2_STANDARD_ERROR",
  "SGP_STANDARD_ERROR", "SGP_NORM_GROUP", "SCALE_SCORE_PRIOR", "SCALE_SCORE_PRIOR_STANDARDIZED", "SGP_NORM_GROUP_SCALE_SCORES",
  "SGP_BASELINE_ORDER_1", "SGP_BASELINE_ORDER_2", "SGP_BASELINE", "SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE",
  "SGP_BASELINE", "SCALE_SCORE_PRIOR_BASELINE", "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE",
  "SGP_NORM_GROUP_BASELINE_SCALE_SCORES")

for (variables.to.rename.iter in variables.to.rename) {
  Massachusetts_SGP@Data[,(paste0(variables.to.rename.iter, "_SKIP_YEAR")):=eval(parse(text=variables.to.rename.iter))]
}

names(Massachusetts_SGP@SGP$SGPercentiles) <- paste(names(Massachusetts_SGP@SGP$SGPercentiles), "SKIP_YEAR", sep=".")

###   Save results
save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
