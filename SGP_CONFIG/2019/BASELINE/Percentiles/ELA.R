################################################################################
###                                                                          ###
###          Consecutive SGP Configurations for 2019 ELA subjects            ###
###                                                                          ###
################################################################################

ELA_2019.config <- list(
	ELA_2019 = list(
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2017", "2018", "2019"),
		sgp.grade.sequences=list(c("3", "4"), c("3", "4", "5"), c("4", "5", "6"), c("5", "6", "7"), c("6", "7", "8"))),
	ELA_2019 = list( ### INCLUDE here as SKIP YEAR 10th grade SGPs usually included with consecutive analyses
		sgp.content.areas=rep("ELA", 3),
		sgp.panel.years=c("2016", "2017", "2019"),
		sgp.grade.sequences=list(c("7", "8", "10")))
)
