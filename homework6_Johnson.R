# Time Series
# Homework for week 6

tweets = read.csv("http://jakeporway.com/teaching/data/tweets2009.csv", header=FALSE, as.is=TRUE)
names(tweets) = c("time", "seconds", "screen_name", "text")

time = (max(tweets$seconds) - min(tweets$seconds))
time/60 # 5549.35 minutes, 92.48917 hours

hist(tweets$seconds, breaks=500)
counts = hist(tweets$seconds, breaks=500) # use the output of hist to show amout of tweets per second?
plot(counts$counts, type="l")

# there is an initial spike in the number of counts and then there seems to be a cyclical decline
# in tweets.  There is also a smililar looking spike at the very end of the data set.

# find the correlation 
# Where is it most likely that we have a cycle and how can you tell?
a = acf(counts$counts, lag.max=200)

# After looking at the acf() function, there seems to be a second peak between the 150 and 200 markers.  By
# using the rev(order(a$acf)) function, I was able to look at the max peak values and the highest value after
# the initial values was 179.  This I deduced to be the cycle frequency.

# OK, let’s remove the cycles and analyze this data. Create an official timeseries 
# object with frequency equal to the cycle length. Use decompose() to decompose the timeseries 
# into its components and plot the results. What do you see in terms of an overall trend?

# frequency comes from the acf function and seem to have 3 cycles.
ts = ts(counts$counts, frequncy=179)
parts = decompose(ts)
plot(parts)

# After decomposing the ts() function, the trend seems to start very high and then slowly go down over time.  It does
# also appear to be rising towards the very end but only slightly.  This could be a sign of a much larger cycle.
# Not enough data to report on this other cycle.

# Exercise Two
iran.tweets <- tweets[grep(“iran”, ignore.case=TRUE, tweets$text), ]

iran.counts = hist(iran.tweets$seconds, breaks=100)
plot(iran.counts$counts, type='l')
abline(v=57,col=2)
abline(v=58, col=2)
abline(v=64, col=2)

plot(SMA(iran.counts$counts), type='l')
plot(diff(SMA(iran.counts$counts), lag=5), type='l')

# The diff() function shows a large dip between the two main peaks.  The line graphs look completely different.

iran.counts.total = SMA(iran.counts$counts)
iran.counts.total.wona = iran.counts.total[10:66]

# seems like the most change in tweets is from bin 30 to 40



