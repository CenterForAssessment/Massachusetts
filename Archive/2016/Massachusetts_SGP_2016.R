#####################################################################################
###                                                                               ###
###           Calculate SGPs for 2015 and 2016 Massachusetts MCAS/PARCC           ###
###                                                                               ###
#####################################################################################

require(SGP)

setwd("/media/Data/Dropbox/SGP/Massachusetts")


###  2015

load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2015.Rdata")

source("/media/Data/Dropbox/Github_Repos/Projects/Massachusetts/SGP_CONFIG/2015/ELA.R")
source("/media/Data/Dropbox/Github_Repos/Projects/Massachusetts/SGP_CONFIG/2015/MATHEMATICS.R")

MA_2015.config <- c(MATHEMATICS_2015.config, ELA_2015.config)

Massachusetts_SGP <- updateSGP(
  state = "MA_2016",
  what_sgp_object=Massachusetts_SGP,
  with_sgp_data_LONG=Massachusetts_Data_LONG_2015,
  sgp.config = MA_2015.config,
  steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
  sgp.percentiles = TRUE,
  sgp.projections = FALSE,
  sgp.projections.lagged = FALSE,
  sgp.percentiles.baseline=FALSE,
  sgp.projections.baseline = FALSE,
  sgp.projections.lagged.baseline = FALSE,
  sgp.percentiles.equated = FALSE,
  simulate.sgps = FALSE,
  save.intermediate.results=FALSE,
  outputSGP.output.type=c("LONG_FINAL_YEAR_Data", "WIDE_Data"),
  parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12)))
 

 ###  2016

load("Data/Massachusetts_Data_LONG_2016.Rdata")

source("/media/Data/Dropbox/Github_Repos/Projects/Massachusetts/SGP_CONFIG/2016/ELA.R")
source("/media/Data/Dropbox/Github_Repos/Projects/Massachusetts/SGP_CONFIG/2016/MATHEMATICS.R")

MA_2016.config <- c(MATHEMATICS_2016.config, ELA_2016.config)

Massachusetts_SGP <- updateSGP(
  state = "MA_2016",
  what_sgp_object=Massachusetts_SGP,
  with_sgp_data_LONG=Massachusetts_Data_LONG_2016,
  sgp.config = MA_2016.config,
  steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
  sgp.percentiles = TRUE,
  sgp.projections = FALSE,
  sgp.projections.lagged = FALSE,
  sgp.percentiles.baseline=FALSE,
  sgp.projections.baseline = FALSE,
  sgp.projections.lagged.baseline = FALSE,
  sgp.percentiles.equated = FALSE,
  simulate.sgps = FALSE,
  save.intermediate.results=FALSE,
  outputSGP.output.type=c("LONG_Data", "LONG_FINAL_YEAR_Data", "WIDE_Data"),
  parallel.config = list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=12)))
  
save(Massachusetts_SGP, file=("Data/Massachusetts_SGP.Rdata"))
