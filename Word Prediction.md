Word Prediction using N-grams: Capstone project
========================================================
author: Vasantha Ramani 
date: 3 June,2020
autosize: true

Dataset for text mining
========================================================

In this capstone project a predictive text model like the one used by SwiftKey is built. 

- A large corpus of data from the following link was downloaded <https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip>. It consists of texts from various languages. For our purpose, texts from English database is used.  
- As the dataset is very large, only a small portion of the sampled dataset is used for building the corpus. 
- The dataset consists of texts from US blogs, twitter and news. Following lines are picked from the news data:




```
[1] "8662 Spoon Dr, $140,000"                                                                                                                                                                                                                                                                                                         
[2] "Romney's handling of the fiscal crisis when he took over as governor in 2003 is a guide to how he might act on his promises for lower taxes and reduce the federal deficit if he's elected president. He has sketched a broad, fiscally conservative vision during the primaries but has yet to specify how he would pay for it."
```

Analysing the dataset
========================================================
- First a preliminary exploratory data anlysis is conducted on the dataset. 
- For textmining 'quanteda' library package was used extensively. A corpus was built using the sampled data. 
- The dataset is cleaned by removing punctuations, numbers and symbols and also converting all the words to lower case. Stop words are not removed as any sentence would have these words. 
- N-grams are built following the cleaning of the dataset. 

N-grams
========================================================
- Unigram, bigram, trigram and tetragram words are used for building the prediction model. 
- Frequency of N-grams is obtained form the document feature matrix. Only those N-grams with a minimum frequency greater than 5 is used for building the prediction model. 
- After trimming the document feature matrix, 1-gram, 2-gram and 3-gram consists of over 80,000 observations and 4-gram consists of over 20,000 observartions. 
- From the observed frequency, probability of occurance for each of the observation for the N-grams were computed. 

Shiny app for word prediction
========================================================
- Stupid backoff is used for word prediction
- The link to shiny app for word prediction is here: <https://vramani.shinyapps.io/NPL_prediction/>.
- Following is the image of the Shiny app for word prediction: 
<img src="Word_prediction.png" title="Shiny App" alt="Shiny App" width="100%" />
- A maximum of five words are predicted for the entered text.
- Incase there are no matches, most commonly used words from unigrams are returned as output. 

Thank you!
========================================================


