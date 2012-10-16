# Percentage of people who were frisked for each race
black = length(which(snf$race == 1))
blackHispanic = length(which(snf$race == 2))
whiteHispanic = length(which(snf$race == 3))
white = length(which(snf$race == 4))
asian_pacific_islander = length(which(snf$race == 5))
american_indian = length(which(snf$race == 6))

black / length(snf$race) # 0.52
blackHispanic / length(snf$race)  # 0.07400713
whiteHispanic / length(snf$race) # 0.2520098
white / length(snf$race)  #  0.08765859
asian_pacific_islander / length(snf$race) # 0.0331388
american_indian / length(snf$race) # 0.003597927

# Which race leads to the highest percentage of frisks? Which one the lowest?
# The distribution of stops against race is very unequal.  Black and hispanic 
# consume 75% of the stops.  Black is the hightest and american_indian is the lowest.


# Plot the number of times each crime occurs in descending order
barplot(sort((table(snf$crime.suspected))))

# What does this distribution of crimes look like? In other words, are there 
# an equal number of every kind of crime or are there a few that dominate?
# The distribution of these crimes is very hight for only a small number of crimes
# dispite the fact that there are so many different crimes.

# If we were to just look at stops where the crime.suspected was one of the 
# top 30 crimes, what percentage of the stops would that cover? Do you think that’s enough?
crime.suspected.30 = sort(table(snf$crime.suspected), decreasing=TRUE) # create a variable 
most.crime.suspected = crime.suspected.30[1:30] # look at only the first 30 in the variable
sum(most.crime.suspected) / length(snf$crime.suspected)  # percent of the top 30 crimes = 0.9132

# Create substring
crime.abbv = substr(snf$crime.suspected, 1, 3)

# Creating substrings for top 30 crimes
crime.abbv.30 = sort(table(crime.abbv), decreasing=TRUE)
crime.abbv.final = crime.abbv.30[1:30]
sum(crime.abbv.final) / length(snf$crime.suspected)  # total percentage of top 30 crimes = 0.9843

# Crime commited by race
race.black = snf[snf$race == 1, ]
race.black.hispanic = snf[snf$race == 2, ] 
race.white.hispanic = snf[snf$race == 3, ] 
race.white = snf[snf$race == 4, ] 
race.asian.pacific.islander = snf[snf$race == 5, ] 
race.american.indian = snf[snf$race == 6, ]

# Top three crimes black  =  FEL, MIS, CPW
race.black.crime.abbv = substr(race.black$crime.suspected,1,3)
sort(talbe(race.black.crime.abbv)) # summary of the crimes suspected race
top.crimes.black.ordered = rev(sort(table(race.black.crime.abbv)))
top.three.crimes.black = top.crimes.black.ordered[1:3]

# Top three crimes black hispanic  =  FEL, MIS, CPW
race.black.hispanic.crime.abbv = substr(race.black.hispanic$crime.suspected,1,3)
top.crimes.black.hispanic.ordered = rev(sort(table(race.black.hispanic.crime.abbv)))
top.three.crimes.black.hispanic = top.crimes.black.hispanic.ordered[1:3]

# Top three crimes white hispanic = FEL, MIS, CPW
race.white.hispanic.crime.abbv = substr(race.white.hispanic$crime.suspected,1,3)
top.crimes.white.hispanic.ordered = rev(sort(table(race.white.hispanic.crime.abbv)))
top.three.crimes.white.hispanic = top.crimes.white.hispanic.ordered[1:3]

# Top three crimes white = FEL, MIS, BUR
race.white.crime.abbv = substr(race.white$crime.suspected,1,3)
top.crimes.white.ordered = rev(sort(table(race.white.crime.abbv)))
top.three.crimes.white = top.crimes.white.ordered[1:3]

# Top three crimes asian pacific islander  = FEL, ROB, MIS
race.asian.pacific.islander.crime.abbv = substr(race.asian.pacific.islander$crime.suspected,1,3)
top.crimes.asian.pacific.islander.ordered = rev(sort(table(race.asian.pacific.islander.crime.abbv)))
top.three.crimes.asian.pacific.islander = top.crimes.asian.pacific.islander.ordered[1:3]

# Top three crimes american indian  =  FEL,ROB,GLA
race.american.indian.crime.abbv = substr(race.american.indian$crime.suspected,1,3)
top.crime.american.indian.ordered = rev(sort(table(race.american.indian.crime.abbv)))
top.three.crimes.american.indian = top.crimes.american.indian.ordered[1:3]


# Part Two
# Number of stops per hour
hour = substr(snf$time, 12, 13)
hour = as.numeric(hour)
stops.by.hour = table(hour)

# Max and min stops
which(stops.by.hour == min(stops.by.hour))  # 6am is the least
which(stops.by.hour == max(stops.by.hour))  # 8pm is the most

# Line Plot
plot(as.vector(stops.by.hour), type='1')

# Point plot with color for max and min
color.points = rep(1, 24)
color.points[7] = 3
color.points[21] = 2
plot(as.vector(stops.by.hour), type='p', col=color.points, xlab="Time", ylab="Number of Stops")


