####################################################################
###
### Massachusetts SGP data for 2015 PARCC
###
####################################################################

### Load SGP package

require(SGP)
require(data.table)


### Load data

load("Data/OLD_Data/Massachusetts_SGP_LONG_Data.Rdata")
load("Data/OLD_Data/Massachusetts_PARCC_Data_LONG_2015.Rdata")


### Merge 2015 data with prior data

Massachusetts_PARCC_SGP_LONG_Data <- rbindlist(list(Massachusetts_SGP_LONG_Data, Massachusetts_PARCC_Data_LONG_2015), fill=TRUE)


### Load configurations

source("SGP_CONFIG/2015/ELA.R")
source("SGP_CONFIG/2015/MATHEMATICS.R")
MA_PARCC_CONFIG <- c(ELA_2015.config, MATHEMATICS_2015.config)


### prepareSGP

Massachusetts_PARCC_SGP <- prepareSGP(Massachusetts_PARCC_SGP_LONG_Data)


### STEP 1: analyzeSGP with SAMPLE to generate coefficient matrices

Massachusetts_PARCC_SGP <- analyzeSGP(Massachusetts_PARCC_SGP,
			years="2015",
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.percentiles.equating.method=c("identity", "mean", "linear", "equipercentile"),
			sgp.config=MA_PARCC_CONFIG,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8)))

save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")


### STEP 2: analyzeSGP with entire data set

Massachusetts_PARCC_SGP@Data$VALID_CASE[Massachusetts_PARCC_SGP@Data$YEAR=="2015"] <- "VALID_CASE"
Massachusetts_PARCC_SGP@SGP$SGPercentiles$MATHEMATICS.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$SGPercentiles$ELA.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$SGPercentiles$ALGEBRA_I.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$Goodness_of_Fit$MATHEMATICS.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$Goodness_of_Fit$ELA.2015 <- NULL
Massachusetts_PARCC_SGP@SGP$Goodness_of_Fit$ALGEBRA_I.2015 <- NULL

Massachusetts_PARCC_SGP <- prepareSGP(Massachusetts_PARCC_SGP)

Massachusetts_PARCC_SGP <- analyzeSGP(Massachusetts_PARCC_SGP,
			years="2015",
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=TRUE,
			sgp.config=MA_PARCC_CONFIG,
			sgp.use.my.coefficient.matrices=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=8)))


save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")


### combineSGP

Massachusetts_PARCC_SGP <- combineSGP(Massachusetts_PARCC_SGP, years="2015")


### outputSGP

outputSGP(Massachusetts_PARCC_SGP, output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data"))


### save results

save(Massachusetts_PARCC_SGP, file="Data/Massachusetts_PARCC_SGP.Rdata")


###  
### STEP 2b: analyzeSGP to calculate projections
###

##  NOTE:  sgp.projection.grade.sequences="NO_PROJECTIONS" added to Algebra I SGP_CONFIG script

Massachusetts_PARCC_SGP <- analyzeSGP(Massachusetts_PARCC_SGP,
			years="2015",
			sgp.percentiles=FALSE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			sgp.percentiles.equated=FALSE,
			sgp.config=MA_PARCC_CONFIG,
			sgp.use.my.coefficient.matrices=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PROJECTIONS=22)))


###  
### visualizeSGP
###


##	Old SGP object requires 'EQUIPERCENTILE' branch of the @SGP$Linkages...  list elements:

for (content_area in names(Massachusetts_PARCC_SGP@SGP$Linkages)) {
	for(g in names(Massachusetts_PARCC_SGP@SGP$Linkages[[content_area]])) {
		tmp.list <- Massachusetts_PARCC_SGP@SGP$Linkages[[content_area]][[g]]
		Massachusetts_PARCC_SGP@SGP$Linkages[[content_area]][[g]] <- NULL
		Massachusetts_PARCC_SGP@SGP$Linkages[[content_area]][[g]][["EQUIPERCENTILE"]] <- tmp.list
	}
}

visualizeSGP(
		Massachusetts_PARCC_SGP,
		state = "MA_PARCC",
		plot.types = c("studentGrowthPlot"),
		sgPlot.demo.report = TRUE,
		sgPlot.plot.test.transition=TRUE)

