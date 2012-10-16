data = read.csv("http://www.jakeporway.com/teaching/data/snf_11_2011_1.csv", header=TRUE, as.is=TRUE)
head(data)
women = length(which(data$sex == "F")) # number of women
women.frisked = length(which(data$sex == "F" & data$frisked == 1))  #number of women frisked
women.searched = length(which(data$sex == "F" & data$searched == 1))  # number of women searched
women.arrested = length(which(data$sex == "F" & data$arrested == 1))  # number of women arrested
women.stopped = sum(women.arrested, women.frisked, women.searched)   # total number of women stopped
women.stopped.draft = length(which((data$sex == "F") & (data$frisked == 1 | data$searched == 1 | data$arrested == 1)))
total.frisked = length(which(data$frisked == 1))
total.searched = length(which(data$searched == 1))
total.arrested = length(which(data$arrested == 1))

total.stopped = length(which(data$searched == 1 | data$frisked == 1 | data$arrested == 1))
#
#
total.not.stopped = length(which(data$searched == 0 & data$frisked == 0 & data$arrested == 0))  # anything that has no stops, frisks or arrests
