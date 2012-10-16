# Nick Johnson
# Assignment 9/12/12

# How many women were stopped?
length(which(data$sex == "F")) # 3927 total women
length(which((data$sex == "F") & (data$frisked == 1 | data$searched == 1 | data$arrested == 1)))  # 1215 total women stopped

# What percentage is this?
length(which((data$sex == "F") & (data$frisked == 1 | data$searched == 1 | data$arrested == 1))) / length(data$sex) # 0.02 percent

# how many different types of suspected crimes are there? Thoughts? Expected?
# Looking at the data it seems that each crime has multiple ways of being notated.  The notations 
# themselves also seem to lack any type cohesion.  It seems like there is no formal method of 
# notation for crimes suspected.
length(table(data$crime.suspected))

# Which precinct had the most stops? How many were there? Which precinct had the least stops?
max(table(data$precinct)) # precinct 47, 2597 stops
min(table(data$precinct)) # precinct 13

# How many people between 18 and 30 were stopped?
length(which(data$age > 18 & data$age < 30))  # 24,887 people

# Number of people given the full treament 
length(which(data$frisked == 1 & data$searched == 1 & data$arrested == 1))  # 1829 people

# Histogram of full treatment and ages
full_treatment_age = data[which(data$frisked == 1 & data$searched == 1 & data$arrested == 1), 8]
hist(table(full_treatment_age), breaks = length(table(full_treatment_age)), main = "Histogram of Full Treatment Ages", xlab = "Age")



############## Refugee Data from the UNHCR 1998 - 2010  #################

unhcr = read.csv("~/Downloads/UNdata_Export_20120906_073456020.csv", header=TRUE, as.is=TRUE)
head(unhcr)

# It is interesting to note that there are four columns containing information
# about refugees.  There is a column titled "Refugees", "Refugees assisted by UNHCR", 
# "Total refugees and people in refugee like situations" and "Total refugees and 
# people in refugee like situations assisted by UNHCR".  The most obvious question I 
# must ask is what is the difference between "refugee" and "refugee like situations" and 
# does the UNHCR aid these categories differently?


# View the number of entries by year
barplot(table(unhcr$Year))

# This graph is also very interesting.  Except for one year, the total number of entries 
# has steadily increased over the past ten years.  Maybe due to accumulation?

# Number of entries in 2010. There are 4,888 in 2010.
length(which(unhcr$Year == 2010))

# Number of entries in 2010 with only one refugee.  809 entries.
length(which(unhr$Refugees.sup....sup. == 1 & unhcr$Year == 2010))