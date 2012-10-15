## LECTURE 5 ##
#
# Time series!
#
# Today we're going to look at one of the most common forms of data,
# time series.  Time series are really simply defined as (usually) a
# one dimensional value measured at different times.  That's it.
# So many things are time series - EKGs (heart electricity over time), 
# stock reports (stock values over time), weather, steps walked,
# and so on and so forth.  In fact, time is such a common dimension
# that, unless we're looking at a single snapshot of data, most data
# has some time component.
#
# There are two main things that we usually want to look at with time
# series data:
# 1)  Events that are "out of the ordinary" or "anomalous"
# 2)  Cycles, or so called "seasonality"

# Let's explore this through some time series
# data of our own.  We have two datasets
# with time in them now, NYPD stops and Twitter
# data.  Let's stick with NYPD data for
# this lesson.  
#snf <- read.csv("http://jakeporway.com/teaching/data/snf_2.csv", as.is=TRUE)
snf <- read.csv("~/teaching/ITP 2012/data/nypd_nyclu/snf_2.csv", as.is=TRUE)

# I'd be curious to know if there were any
# "unusual" moments in terms of number of stops,
# e.g. sudden spikes or dips in stops.
# Let's make today's goal to answer the question:
# "When were there an 'unusually' high or low
#  number of stops?"

# Let's start by visualizing stops over time.
# We've done this by day of week, day of month,
# and hour of day before, but let's get more
# granular and see if we can do it, say, every
# hour of the month.  Unfortunately our time variable
# is in this weird text form so it's tough
# to work with.  If we could convert each time
# into a number (say number of seconds since
# 1970) then we could build a histogram of times.

# == TIMES IN R ==
# Good news, we can do exactly that!  There are
# two special classes in R, POSIXlt and POSIXct,
# that handle date/time objects.  We can use
# as.POSIXlt to convert time strings into time objects.
times <- as.POSIXlt(snf$time)
head(times)

# Hmm, they look the same, but secretly deep down inside
# these are time objects.  It just so happens
# that converting as.POSIXlt to a numeric automatically
# coerces that time value into seconds since 1/1/1970
# (see last lecture's UNIX timestamp discussion if that
# seems weird)
seconds <- as.numeric(times)
head(seconds)

# Oh!  We did it!  Each stop is now expressed by when it happened
# down to the second.  OK, let's look at a histogram of
# stops over time:
hist(seconds, breaks=400)

# Ooo, aah.  What do we see here?  

# OK, if our goal is to find 'unusual' times, we need
# to figure out what 'unusual' means.  Does it just mean
# when there are a high number of stops?  Or when
# there are an unexpectedly high (or low) number of stops?  Hmm...

# In order to answer that question, we have a 
# more basic problem - how do we get at the histogram data?
# We typed hist() and a cool plot showed up, but can we read
# back the bins R created?  Or the number of counts in each bin?

# == LISTS IN R ==
# R will often silently return things that, if you don't 
# ask for them, you won't see.  hist() is one such function
# that returns something, but only if you ask for it:
h <- hist(seconds, breaks=400)

# So what's in h?  We can see by using the names() function,
# the same function we use to read the column names of
# data frames, to find out.
names(h)

# What we just got back is a listing of the different elements of
# the histogram object.  Histogram objects are a special
# version of an R object called a "list".  A list is 
# an object consisting of sub-elements that are referenced by name,
# much like an associative array.  Unlike data frames, which
# dictate that every column have the same type and number of elements,
# elements of a list can be any size and of any type.  Elements
# of a list are referenced primarily with the $ sign:
ninja.turtles <- list() # Declare an empty list
ninja.turtles$num <- 4
ninja.turtles$names <- c("michaelangelo", "leonardo", "donatello", "raphael")
ninja.turtles$catchphrase <- "Heroes in a half-shell"
ninja.turtles

# So let's look at two important elements of a histogram, the
# counts and the breaks:
h$breaks

# h$breaks are the breakpoints R decide on, and

h$counts

# h$counts are the number of points in each bin.  These are aligned,
# as you might imagine.

# If you plot h$counts...
plot(h$counts, type='l')

# you'll see our histogram all lineplotted out.  Great!

# == AN ASIDE, FUNCTIONS == 
# In class we took an aside to talk about how
# to automate things you may do many times over,
# in other words, how to write our own functions.
# Let's say we're getting sick of writing head(rev(sort(table(x))))
# over and over again.  Let's write a function called
# topN that does the same thing:
topN <- function(data) { 
  head(rev(sort(table(data))))
}

# And that's it!
topN(snf$crime.suspected)

# == ANOTHER ASIDE, INTERACTIVE GRAPHICS ==
# We also saw the locator() function in class.  locator()
# will record the points you click on a plot until you hit
# ESC
locator() # click, hit ESC

# This can be really useful for narrowing in on areas of graphs you're
# analyzing.
# == ANOMALIES ==
# How can we define an anomaly?  We could start merely by 
# saying that any moment with > 300 stops is "abnormal".  Let's
# mark those days on the plot.  There's a function abline()
# that adds straight lines to plots.  abline(v=...) will 
# add vertical lines at certain points, like at observation 100:
abline(v=100, col=2)

# or multiple places, like observations 20 and 220:
abline(v=c(20, 220), col=3)

# So, let's use logical operators to mark off any bin that
# had more than 300 stops:
plot(h$counts, type='l')
abline(v=which(h$counts > 300), col=2)

# Hmm, those are the peaks with stops > 300 all right, but
# are they really "abnormal"?  It looks like they happen
# every 4 days or so.  Maybe that's what's supposed to happen?
#
# This is the dead simplest version of event detection in
# time series - yell if something gets higher than some value - 
# but it doesn't do much sophisticated.  What if it's
# OK that something's high sometimes but not others?
# What if there are lower
# values that are out of the ordinary, but are too low to 
# trigger the threshold?

# To really look at "abnormal", we need to talk about what's
# normal.  And to do that, we have to talk about time series:
#
# Time series consist of:
# 1.  A trend
trend <- seq(1, 100, by=0.30)
n <- length(trend)

par(mfrow=c(4,1))
plot(trend, type='l', main="Trend")

# 2.  A noise or "random" component
random <- runif(n)*4 - 2
random[100] <- 30
plot(random, type='l', main="Random")

# 3.  And a (optional) seasonal component
seasonal <- 10*sin(seq(0, 48*pi, length.out=n))
plot(seasonal, type='l', main="Seasonal")

plot(trend+random+seasonal, type='l', main="Signal")
par(mfrow=c(1,1))

# So we want to go the other way - given
# a signal, can we find the "random" or "trend"
# parts?  If there's a cycle we may have to
# remove the trend.
# (If you want to come back after this lesson
# and see how well R recovers these components
# using what we've learned):
# z <- trend+random+seasonal
# a <- acf(z, lag.max=100)
# rev(order(a$acf))
# d <- decompose(ts(z, frequency = 14))

# Let's try to remove the seasonal trend from our time series
# to see if it makes it any easier to find anomalous days.
# To do that, we need to convert our histogram counts into a
# time series object.  That's done easily enough with the ts()
# command, which coerces vectors of numbers into time series objects.
# Having our data in a time series object means R can do fun stuff
# with it.

# The only downside is that we need to give R a "frequency" for
# our time series, which tells R how many observations in our time
# series make up a "unit".  Looking at this graph, I'd
# say that we see a blip every day, so our unit should be a day,
# and so the frequency is the number of points in our time series:
length(h$counts) #520

# divided by the number of days in November
520/30

# So we'd set the frequency to 17.33333 (there are about 17.3333
# points between peaks, is what that's saying
stops <- ts(h$counts, frequency=17.333333)

# You won't see much change yet, except that plotting stops
# shows the x-axis in terms of days now.
# So why should we care that we have this data as a time series
# object, maybe because we can do THIS:
parts <- decompose(stops)
plot(parts)

# WHOA!  decompose() broke our one signal into estimates
# of its three components - trend, random, and seasonal.  Hah!
# So we could remove the seasonal component from our model, and 
# maybe that would let us see where the real "weird" spikes are:
plot(stops - parts$seasonal)

# Um, maybe not.  What is this exactly?  This is our stops
# over time adjusted for the daily effect.  It's not bad, but
# both this plot and the previous plot are still super cyclic
# looking.  This makes me think that there's a BIGGER cyclic
# effect (what could that be?)

# Now, we could go figure out what the frequency would be for a week,
# but I hear you asking, "what if our data doesn't line up nicely
# with days of the month?  How can we estimate the cycle length
# (basically the "frequency" parameter in ts()) from the data?

# Great question, and the answer is something called "autocorrelation".
# Autocorrelation will tell you if there are cycles in your data
# by slapping the signal on top of itself and sliding it over,
# point by point, to see how well it matches up.  The idea is,
# if the difference between the signal and its shifted self
# is ever small, then there's high autocorrelation for that
# shift because it means shifting the signal over that far
# lines it back up with itself.  Let's look at an example:

# Here's a super cyclic set of data:
x <- sin(seq(0, 12*pi, 0.1))
plot(x, type='l')
acf(x, lag.max=100) #autocorrelation

# So what is acf telling us?  Each point represents a lag
# of the signal by a certain amount and how well that lagged
# version of the signal overlaps the original.  We can see
# that at a lag of 0 (the signal right on top of itself) has
# an autocorrelation of 1, as it should (the signal on top of
# itself should be a perfect match).  

# As we shift the signal more and more, the correlation goes down,
# meaning the signal matches less well.  As it turns negative,
# it means the signal is actually opposite itself.  Around
# 60 we see the acf peak again, which means that somewhere
# around a lag of 60, the cycle repeats again.  Let's first
# figure out where the peak near 60 is.

# We can do this by first grabbing the results of the acf function,
# just like we did with hist():
a <- acf(x, lag.max=100)#
names(a)

# The $acf element holds the autocorrelation values for each
# lag.  We want to find the max values of act (ignoring the first few),
# because that's where the signal overlaps itself.

# There's a function called order(), which returns the rank
# order of each element in a vector.  Think of it as returning
# which "place" each element would be in.  For example:

x <- c(5, 7, 4)
order(x)

# Tells us the first element is third biggest, the third element
# second biggest, and the second element the first biggest.

# We can use order() to find the lag values for which the signal
# most overlaps itself:
rev(order(a$acf)) # we reverse the order so it goes largest --> smallest

# The first few values (1 - 6) are just because the signal
# still aligns pretty well with itself.  After that, though,
# we see that the 64th element is that second peak.  Cool.  
# If we want to see exactly what lag that corresponds to, we'd
# do
a$lag[64] #63

# Just for comparison, what does a non-cyclic signal look like
# if we call acf on it?
x <- runif(300) # 300 random points
plot(x, type='l')
acf(x)

# See how no lag values go above those two dotted blue lines (except
# lag 0, that is)?  That means that no lag amount creates enough
# overlap to be considered evidence of a cycle, just as we'd
# expect.

# So back to our problem, let's look at the acf for our stops:
a <- acf(stops, lag.max=200)

# Oo, so this is an interesting graph!  What do you see?

# OK, I'll give it away:  The initial spike at 0 is the lag 0
# spike we always get.  The next big positive spike seems to
# be around the 1 day mark, meaning there's a strong daily cycle
# affect.  The positive peaks keep going down until they start
# to come back up right into, that's right, day 7!  The next
# biggest peak after the day peak at 1 is at 7!  Let's track down
# where that is using our order() trick:
rev(order(a$acf))

# 1 2 18 19 3 122 17 123

# 1 and 2 are the lag 0 spike, 18 and 19 are the day effect,
# then 3 is close to lag 0 and then 122 and 123 are the week effect!
# Note that if we didn't know what frequency to put into ts()
# in the first part of the work (we estimated it as 550/30 = 17.333),
# we would have seen here that the 18th and 19th lag values (which
# are 17 and 18 respectively) would have been very close to 17.333.
# Similarly the 122nd and 123rd values are 121 and 122, respectively,
# which are very close to the number of observations per week
# we would have gotten by hand (7*17.333 = 121.333).

# Confused yet?  Good!  We basically just found that we see
# daily cycles every 17 observations and weekly cycles every 121
# observations.  We did all this so that we could tell R that
# our time series object has frequency 121 (a week) so we could
# try to decompose the signal better:
stops <- ts(h$counts, frequency=121)
parts <- decompose(stops)
plot(parts)

# Hey, now we're talking!  The trend line has no apparent seasonality
# left in it (and we see an interesting dip from the beginning of
# the month to the end which, to me, wasn't obvious) and all the
# "cool" stuff has been shunted off to the random part of the
# signal.  Let's look at our signal with just seasonality removed:

no.season <- stops - parts$seasonal
plot(no.season, type='l')

# Now we get a slightly clearer picture of where the "abnormal"
# days are.  Looking at stops > 200 with the seasonality removed
# looks like it would make a little more sense:
#
# (P.S. - One little annoyance:  R will plot time series based
# on the frequency we gave it, so note our x-axis is in "week units".
# Annoying.  To plot a line we can't just put in the index of the points in
# straight up, we have to divide by the frequency (to get to "week
# units") then add 1 (because it starts with week 1, not week 0))
# abline(v=which(no.season>200), col=2)  # Won't plot right - not in "week units"
abline(v=(which(no.season>200)/121)+1, col=2)

# And heck, let's also flag moments when there were fewer than 50
abline(v=(c(which(no.season>200), which(no.season<40))/121)+1, col=2)


# So if we had a machine learning algorithm reading in stops over time,
# it could use these methods to alert us when stops spiked or dropped.
# We removed seasonality, which allowed us to use simple thresholding
# to find things that are "unusual".  There are a few last things we
# can do as well.

# Sometimes you don't want to alert on the total number of things,
# but how quickly the number of things is changing.  In other words,
# maybe it's not the number of stops we care about, but the sudden
# in/decrease in the number of stops (aka velocity).  We can
# look at that with the diff() function, which subtracts neighboring
# values in a vector:

velocity <- diff(no.season)
par(mfrow=c(2,1))
plot(no.season, type='l', main="Non-seasonal Stops")
plot(velocity, type='l', main="Velocity")

# Hmm, that second plot isn't very informative (to me).  That's
# because even though we perceive some clear spikes in the signal,
# a close-up...
plot(no.season[100:200], type='l')

# ...shows that are peaks are made up of lots of little crags,
# so we don't see a clear spike up or down, just lots of little
# slow moving changes.  We can alleviate some of this by
# smoothing out the signal, but how would we do that?

# == LIBRARIES IN R ==
# Like all good programming languages, R foregoes solving every
# problem on its own in exchange for a library system.  Libraries
# are collections of code for specific tasks that we can load into
# R to extend its capabilities.  The R community is super active
# so there's a library for almost anything you could want to do.

# There's a package for timeseries called TTR that will help
# us smooth this signal.  First, we need to install it:
install.packages("TTR")
# (we only need to do this once on this computer.  Once it's installed
# you can just load it from now on.)

# Then load it into R
library(TTR)

# The function SMA() smooths a signal using a technique
# called a "moving average", in which windows of points
# are averaged together.  The smoothness is based on a parameter "n".
# The higher n is, the smoother the signal gets:
smoothed <- SMA(no.season, n=10)
velocity <- diff(smoothed)
par(mfrow=c(2,1))
plot(smoothed, type='l', main="Non-seasonal Stops")
plot(velocity, type='l', main="Velocity")

# Now we can see some clear peaks and valleys and our velocity
# makes a little more sense.  We see that the second peak
# is perhaps most interesting because it's most clearly marked
# by a sudden increase in stops and then a sudden decrease, whereas
# the other peaks rise and fall more gradually.

# So there you have it - time series!  There's a bit more you
# can do with these things (e.g. more sophisticated event modeling)
# but those functions are the main things you'll need to get going
# to look at time-varying data.  Enjoy!