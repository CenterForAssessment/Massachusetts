######################################################################################
###                                                                                ###
###       Massachusetts Learning Loss Analyses -- Create Baseline Matrices         ###
###                                                                                ###
######################################################################################

### Load necessary packages
require(SGP)
require(data.table)
#debug(equate:::equate.freqtab)


###   Load the results data from the 'official' 2019 SGP analyses
load("Data/Archive/PRE_2020/Massachusetts_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
Massachusetts_Baseline_Data <- data.table::data.table(Massachusetts_SGP_LONG_Data[YEAR >= "2016", c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "GRADE", "SCALE_SCORE", "ACHIEVEMENT_LEVEL"),])

### Modify knots/boundaries in SGPstateData to use equated scale scores properly
SGPstateData[["MA"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2015"]] <- SGPstateData[["MA"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2017"]]
SGPstateData[["MA"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2015"]] <- SGPstateData[["MA"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017"]]
SGPstateData[["MA"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2017"]] <- NULL
SGPstateData[["MA"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017"]] <- NULL

### Put 2016 scores on MCAS 2.0 scale (>= 2017)
SGPstateData[["MA"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Year"]] <- "2017"

### Change the number of digits associated with the rounding
SGPstateData[["MA"]][["Assessment_Program_Information"]][["Assessment_Transition"]][["Equate_Interval_Digits"]] <- 2

data.for.equate <- Massachusetts_Baseline_Data[YEAR <= "2017" & CONTENT_AREA %in% c("ELA", "MATHEMATICS")]
tmp.equate.linkages <- SGP:::equateSGP(
                                tmp.data=data.for.equate,
                                state="MA",
                                current.year="2017",
                                equating.method=c("identity", "mean", "linear", "equipercentile"))

setkey(data.for.equate, VALID_CASE, CONTENT_AREA, YEAR, GRADE, SCALE_SCORE)

data.for.equate <- SGP:::convertScaleScore(data.for.equate, "2017", tmp.equate.linkages, "OLD_TO_NEW", "equipercentile", "MA")
data.for.equate[YEAR=="2016", SCALE_SCORE:=SCALE_SCORE_EQUATED_EQUIPERCENTILE_OLD_TO_NEW]
data.for.equate[,SCALE_SCORE_EQUATED_EQUIPERCENTILE_OLD_TO_NEW:=NULL]

Massachusetts_Baseline_Data <- rbindlist(list(data.for.equate, Massachusetts_Baseline_Data[YEAR >= "2018"]))
setkey(Massachusetts_Baseline_Data, VALID_CASE, CONTENT_AREA, YEAR, ID)

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/BASELINE/Matrices/ELA.R")
source("SGP_CONFIG/2019/BASELINE/Matrices/MATHEMATICS.R")

MA_BASELINE_CONFIG <- c(
	ELA_BASELINE.config,
	MATHEMATICS_BASELINE.config
)

###
###   Create Baseline Matrices
###

Massachusetts_SGP <- prepareSGP(Massachusetts_Baseline_Data, create.additional.variables=FALSE)

MA_Baseline_Matrices <- baselineSGP(
				Massachusetts_SGP,
				sgp.baseline.config=MA_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=7))
)

###   Save results
save(MA_Baseline_Matrices, file="Data/MA_Baseline_Matrices.Rdata")


### Create SCALE_SCORE_NON_EQUATED and turn (2016) SCALE_SCORE into SCALE_SCORE_EQUATED to Massachusetts_SGP_LONG_Data and save results
Massachusetts_SGP_LONG_Data <- Massachusetts_SGP_LONG_Data[YEAR >= 2016 & CONTENT_AREA %in% c("ELA", "MATHEMATICS")]
setkey(Massachusetts_SGP_LONG_Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
setkey(Massachusetts_Baseline_Data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
Massachusetts_SGP_LONG_Data[,SCALE_SCORE_NON_EQUATED:=SCALE_SCORE]
Massachusetts_SGP_LONG_Data[,SCALE_SCORE:=Massachusetts_Baseline_Data$SCALE_SCORE]

save(Massachusetts_SGP_LONG_Data, file="Data/Massachusetts_SGP_LONG_Data.Rdata")
