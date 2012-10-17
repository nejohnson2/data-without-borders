## LECTURE 7 (and some of 8) ## 

# HW3 Review
# There was a pesky question about finding the most popular words.  
# Letâ€™s walk through this:

# Assuming we've got our data in a data frame called tweets, 
# letâ€™s first pull out all the words from all the tweets using strsplit()
tweets <- read.csv("http://jakeporway.com/teaching/data/libya_tweets.csv", as.is=TRUE, header=TRUE)
words <- tolower(unlist(strsplit(tweets$text, " ")))

# The result of this function is a list.  R
# emember we talked about lists a bit before?  
# Letâ€™s take a second to explore them in more detail.

# So far weâ€™ve seen all of our data in data frames, where each column 
# has the same number of rows.  Itâ€™s nice and rectangular and easy.  

# Unfortunately not everything fits into a rectangle, so we need something
# like lists, which can also deal with generic key-value objects:
craig <- list(name="Craig", year="Sophomore", 
              grades=c(75, 97, 81))

emily <- list(name="Emily", year="Senior", 
              grades=c(81, 86, 90, 93), 
              honors="magna cum laude")

craig$name
emily$grades
craig[[2]]
emily[["year"]]

# Lists are great for structured, non-tabular objects (R does have its own
# object data type, but letâ€™s ignore that for now).

# Often times weâ€™ll see lists of lists thrown together:
students <- list(craig, emily)

students[[1]]
students[[2]][["name"]]
students[[2]]$name
students[[2]][[1]]

# Lists are a little funky because you can reference their elements multiple ways:

#$:  You can use the $ sign to reference named entities:
craig$name

#[[ ]]:  Double quotes get you the element at a certain location.  This returns the actual value
craig[[2]]

#[ ]:  You can return a subset of the list, which is, itself, a list
students[1:2]

# strsplit() must be a list because it returns a vector of words in each tweet,
# and each vector could have a different length.
lyrics <- c("sing us a song", "we didn't start the fire")
strsplit(lyrics, " ")

# As you guys saw, counting up those words creates a lot of annoying counts 
# of words like â€œtheâ€ and â€œofâ€.  I had you guys download a list of stopwords 
# so we could remove those first:
stopwords <- read.csv("http://jmlr.csail.mit.edu/papers/volume5/lewis04a/a11-smart-stop-list/english.stop", as.is=TRUE)

# ANNOYING THING:
# stopwords looks like itâ€™s one list of words, but itâ€™s actually a
# data frame with one column.  We want just the vector of words,
# so we need to pull that out of the first column likeso:
stopwords <- tolower(stopwords[, 1]) # Just take the 
# first, and only column
stopwords <- c(stopwords, "", "a", "-", "rt", "...")

#a %in% b returns which elements from a appear in b:
stopwords.index <- words %in% stopwords

# So that gets us a TRUE/FALSE vector of which words are stopwords.  \
# How do we remove them? Take the inverse!
goodwords <- words[!stopwords.index]

#Boom, now weâ€™re good to go:
head(rev(sort(table(goodwords))))

# HW6 Tip:
# We saw that just looking at absolute numbers in a timeseries is *not* 
# a good way to find â€œspikesâ€.

#One solution is to look not at volume, but â€œvelocityâ€, i.e. the 
# difference between neighboring times.

#The easiest way to do that in R:  diff()

x <- c(1, 3, 5, 10)
diff(x) #2, 2, 5  <-- differences between neighboring values

# diff() also takes an argument called â€œlagâ€ which determines
# how far apart you measure your differences.  You should use that in HW6 :)

## New Data!  bit.ly!
clicks <- read.csv("http://jakeporway.com/teaching/data/bitly.csv", as.is=TRUE, header=TRUE)

#As with all new datasets, we should do some basic exploration here:

#What are the distributions of article clicks?
head(rev(sort(table(clicks$url))))

#When were there spikes in activity, if any?
hist(clicks$seconds, breaks=500)

#How many unique user agents are there? 
length(unique(clicks$agent))

# Things like that, you know?  Go check â€˜em out.

#So where are our users?
## The maps library!
library(maps)  # You may have to install this first
map("world")

# Wow, that was easy.
map("world", mar=c(0,0,0,0))
map.axes()

points(clicks$lon, clicks$lat, col=2, pch=19, cex=0.8)

# More specific
map("state", "California", mar=c(0,0,0,0))
points(lon, lat, col=2, pch=19, cex=0.8)

# Map has a bunch of built in shape databases for countries, states, and counties.

# Yeah but everythingâ€™s all mushed on top of itself and hard to read.  
# Can we see densities more easily?

# Forget â€œcol=2â€, letâ€™s get serious.  We can use the rgb(r, g, b) function
# to set our colors.  To do a slightly gentler red, we could use 
# col=rgb(200, 0, 0, maxColorVal=255).  
# ANNOYING THING:
# Itâ€™d be great if rgb(200, 0, 0) worked, but rgb() actually expects 
# color values between 0 and 1 unless you tell it otherwise, with maxColorVal=255

# But what's doubly cool, is that rgb() is actually rgb(r, g, b, a), so we can
# specify alpha (transparency) to make this easier to read densities:
map("state", "California", mar=c(0,0,0,0))
points(lon, lat, col=rgb(200, 0, 0, 30, maxColorVal=255), pch=19, cex=0.8)

# Data rep people:  How should we represent clicks over time? 

n <- clicks$seconds - min(clicks$seconds)
nn <- n / max(n)
#Gives us a 0 - 1 value for when a click happened, so we can do this:
map("world", mar=c(0,0,0,0))
points(lon, lat, col=rgb(nn, 0.3, 0.6), pch=19, cex=0.8)

# Still kind of unsatisfying...
#What if we want to see these over time?
#Animation library!

library(animation)

# Let's see a simple example with random data:
n = 20
x = sort(rnorm(n))  #Create 20 random x points
y = rnorm(n)

plot(x, y, type="n")   #type = n just sets up axes
ani.record(reset=TRUE)

#For each point, add it individually and record the #frame
for (i in 1:n) { 
  points(x[i], y[i])
  ani.record()
}

# Wait, what?  For loops??
# Super easy in R.  The syntax is merely:

#for (index in vector) {
#      do stuff!
#    }
for (i in 1:10) { 
  print(i);
}

for (letter in letters) { 
  print(letter);
}


# You can set lots of animation options pertaining to recording and playback 
#(we could have set animation size before we created it, for example).
ani.options(interval=0.2)

# To see our animation, we just use ani.replay()
ani.replay()

# Lets try this with our maps:

good.rows <- clicks[clicks$lat != 0 & clicks$lon != 0, ] # clean out missing geo

seconds <- good.rows$seconds
lat <- good.rows$lat
lon <- good.rows$lon

min_time <- min(seconds)
max_time <- max(seconds)

for (i in (min_time:(min_time+100))) {
  map("world", mar=c(0, 0, 0, 0))
  points(lon[seconds == i], lat[seconds == i], col=2, pch=18, cex=0.8)
  if (i == min_time) {
    ani.record(reset=TRUE)
  } else {
    ani.record()
  }
}
ani.replay()

# But that can be unwieldy.  Let's get some more control. saveHTML() will run 
# whatever you put in {} braces and turn it into a movie. (there's also saveSWF, 
# saveGIF, etc.)
saveHTML({ for (i in (min_time:(min_time+100))) {
  map("world", mar=c(0, 0, 0, 0))
  points(lon[seconds == i], lat[seconds == i], col=2, pch=18, cex=0.8)
  ani.pause()
}
}) # can add info like outdir, imgdir, outfile to specify output options


#Summary

#* Maps are awesome and easy to make
#* Colors on maps in R can help us see other dimensions
#* animation is a quick and dirty way to look through plots over time


## MORE STUFF!  TEXT!

# Phew, even MORE new data - Twitter user profiles!
users <- read.csv("http://jakeporway.com/teaching/data/users.csv", h=TRUE, as.is=T)

# Twitter user behavior:

#Let's look at our Twitter users and see if we can't classify something about
# how they behave based on where they live.

#Can we see the most popular words people use in their descriptions by location?

#Strategy:
#  - Figure out where the heck everyone lives - get canonical city names.
#  - For each city, count up the number of times each word appears in their descriptions
#  - Compare / contrast / map!

# Check this coolness out:  Some packages store data along with their functions 
# that can be loaded with the data() command.  Check out this neat dataset 
# from the maps library:
data(world.cities)
head(world.cities)

# Whoa!  The lat, lon, and population of every city in the world!  Awesome!  
# If we could get the city name of every one of our Twitter users, we could 
# match it up with this dataset to get lats and lons for them, as well as 
# rule out locations that arenâ€™t really cities.  Cool.

# First step to getting city names:  Letâ€™s split peopleâ€™s locations 
# up on the first â€œ,â€, assuming that they list their cities first.
location <- strsplit(users$location, ",")

# Hmm, but how do we reach into this location object and pull out just the 
# city name?  How can we get back just the first items from each little 
# subelement of the list?

# Well, we could loop over it using for loops (yay!)
for (i in 1:length(location)) {
  print(location[[i]][1]);
}

# But weâ€™ve just printed the results, not stored them.  Also, for 
# loops are actually pretty sucky in R and should be avoided if possible.  
# So what do we do?

# lapply() applies a function to each element of a list and returns a list
# of the answers.  Letâ€™s go back to our students list we created
lapply(students, names)

# Then we can use unlist() or the gentler sapply(), which tries to unlist
# things in a smart way for you.

# Well we can loop over our lists, thatâ€™s great, but what if we want to do 
# something fancier on each object?  Like how would we get the averages of all the grades?

for (s in students) {
  print(mean(s$grades))
}

# Hmm, but this just prints the averages.  We could create a vector (or another list) and store the values there:
mean.grades <- rep(0, length(students))
for (i in 1:length(students)) {
  mean.grades[i] <- mean(students[[i]]$grades)
}

# Yeah, but this turns out to be slow.  However, the good news is that we can 
# give *any* function to lapply(), even one we write ourselves!
# So we can send arbitrary functions to lapply like so:
lapply(students, function(x) { mean(x$grades) })

# This is a slightly different format than before, but basically 
# each element of the list is going to get passed in as the argument to function(),
# and then we can access those individual elements in the function as "x".

#So back to the problem of getting our city data out.  We can use lapply() to 
# loop over each element of the strsplit() result likeso:
cities <- lapply(location, function(x) { x[1] })
cities <- unlist(cities)
head(cities)

#And thatâ€™s it!

#OK!  Back to making a canonical list of cities.  
# It turns out that, often if we try to deal with Twitter data, 
# weâ€™ll quickly run into issues with Unicode characters, punctuation, 
# and a number of annoying things.  We want to deal with the city 
# names in a clean format (no Arabic or hearts in the middle of them), 
# so letâ€™s write code to:

#* Remove all control characters
#* Replace punctuation with spaces
#* Collapse big long sets of spaces down to single spaces
#* Turn everything into lowercase

## TEXT REVIEW ##
# You've seen the following functions for dealing with text in R:
#grep(pattern, data):  Searches for â€œpatternâ€ in the â€œdataâ€, returns
# the rows where itâ€™s found.
#substr(text, start, finish):  Returns the substring of â€œtextâ€ from â€œstartâ€ to â€œfinishâ€
#strsplit(data, splitter):  Splits the data based on â€œsplitterâ€

# But here's a new one:
# gsub(pattern, replace, data):  Replaces every occurrence of â€œpatternâ€ 
# with â€œreplaceâ€ in the data.

gsub("Obama", "Romney", "Now, Obamaâ€™s a guy who knows what to do for this country")

# â€œpatternâ€ can be a regular expression (remember those?) or a special character, 
# e.g. [[:punct:]] matches all punctuation and [[:cntrl:]] matches 
# funky control sequences.

gsub("[[:punct:]]", "?", "What if, imagine if every thought were a question.")

#We can use gsub() to remove any control characters and punctuation 
# from our text likeso:

cities <- gsub("[[:punct:]]", " ", cities) #replace punctuation with a space
cities <- gsub("[[:cntrl:]]", "", cities)  # Get rid of weird control characters

# We can also use regular expressions to replace long runs of 
# spaces with a single space.  â€œ\\sâ€ indicates a whitespace character, 
# and â€œ\\s+â€ is a regular expression for â€œone or more whitespacesâ€ 
# (brush up on your regexps if this looks funny)
gsub("\\s+", " ", "Collapse   all the   spaces!") 

#While weâ€™re at it, letâ€™s just go ahead and write a function to do
# this for us, as we may need it in the future:  

clean.text <- function(text) {
  text <- gsub("[[:cntrl:]]", "", text)
  text <- gsub("[[:punct:]]", " ", text)
  text <- gsub("\\s+", " ", text) # compress spaces
  text <- tolower(text)
  return(text)
}

cities <- clean.text(cities)
head(cities)

# At this point, cities is a list of cleaned, lowercase city names from 
# Twitter descriptions.  What we want to do is match our city names to 
# the world.cities city names, removing any that donâ€™t match.

# Well, as you might expect by now, thereâ€™s a function for that in R:  match()!
# match(a, b) tells you which row in b each row in a matches to.  It returns
# NA if there was no match
matches <- match(tolower(cities), tolower(world.cities$name))
head(matches)

# How many matched to world city names?
length(matches)
sum(!is.na(matches))

# is.na() returns TRUE is something is NA, a very special value in R.

# Compress to just the set of users whose cities we matched and
# bind on the lat and lon from world.cities
names(world.cities)
city.names <- world.cities[matches,c("name", "country.etc", "lat", "long")]
names(city.names) <- c("city", "country", "lat", "lon")
dim(city.names)
users <- cbind(users, city.names)
head(users)

# Stay with me here:  We just took all the matches from world.cities (i.e. all
# the cases where our users matched a world.cities entry) and mushed in the proper
# city, country, and lat lon.  Nice!  Let's just get rid of those pesky NA's now:

geo.users <- users[!is.na(users$lat), ] # Just the people who matched a city name

#Weâ€™re introducing a LOT of stuff here.  cbind() stands for â€œcolumn bindâ€ and is another way to add columns to a data frame.

# So, we've got these city names now all canonicalized!  We can compare
# people from the same city name but, erm, what's a good way to represent 
# qualitative values (like city names) numerically?  
#
# Factors!

# Factors treat strings as specific values, like "Low", "Med", "High". 
# You could imagine those mapping to 1, 2, 3, or "a", "b", "c".  The characters
# aren't important.

# Why do we care about this? Because we can apply functions to specific factor levels, which is super useful!
# lapply() - apply across all elements of a list
# tapply() - apply across all groups of a factor

# Example:
data(mtcars)
mtcars$cyl <- as.factor(mtcars$cyl)

# Get summaries of MPG by cylinder type for cars
tapply(mtcars$mpg, mtcars$cyl, summary)

par(mfrow=c(3,1))
tapply(mtcars$mpg, mtcars$cyl, hist, breaks=10:40)

# So we can do the same thing to count the number of words 
# for each city.  First create a new "clean" description 
# for each geo.user:
geo.users$city <- as.factor(geo.users$city)
desc <- geo.users$description
desc <- clean.text(desc)

geo.users <- data.frame(geo.users, clean.desc=desc)
head(geo.users)

# R made this a factor already, but we want it to be a string 
# in this case (You'll get used to this over time)
geo.users$clean.desc <- as.character(geo.users$clean.desc)
word.counts <- tapply(geo.users$clean.desc, geo.users$city, function(x) { table(unlist(strsplit(x, "\\s"))) })

# Cool!  We just counted the words up for each city.  Whatâ€™d we get?
# tapply() goes through the city list in the order provided by
# levels(geo.users$city)

# Let's look at NY:

ny.idx <- which(levels(geo.users$city) == "New York")
head(rev(sort(word.counts[[ny.idx]])))
# i  and  the    a   of 
# 391  377  259  248  214 

# Oh right, stop words.  There 
# are also probably lots of common words 
# between cities.  Would be cool if we could do 
# something neater with this...

# Behold!  TM!
library(tm)

# tm = text mining. Operates over blocks of text as if they're documents 
# (you could load a bunch from a directory, from the web, elsewhere).  
# We could use basic R commands to fix our results like we
# did before with stopwords, but tmâ€™s way cooler.

# Let's dump our combined, cleaned city descriptions
# as "documents" into a single "corpus" so tm can deal with it.
# This is kind of like how we had to turn our vector of numbers
# into a proper timeseries with ts() so R could do component
# decomposition.

desc.docs <- tapply(geo.users$clean.desc, geo.users$city, paste, sep=" ", 
                    collapse=" ")
head(desc.docs)


# Convert to a data frame 
docs.frame <- data.frame(docs=desc.docs)
docs.frame$docs <- as.character(docs.frame$docs)

# Load as a tm corpus
corpus <- Corpus(DataframeSource(docs.frame))


# Now we can do *super* cool stuff.  Watch this!
tdm <- TermDocumentMatrix(corpus, control=list(stopwords=TRUE))
(ny <- inspect(tdm[,which(levels(geo.users$city) == "New York")]))
# Ignore this huge list it prints out :P
ny <- ny[rev(order(ny[,1])),] 


tdm <- TermDocumentMatrix(corpus, control=list(stopwords=TRUE))
(sf <- inspect(tdm[,which(levels(geo.users$city) == "San Francisco")]))
# Ditto :P
sf <- sf[rev(order(sf[,1])),]

# We just created word counts from what's called a TermDocument Matrix (TDM),
# removing stopwords.
# Let's look at the top 10 most popular descriptions for NYers and SFers
ny[1:10]
sf[1:10]

# Shoot, "com", "love", "music", "lover" are all in here.  They're not stopwords,
# but they're going to be popular in EVERY city because EVERY city has people
# describing what they "love".  OK, so let's redo this with a cool feature:
# Term Frequency - Inverse Document Frequency!  It's a neat concept
# and we can use it with a simple argument to tdm()

tdm <- TermDocumentMatrix(corpus, control=list(stopwords=TRUE, weighting=weightTfIdf))
(ny <- inspect(tdm[,which(levels(geo.users$city) == "New York")]))
ny <- ny[rev(order(ny[,1])),]

tdm <- TermDocumentMatrix(corpus, control=list(stopwords=TRUE, weighting=weightTfIdf))
(sf <- inspect(tdm[,which(levels(geo.users$city) == "San Francisco")]))
sf <- sf[rev(order(sf[,1])),]

ny[1:10]
sf[1:10]

# Cool, so com and love are still there, but they're weighted differently.
# If we just built our matrix out of NY and SF they'd probably be weighted lower,
# but they must be in there because they're not common enough across all
# our cities.

# The more distinctive terms have risen to the top (Unsurprisingly they're 
# things like "Nyc" and "Francisco", but we see the difference
# between NYC = fashion/media vs. SF=founder/designer

tdm <- TermDocumentMatrix(corpus, control=list(stopwords=TRUE, weighting=weightTfIdf))
(px <- inspect(tdm[,which(levels(geo.users$city) == "Phoenix")]))
px <- px[rev(order(px[,1])),]
px[1:10]