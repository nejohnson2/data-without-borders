# Time Series
# Homework for week 6

tweets = read.csv("http://jakeporway.com/teaching/data/tweets2009.csv", header=FALSE, as.is=TRUE)
names(tweets) = c("time", "seconds", "screen_name", "text")

counts = hist(tweets$seconds)
plot(counts$counts, type="l")
