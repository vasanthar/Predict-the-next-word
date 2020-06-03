library(shiny)
library(dplyr)
library(quanteda)
library(readtext)
library(tidytext)
library(tidyr)
source("ngrm.R")
library(rsconnect)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        output$pred <- renderText({predict_word(input$sent)})
    
    })

