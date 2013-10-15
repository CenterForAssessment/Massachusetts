####################################################################
###
### Massachusetts SGP data for 2013
###
####################################################################

### Load SGP package

require(SGP)
require(data.table)


### Load data

load("Data/Massachusetts_SGP.Rdata")
load("Data/Massachusetts_Data_LONG_2013.Rdata")


### Merge 2013 data with prior data

Massachusetts_SGP@Data <- rbind.fill(Massachusetts_SGP@Data, Massachusetts_Data_LONG_2013)


### Add in Actual Scale Scores

load("Data/Base_Files/MA_Scale_Score_Lookup.Rdata")
slot.data <- copy(Massachusetts_SGP@Data)
setkeyv(slot.data, c("CONTENT_AREA", "YEAR", "GRADE"))
tmp.dt <- slot.data[!is.na(SCALE_SCORE) & YEAR %in% c("2009", "2010", "2011", "2012", "2013") & VALID_CASE=="VALID_CASE", 
		findInterval(as.integer(10000*SCALE_SCORE), as.integer(10000*MA_Scale_Score_Lookup[list(CONTENT_AREA[1], YEAR[1], GRADE[1])][['SCALE_SCORE']])),
		by=list(CONTENT_AREA, YEAR, GRADE)]
tmp.dt[V1==0,V1:=1]
setnames(tmp.dt, "V1", "INDEX")
slot.data[!is.na(SCALE_SCORE) & YEAR %in% c("2009", "2010", "2011", "2012", "2013") & VALID_CASE=="VALID_CASE", SCALE_SCORE_ACTUAL := 
		tmp.dt[, MA_Scale_Score_Lookup[list(CONTENT_AREA[1], YEAR[1], GRADE[1])][['TRANSFORMED_SCALE_SCORE']][INDEX], by=list(CONTENT_AREA, YEAR, GRADE)][['V1']]]


### prepareSGP

Massachusetts_SGP <- prepareSGP(Massachusetts_SGP)


### analyzeSGP

Massachusetts_SGP <- analyzeSGP(Massachusetts_SGP,
			years="2013",
			sgp.percentiles=TRUE,
			sgp.projections=FALSE,
			sgp.projections.lagged=FALSE,
			sgp.percentiles.baseline=TRUE,
			sgp.projections.baseline=TRUE,
			sgp.projections.lagged.baseline=TRUE)
#			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10)))

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")


### combineSGP

Massachusetts_SGP <- combineSGP(Massachusetts_SGP)


### save results

save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")
