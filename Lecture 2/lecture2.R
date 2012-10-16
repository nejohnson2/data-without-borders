### LECTURE 2 ###

# Welcome back to R!  This class we'll:
# - Review your homework
# - Talk more about vectors vs. data frames
# - Talk about indexing and subsetting
# - Go over classes
# - Plot some stuff

# Hey, let's use a new dataset.  It's almost
# identical to last week's, except:
# -  Categorical variables (like race) have been
#    replaced by numbers (codes explained
#    at http://jakeporway.com/teaching/resources/SNF_codes.pdf)
# -  It has some new variables
#
# Let's load it up!
snf <- read.csv("http://jakeporway.com/teaching/data/snf_2.csv", as.is=TRUE)


# First up, the "+" sign.  You've probably
# seen that in RStudio, as in
head(snf
# plus sign!
     
)     
# That just means R is waiting for more input.  You can either close
# your missing parentheses or hit "Esc" to back out.

# === VECTORS vs. DATA FRAMES ===
# To review, 
# - vectors:  1D collections of variables of the same type
# - data frames:  2D collections of columns.  Columns can be of different types
#   but within a column all variables must be the same.

# dim() is dimensions for data frames, length() is just for vectors (length() of
# a data frame returns the number of columns, which probably isn't what you expect.
dim(snf)

# The $ sign is used to pull columns out of data frames as vectors
ages <- snf$age # vector
length(ages)

# Data frames are easy to make
x <- data.frame(1:10, 101:110, letters[1:10])

mini.subset <- data.frame(snf$age, snf$time) 
# you would never do it this way, you’d use
# subsetting

# Vectors are even easier:
x <- c(1, 2, 5, 6, 10)

# === TABLES VS DATA FRAMES ===

# There was some confusion about this in the homework. 
# table() is a function that counts the number of times each value appears 
# in a vector. 

table(snf$race)

# The result is technically a special object called a "table", which is 
# basically a vector with names.  However, you can think of it as just
# a vector of counts.

# Data frames, however, are 2D data representations.  
# We can create them with the data.frame() function as above.

# === INDEXING ===
# Indexing is one of the *coolest* things about R!  We're data sleuths, so 
# we want to be able to pull stuff out of R super quickly.  This means
# we'll want to reference rows of data frames, either by number of by
# logical expression:

snf$age[1:10] # The ages of the first 10 stops
snf[c(1, 5, 1000),] # Rows 1, 5, and 1000 from snf

# Note that vectors just take square brackets with one argument, e.g. snf$age[10]
# Data frames expect arguments for rows AND columns, e.g. snf$age[1, 1].  If you
# omit one, it assumes you want all of that dimension, but you've got to use the comma
# or you'll get this error:
snf[snf$age < 30] # I think I'm going to get all stops with person under 30, but nope

# You actually mean
snf[snf$age < 30,]

# OK, so how can we specify rows from data frames we want to pull?
# By number:
snf[c(1, 5, 1000),]

# OR BY LOGICAL EXPRESSION!  This is super useful / necessary!
snf[snf$age < 30,]

# And really, what is snf$age < 30?
x <- snf$age < 30
x[1:10]

# Hah, it's TRUE/FALSE values.  We can get the indices of the TRUE values with which()
which(snf$age < 30)

# And by using square brackets, we can subset the data based on either logical 
# vectors or numerical vectors:
  
snf[snf$age < 30,] 
snf[which(snf$age < 30), ] # Totally the same thing!

#OK, but here’s where things get fun - a lot of times we want to know 
# the number of times something’s true (e.g. number of times men are arrested,
# number of people under 30 who were stopped, etc.)  There are two major ways 
# to do this:
  
under.30 <- snf[snf$age < 30,] # Subset of people < 30 stopped
nrow(under.30)  # Because we subset, the number of people under 30 is the number of rows
# OR
sum(snf$age < 30)  # Whuuuu?

# What is R doing here?

# snf$age < 30 is a logical vector.  Cool.
snf$age < 30

# sum() adds up all the elements in a vector.  OK...
# Because you’re passing a vector of logicals into a function that adds numbers, 
# R thinks “Hmm, OK, I need to convert this to a number”.  It converts every 
# TRUE to 1, every FALSE to 0.  Then it adds ‘em up.  Taking the sum() of a 
# logical vector gives you the number of TRUE values.

# So this raises the question of when to use sum() and when to use length() for
# determining how many of something is "true":
# - length() will give you the length() of a vector,
#    so you want to use it when your vector is a subset of the data, 
#     e.g. snf$age[snf$age < 30] or which(snf$age < 30)

# - sum() will actually sum numbers up, but we can abuse it a little to take sums
# of logical vectors, i.e. all the TRUE values.  e.g. sum(snf$age < 30)

# === CLASSES IN R ===
# R has basic classes:  numerics (including integers and doubles),
# characters, logicals, and then some fun stuff we’ll talk about later. 
# You can check the class of an object with the class() function:
  
x <- 3
class(x)
#“numeric”

x <- "jake"
class(x)
#“character”

#You can convert between classes with “as.”, e.g. as.integer() or as.character():
x <- 3
as.character(x)
#“3”

as.integer(snf$age < 30)

# Hah!  Now we see what it looks like when R converts logicals to numbers

#OK, back to subsetting.  Just like Processing, R has logical operators 
# (AND, OR, NOT) and comparators (<, >, <=, >=, ==):
  
snf[snf$age < 30 & snf$frisked == 1,]  # Which people under 30 got frisked?
snf[snf$precinct == 24 | !snf$arrested,] # anyone from precinct 24 or not arrested

# R uses a single '&' for AND and a single '|' for OR when combining logical vectors
# So we can now pull rows using all sorts of complicated boolean logic.  Neat!
    
# === VECTORIZATION ===
# Ok, this is really neat:
#If you type:
sqrt(36)

#You get the square root of 36.  That's cool.
#If you type:
sqrt(snf$age)

#You get back a vector of all the square roots of every age.  
#This is kind of neat - give an R function a vector and it'll 
#apply that function to each element of the vector and return the result.  
# This is because R tries to "vectorize" as much as it can, i.e. apply 
# functions over entire vectors (when it makes sense).

#Wanna see some other cool vectorizations?

x <- runif(10) # runif() gives you as many (r)andom (unif)orm numbers     
              # from 0 to 1 as you specify
round(x)       # round each element of x

tolower(snf$crime.suspected)[1:10] 
# note how we can chain subsetting with functions

# Wanna see another cool side effect of vectorizing?
# What does this do?

x <- 1:10
x + 3

# Ho!  Vectorizes the addition by 3!  OK, hotshot, what about this?

y <- 1:3
x + y

# ZOMG.  R recycled the smaller of the two vectors to match the 
# length of the longer vector.   R needs vectors to be the same 
# length to do most operations on them together, so it will 
# stretch one to match the other.  Be aware of this!  This will also
# cause you headaches when you accidentally operate on two vectors
# that you *think* are the same length but aren't, because R won't throw
# an error, it'll just recycle the vectors and merrily move along.

# Somewhat related to this, we can form crazy sequences using some
# fun R functions, rep() and seq()
one.to.ten <- 1:10
one.to.ten <- seq(1, 10)
who.do.we.appreciate <- seq(2, 8, 2)
we.love.R <- rep("R!", 10)
waltz <- rep(seq(1, 3), 4)

# fancy!  A *lot* going on in here
ranks <- rep(c(2:10, c("J", "Q", "K", "A")), 4)
suits <- rep(c("C","H","S","D"), each=13)
paste(ranks, suits,sep="") # look this function up

# OK, now on to the day!
# === EXPLORATORY DATA ANALYSIS ===
#
# What we've been doing in Lecture 1 and 2 (and will do a bit longer) is called
# Exploratory Data Analysis.  It's the art of describing data, visualizing it,
# and understanding the nature of our data before jumping into super crazy math.
# John Tukey, a statistician at Bell Labs, coined this term and believed very
# strongly that simple plots and analyses should be used to spot outliers
# and understand process before one jumps into hardcore stats.  In that
# spirit, let's look at one of the keys of EDA, plotting.

# We just saw last class that we could throw thing at plot()
# and stuff would appear.  Let’s get serious about what plot() can do:
#Basics:  plot(x, y)

plot(1:100, runif(100)) # What should this do?

#You can throw other things at plot and it’ll try to figure out what you want:
plot(table(snf$precinct))

#There are lots of parameters that plot() can take to change the appearance
# of the figure.  Here are some of the big ones:
# type:  The style of plot - lines, points, bars.  
# xlab:  The x-axis label
# ylab:  The y-axis label
# main:  The main title
# col:  The color of the points.  R has a set of 8 preset colors
# you can use (col=2 is red, for example) or you can specify fancy
# colors (we'll see this later)

# Oddly, help for these parameters shows up under par(), which sets the 
# graphical parameters for plots.

plot(table(snf$day), type='l', xlab="Day", ylab="Stops", main="Stops over November")

# We can also overlay plots with the points() and lines() commands:
men.stops <- as.vector(table(snf$day[snf$sex == "M"]))
women.stops <- as.vector(table(snf$day[snf$sex == "F"]))
plot(men.stops, pch=17, col=3, cex=1.5, xlab="Day", ylab="Stops", main="Men vs. Women Stopped by Day")
points(women.stops, pch=10, col=6, cex=0.8)

# Hmm, where are the ladies?  points() didn’t adjust the x and y...
# We need to use the ylim() parameters to specify our y axis limits:
max(men.stops)
plot(men.stops, pch=17, col=3, cex=1.5, xlab="Day", ylab="Stops", main="Men vs. Women Stopped by Day", ylim=c(0, 2500))
points(women.stops, pch=10, col=6, cex=0.8)

# Another way to show similar information:  par(mfrow=c(a, b)) creates
# a grid of "a" rows and "b" columns.  Every time you plot it'll draw to
# the next one.
par(mfrow=c(1, 2))
plot(men.stops, pch=17, col=3, cex=1.5, xlab="Day", ylab="Stops", main="Men Stopped by Day", ylim=c(0, 2500))
plot(women.stops, pch=10, col=6, cex=0.8, xlab="Day", ylab="Stops", main="Women Stopped by Day", ylim=c(0, 2500))
par(mfrow=c(1, 1))

# Fun stuff:  Just like R will vectorize most things, it’ll vectorize 
# arguments to plot().  In particular, the color parameter is the most important.
# Let’s say we want to look at # of stops on a certain weekdays relative to the rest of the month.  First, let’s make a data frame of counts by day.  This is surprisingly easy to do:

stops.by.day <- data.frame(table(snf$day)) # Note how we're making a data frame out of the table

# Hey, side note, why are the column names in our data frame crazy? 
# By default, data.frame() assigns column names based on what it thinks 
# is in there.  We can assign the column names like this:
  
names(stops.by.day) <- c("day", "stops")

# WHOA.  Did you see we just assigned values to
# the result of a function?? R is awesome!  We'll see more of this when
# we replace values in R next class (or soon).  

#OK, plotting this will give us our familiar graph:
plot(stops.by.day$stops)

# We can color it all one other color...
plot(stops.by.day$stops, col=4)

# ...but can we color each day of the week differently? Well, let’s create a 
# vector of colors for each day of the week.
days <- as.integer(stops.by.day$day) %% 7

# %% is modulo (seen this before?)
# I’ll explain why we’re doing as.integer() here next  
# time (try it without and see what you get)

# If we use this vector as the color argument, R will color 
# each point accordingly!  Sweet!
plot(stops.by.day$stops, col=days)

#Wait, huh?  Some of our points disappeared!  Why?
# Turns out that col = 0 prints nothing, so any day 
# divisible by 7 is zero.  Let’s just remedy this by 
# bumping all of our colors up by 1:
plot(stops.by.day$stops, col=days+1)  # Ahh, better!

# And, oh man, there are lots of other plots in R:

# DOTCHARTS
# What are the top 10 crimes?
crimes <- rev(sort(table(snf$crime.suspected)))
top.crimes <- crimes[1:10]
dotchart(rev(top.crimes))

# BOXPLOTS (Tukey's invention!)
men.ages <- snf$age[snf$sex == "M"]
women.ages <- snf$age[snf$sex == "F"]
boxplot(men.ages[men.ages < 80], women.ages[women.ages < 80], names=c("Men", "Women"))

# BARPLOTS (We saw these last time)
barplot(table(snf$race))

# So help me god, if you use a pie chart...
pie(c(0.6, 0.3, 0.1), labels=c("Don't", "Use", "Piecharts"))

# One of the most important plot are histograms (density plots)

random.normal <- rnorm(1000)  # 1000 values from a bell curve (normal distribution)
head(random.normal)
hist(random.normal, freq=F)    # freq determines whether 
                               # we want percentages or                                  
                               # raw counts 
lines(density(random.normal))  # we saw points() 
                               # overlays points.  lines()
                               # overlays lines

random.uniform <- runif(1000)
head(random.uniform)
hist(random.uniform, freq=F)
lines(density(random.uniform))

# Cool, histograms show densities of lots of numbers.  Great.  
# One of the most important things about histograms is that the BIN SIZE
# IS SUPER IMPORTANT!!!!
# Compare these graphs:
weights <- snf$weight[snf$weight < 400] #Weights of everyone stopped under 400 lbs
hist(weights, breaks=10)
hist(weights, breaks=50)
hist(weights, breaks=150)

# Whoa, notice any difference??

# You can also plot stuff in 2D, which is great.  Let's see people's heights
# vs. weight:
plot(snf$height, snf$weight)

# === CONCLUSIONS ===
# Hmm, what did we do today?  It didn't feel like it was all that cohesive, right?
# Just a lot of subsetting and plotting stuff?  Well fear not, you're actually
# learning how to be a data scientist!  Think about what you can do now:  you
# can query R for almost ANYTHING YOU WANT TO KNOW!!  That's crazy!  You
# can basically use R as a database (give me a subset of all of the people under
# 30 who weighed between 80 and 100 lbs and then make a barplot of their races).
# That's really crazy.  Now it would be one thing just to be able to pull those
# rows out, but you can VISUALIZE them too!  In all sorts of neat ways!  With
# just a line or two of code!  Bonkers!
#
# Notice as you go through this course how much flexibility you have with R.
# Sure, things like plot() are built-in functions, but you can customize them
# and control almost any aspect of the end result.  R is exceedingly powerful
# and we'll see how you can even create your own custom functions soon.
#
# In short, you're well on your way to being a data detective and we'll see
# next class how to deal with querying, organizing, and subsetting data in
# some other interesting ways.

