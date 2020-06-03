library(dplyr)
library(quanteda)
library(readtext)
library(tidytext)
library(tidyr)



wrd1 <- readRDS(file = "unigrm.rds") # unigram
wrd2 <- readRDS(file = "bigrm.rds")   #bigram
wrd3 <- readRDS(file = "trigrm.rds") # trigram
wrd4 <- readRDS(file = "tetragrm.rds") # tetragram

uni_gram_pred <- function(){
  t <- data.frame(word = wrd1$word[1:5], Probability = wrd1$KNP[1:5])
  t
}


two_gram_pred <- function(pword){
  t <- subset(wrd2, wrd2$word1 == pword)
  t <- t[order(-t$KNP),]
  df <- data.frame(word = t$word2[1:5], Probability = t$KNP[1:5])
  df
}

three_gram_pred <- function(pword1, pword2){
  t <- subset(wrd3, ((wrd3$word1 == pword1) & (wrd3$word2 == pword2)))
  t <- t[order(-t$KNP),]
  df <- data.frame(word = t$word3[1:5], Probability = t$KNP[1:5])
  df
}


tetra_gram_pred <- function(pword1, pword2, pword3){
  t <- subset(wrd4, ((wrd4$word1 == pword1) & (wrd4$word2 == pword2) & (wrd4$word3 == pword3)))
  t <- t[order(-t$KNP),]
  df <- data.frame(word = t$word4[1:5], Probability = t$KNP[1:5])
  df
}

predict_word <- function(sent){
  
  # convert to lower case
  sent <- tolower(sent)
  
  # tokenize sentence
  sent <- as.character(tokens(sent, remove_punct = T, remove_numbers = T, remove_symbols = T))
  
  # break the sentence
  sent_list <- unlist(strsplit(sent, " "))
  sent_len <- length(sent_list)
  
  if (sent_len == 0){
    df <- uni_gram_pred()
  }
  
  if (sent_list[sent_len] %in% wrd2$word1){
    df <- two_gram_pred(sent_list[sent_len])
  }
  else{
    df <- uni_gram_pred()
  }
  
  if(sent_len > 1){
    if ((sent_list[sent_len] %in% wrd2$word2) & (sent_list[sent_len-1] %in% wrd2$word1)){
      df <- rbind(three_gram_pred(sent_list[sent_len-1], sent_list[sent_len]), df)  
    }}
  
  if(sent_len > 2){
    if((sent_list[sent_len] %in% wrd3$word3) & (sent_list[sent_len-1] %in% wrd3$word2) & (sent_list[sent_len-2] %in% wrd3$word1)){
      df <- rbind(tetra_gram_pred(sent_list[sent_len-2], sent_list[sent_len-1], sent_list[sent_len]), df)
    }}
  
  df <- na.omit(df)
  df <- as.character(unique(df$word))
  
  if(length(df > 5)){df <- df[1:5]}
  
  df
}
