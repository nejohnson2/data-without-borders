### Maps Animation Text in R #####

diff(1:100, lag=10)  # look at the difference in numbers

# bit.ly JSON
clicks = read.csv("http://jakeporway.com/teaching/data/bitly.csv", as.is=TRUE, header=TRUE)
hist(clicks$seconds, breaks=1000)

# continuous vaiable = look at the distribution 

length(unique(clicks$agent)) # how many unique agents are there?
head(rev(sort(table(clicks$agent)))) 
plot(rev(sort(table(clicks$agent))), type='h') # plot the agent distribution

install.packages("maps")
library(maps)
map("world")
points(clicks$lon, clicks$lat, col=2, pch=19, cex=0.8)

# Step 1) create the map.  Step 2) plot points over the map
map("state", "Indiana", mar=c(0,0,0,0))
points(lon,lat, col=2, pch=19, cex=0.8)
points(clicks$lon, clicks$lat, col=rgb(120, 180, 255, maxColorVal=255), pch=19, cex=0.8) # add baby blue
points(clicks$lon, clicks$lat, col=rgb(120, 180, 255, 80, maxColorVal=255), pch=19, cex=0.8) # add transparency 

# How to normalize values:
# 1) Shift everything to zero subtract our the min value
# 2)
x1 = clicks$seconds
x2 = x1 - min(x1)
final = x2 / max(x2)

# plotting over time
# create a vector of colors
points(clicks$lon, clicks$lat, col=rgb(final, 0, final/2), pch=19, cex=0.8) 

##### Create the animation ######
install.packages("animation")
library(packages)

n = 20
x = sort(rnorm(n))
y = rnorm(n)
plot(x,y, type="n")
ani.record(reset=TRUE)
for (i in 1:n) {
  points(x[i], y[i])
  ani.record()
}
ani.replay()
}

#### Save HTML ###
saveHTML()

users = read.csv("http://jakeporway.com/teaching/data/users.csv", h=T, as.is=T)
split.location = strsplit(users$location, ",")

# to pull out the location for each user
for (i in 1:length(split.location)) {
  print(split.location[[i]][1]);
}

# it gives back a list which is great!!!
lapply() # list apply = apply something to every element in this list
lapply(students, names) # give it a list (students) and give it a function (names)

