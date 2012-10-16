# Assigntment 3 
# Nicholas Johnson


twitter = read.csv("/Users/Luce/ITP/Data_wo_Borders/Lecture_3/Libya_tweets.csv", as.is=TRUE)

# How many unique users have more than 100000 followers? What are their screen names?
length(which(twitter$followers > 100000)) # 22 users
top.followed = twitter[twitter$followers > 100000, ]  # create a subset of the top 100,000
top.followed.screen.name = top.followed$screen_name

# What are the top 3 locations people are from (not counting blanks)?
top.locations = rev(sort(table(twitter$location)))  # order by locations
top.locations[2:4]   # top three locations not including blanks.  The top was blank.  USA, Tripoli, London

# What is the text of the tweet that was retweeted the most times and who tweeted it?
most.retweeted = twitter[which(twitter$retweet == max(sort(twitter$retweet)))]  # subset the most retweeted
most.retweeted[,3] # text "@callieballoo and that was wrong. #egypt, #libya, all wrong - cant do that as a reaction."
most.retweeted[,5] # screen name.  zeesh2

# Plot the distribution of the number of people the users are following.  What do you see?
hist(twitter$follower, freq=F)

# Let’s reduce our set to just people with fewer than 5000 followers and 
# look at the histogram again. What do you see now? Have you tried using different breaks? 
# Does anything surprise you?
follower.count.gt.one = twitter$followers[twitter$followers > 1]  # 2414 total
follower.count.gt.fivethousand = twitter$followers[twitter$followers > 5000] # 199 total
hist(follower.count.gt.fivethousand, freq=F, breaks=10)
hist(follower.count.gt.fivethousand, freq=F, breaks=100)
hist(follower.count.gt.fivethousand, freq=F, breaks=1000)

# it is clear that there are only a few people which have the most number of followers.  The majority
# of the people have less than 100 followers wereas the top 199 have over five thousand

# Write code to find the 5 most popular words used in the descriptions of our users
description = twitter$description
strsplit(description, " ")
lower.case.description = tolower(unlist(strsplit(description, " ")))  # give me all of the individual words in lowercase 
sort(table(lower.case.description))  # the, and, of, " ", a

# remove the stopwords from the descriptions and recompute the top 5 words our Twitter 
# users use to describe themselves. What do you think of the results? Do you have a sense of 
# what types of users are most common in our dataset?
stopwords = read.csv("http://jmlr.csail.mit.edu/papers/volume5/lewis04a/a11-smart-stop-list/english.stop", as.is=TRUE)
new.stopwords = c("&", "-","", "|")
total.stopwords = append(stopwords[,1], new.stopwords, after=length(stopwords[,1]))
unique.words = lower.case.description[!(lower.case.description %in% total.stopwords)]
sort(table(unqiue.words)) # news, love, world, follow, conservative

# one could assume that 'conservative' being a top descriptive word would indicate that the top Twitter users
# are conservative but I would argue this is a poor assumption.  The description could have been 'not conservative'
# but based on our search we didnt detect the 'not'.  I dont think this process really gives us a good idea of 
# who the twitter users are.

# Tell me what search terms you used and then teach me something about your dataset, preferably 
# something you find interesting. You can just repeat one of the exercises we did above on your 
# new data but, if you have the time, I’d encourage you to dig into the data and try to find 
# something that surprises you.

jb = read.csv("/Users/Luce/ITP/Data_wo_Borders/Lecture_3/jb.csv", as.is=TRUE)  # search term 'Justin Bieber'
new.jb.stopwords = c("de", "justin". "bieber", "le", "el", "en")
jb.total.stopwords = append(stopwords[,1], new.jb.stopwords, after=length(stopwords[,1]))
jb.unique.words = split.description[!(split.description %in% jb.total.stopwords)]
sort(table(jb.unique.words))  # top five Justin Bieber descption words: love, follower, @justinbieber, ♥ , belieber

# I could help but to do a Justin Bieber search.  I narrowed down the top 5 description words for the 170 followers that I found.
# The search went about as I expected finding love, follow and a heart as some of the top description words.  There was one
# word however that did surprise me.  Belieber.  At first I found it comical assuming it was a misspelling of his last name.  
# Then on a second thought I realized it was the combination of Believer and Bieber.  A Beiber believer is a Belieber.