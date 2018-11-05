library(tm)
#subset the abstracts to just those that mention one of the collaborating cities
#ACTION: SWITCH TO GENERIC PATH AND DELETE THIS COMMENT
files <- dir("C:/Users/epfaff/Documents/GitHub/Pfaff_Project3/data", pattern = "\\.txt$", full.names = TRUE)

#write a function to convert city names into regex for use in the for loop below.
citytoregex <- function(cityname) {
  switch(cityname,
         "Boston" = "(Boston)",
         "Durham" = "(Durham)",
         "New York" = "(New\\s?York,\\s?(NY|New\\sYork)|Bronx)",
         "Houston" = "(Houston)",
         "Seattle" = "(Seattle)",
         "Chicago" = "(Chicago)",
         "Los Angeles" = "(Los\\s?Angeles)",
         "Philadelphia" = "(Philadelphia)",
         "Bethesda" = "(Bethesda)",
         "Rochester" = "(Rochester)"
         )
}
citytoregex("New York")

abstractcount = 1
sepabstracts<-vector("list")
for (i in 1:length(files)) {
  matchedabstract <- sum(str_count(read_lines(files[i]),"(Rochester)"))
  #matchedabstract <- sum(str_count(read_lines(files[i]),"(Boston|Durham|New\\s?York,\\s?(NY|New\\sYork)|Bronx|Houston|Seattle|Chicago|Los\\s?Angeles|Philadelphia|Bethesda|Rochester)"))
  if(matchedabstract>0) {
    sepabstracts[[abstractcount]] <- read_lines(files[i])
    abstractcount = abstractcount + 1
  } 
}
vectorabs <- unlist(sepabstracts)
concatabs <- paste(vectorabs, collapse = '')


docs <- Corpus(VectorSource(concatabs))
#convert to lowercase
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("university","center","medical","research","institute","school","department","usa",
                                    "north","carolina","houston","boston","new","york","college","chapel","hill","national",
                                    "texas","baylor","doi","durham","duke","united","division","public","sciences","san",
                                    "washington","seattle","chicago","los","angeles","california","comprehensive",
                                    "philadelphia","bethesda","rochester","mayo","clinic","alliance")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

