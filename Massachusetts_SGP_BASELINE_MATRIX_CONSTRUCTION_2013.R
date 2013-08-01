###########################################################################################
###
### Script for creating new MATHEMATICS baseline Matrices for MATHEMATICS
### using 2013, 2012, 2011, 2010, and 2009 
###
###########################################################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/Massachusetts_SGP.Rdata")


### Delete Coefficient matrices for MA

SGPstateData$MA$Baseline_splineMatrix <- NULL
Massachusetts_SGP@SGP$Coefficient_Matrices$MATHEMATICS.BASELINE <- NULL
Massachusetts_SGP@SGP$Coefficient_Matrices$ELA.BASELINE <- NULL


### prepareSGP

Massachusetts_SGP <- prepareSGP(Massachusetts_SGP)


### analyzeSGP

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
				content_areas=c("ELA", "MATHEMATICS"),
				sgp.percentiles=FALSE,
				sgp.projections=FALSE,
				sgp.projections.lagged=FALSE,
				sgp.percentiles.baseline=TRUE,
				sgp.projections.baseline=FALSE,
				sgp.projections.lagged.baseline=FALSE,
				sgp.baseline.panel.years=as.character(2009:2013),
				parallel.config=list(BACKEND="PARALLEL", WORKERS=list(BASELINE_MATRICES=10)))
