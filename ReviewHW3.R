### looking over hw 3 ###

tweets = read.csv("http://jakeporway.com/teaching/data/libya_tweets.csv", h=TRUE, as.is=TRUE)

# looking into lists
# used for things that doent fit well into rectangular data frames

craig = list(name='Craig', year="Senior", grades=c(81,86,83))  # create a list
craig[[2]]] # returns the actual value
students = list(craig, emily) # can nest lists

# strsplit()

words = strsplit(tweets$text, " ")
words[[2]] # second tweet broken into individual words
wordlist = unlist(words) # create a vecotr of the words
head(rev(sort(table(wordlist))))  # lets see the most used words in all tweets

stopwords = stopwords[ ,1]
1:10 %in% 3:5 # returns TRUE FALSE values
stopword.index = wordlist %in% stopwords



