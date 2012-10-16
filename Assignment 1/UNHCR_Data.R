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
