library(dplyr)
library(quanteda)
library(readtext)
library(tidytext)
library(tidyr)

#creating data file in case it does not exist
if (!file.exists("data")){
  dir.create("data")
}

# downloading the file
download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", destfile ="./data/Dataset.zip")

#unzip the data file 
unzip(zipfile = "./data./Dataset.zip", exdir = "./data")

# file size 
file.size("./data./final./en_US./en_US.blogs.txt")


# length of each file 
con <- file("./data./final./en_US./en_US.twitter.txt")
open(con, 'r')
x <- readLines(con)
close(con)

con <- file("./data./final./en_US./en_US.blogs.txt")
open(con, 'r')
y <- readLines(con)
close(con)

con <- file("./data./final./en_US./en_US.news.txt")
open(con, 'r')
z <- readLines(con)
close(con)

# sample the data 
set.seed(1130)

twitter_samp <- x[sample(1:length(x))]
twitter_samp <- twitter_samp[1:(as.integer(0.02*length(x)))]

blogs_samp <- y[sample(1:length(y))]
blogs_samp <- blogs_samp[1:(as.integer(0.020*length(y)))]

news_samp <- z[sample(1:length(z))]
news_samp <- news_samp[1:(as.integer(0.25*length(z)))]


comb_corp <- rbind(twitter_samp, blogs_samp, news_samp)
rm(x,y,z)

# create corpus
corp_doc2 <- corpus(comb_corp)
summary(corp_doc2)

# tokenize corpus
corp_doc2 <- tolower(corp_doc2)
tok <- tokens(corp_doc2, remove_punct = T, remove_numbers = T, remove_symbols = T)

#1,2,3 and 4 gram 
ngram1 <- tokens_ngrams(tok, n = 1)
ngram2 <- tokens_ngrams(tok, n = 2)
ngram3 <- tokens_ngrams(tok, n = 3)
ngram4 <- tokens_ngrams(tok, n = 4)

# dfm matrix
mat_feature1 <- dfm(ngram1)
nfeat(mat_feature1)
topfeatures(mat_feature1, 10)

mat_feature2 <- dfm(ngram2)
nfeat(mat_feature2)
topfeatures(mat_feature2, 10)


mat_feature3 <- dfm(ngram3)
nfeat(mat_feature3)
topfeatures(mat_feature3, 10)

mat_feature4 <- dfm(ngram4)
nfeat(mat_feature4)
topfeatures(mat_feature4, 10)

# trim features
mat_feature1 <- dfm_trim(mat_feature1, min_termfreq = 1)
mat_feature2 <- dfm_trim(mat_feature2, min_termfreq = 5)
mat_feature3 <- dfm_trim(mat_feature3, min_termfreq = 5)
mat_feature4 <- dfm_trim(mat_feature4, min_termfreq = 5)

# word frequency
wrd1 <- data.frame("word" = rownames(as.data.frame(featfreq(mat_feature1))), "frequency" = as.data.frame(featfreq(mat_feature1)))
colnames(wrd1) <- c("word", "freq")
wrd1 <- arrange(wrd1, desc(wrd1$freq))
wrd1$Prob <- wrd1$freq/ sum(wrd1$freq)
wrd1$KNP <- wrd1$freq/ sum(wrd1$freq)

wrd2 <- data.frame("word" = rownames(as.data.frame(featfreq(mat_feature2))), "frequency" = as.data.frame(featfreq(mat_feature2)))
wrd2 <- separate(wrd2, col = word, into = c("word1","word2"), sep = "_")
colnames(wrd2) <- c("word1", "word2", "freq")
wrd2 <- arrange(wrd2, desc(wrd2$freq))

wrd3 <- data.frame("word" = rownames(as.data.frame(featfreq(mat_feature3))), "frequency" = as.data.frame(featfreq(mat_feature3)))
wrd3 <- separate(wrd3, col = word, into = c("word1","word2", "word3"), sep = "_")
colnames(wrd3) <- c("word1", "word2", "word3", "freq")
wrd3 <- arrange(wrd3, desc(wrd3$freq))

wrd4 <- data.frame("word" = rownames(as.data.frame(featfreq(mat_feature4))), "frequency" = as.data.frame(featfreq(mat_feature4)))
wrd4 <- separate(wrd4, col = word, into = c("word1","word2", "word3", "word4"), sep = "_")
colnames(wrd4) <- c("word1", "word2", "word3", "word4", "freq")
wrd4 <- arrange(wrd4, desc(wrd4$freq))

# calculate probability 
d = .75
btype <- nrow(wrd2)
for (i in 1:nrow(wrd2)){
  t <- subset(wrd2, wrd2$word1 == wrd2$word1[i])
  term1 <- (wrd2$freq[i]-d)/sum(t$freq)
  term2 <- d*nrow(t)/sum(t$freq)
  term3 <- nrow(t)/btype
  wrd2$KNP[i] <- term1 + (term2*term3) 
}

ttype <- nrow(wrd3)
for (i in 1:nrow(wrd3)){
  t <- subset(wrd3, ((wrd3$word1 == wrd3$word1[i]) & (wrd3$word2 == wrd3$word2[i])))
  term1 <- (wrd3$freq[i]-d)/sum(t$freq)
  term2 <- d*nrow(t)/sum(t$freq)
  term3 <- nrow(t)/ttype
  wrd3$KNP[i] <- term1 + (term2*term3) 
}

tettype <- nrow(wrd4)
for (i in 1:nrow(wrd4)){
  t <- subset(wrd4, ((wrd4$word1 == wrd4$word1[i]) & (wrd4$word2 == wrd4$word2[i]) & (wrd4$word3 == wrd4$word3[i])))
  term1 <- (wrd4$freq[i]-d)/sum(t$freq)
  term2 <- d*nrow(t)/sum(t$freq)
  term3 <- nrow(t)/tettype
  wrd4$KNP[i] <- term1 + (term2*term3) 
}

# save the files
saveRDS(wrd1, file = "unigrm.rds")
saveRDS(wrd2, file = "bigrm.rds")
saveRDS(wrd3, file = "trigrm.rds")
saveRDS(wrd4, file = "tetragrm.rds")
