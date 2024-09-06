######################################################################
###
### Script to update 2023 Massachusetts_SGP@Data with new 2023 cases
### Prior to calculation of 2024 SGPs
###
#######################################################################

### Load packages
require(SGP)
require(data.table)

### Load data
load("Data/Massachusetts_SGP.Rdata")
load("Data/Base_Files/Massachusetts_SGP_LONG_Data_2023_SARAHJO.Rdata")

### Identify cases in 2023 file not in Massachusetts_SGP@Data
tmp.2023 <- Massachusetts_SGP@Data[YEAR=="2023"]
variables.for.diff <- c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID")
tmp.diff <- fsetdiff(Massachusetts_SGP_LONG_2023_SARAHJO[,variables.for.diff, with=FALSE], tmp.2023[,variables.for.diff, with=FALSE])
tmp.additional.cases <- Massachusetts_SGP_LONG_2023_SARAHJO[tmp.diff]
tmp.2023.new <- rbindlist(list(tmp.2023, tmp.additional.cases))
tmp.data.all <- rbindlist(list(Massachusetts_SGP@Data[YEAR!="2023"], tmp.2023.new))
setkey(tmp.data.all, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

### Place updated data into @Data
Massachusetts_SGP@Data <- tmp.data.all 

### Save object
save(Massachusetts_SGP, file="Data/Massachusetts_SGP.Rdata")



