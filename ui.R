library(shiny)
library(dplyr)

url <- "http://www.cso.ie/px/pxeirestat/Database/Eirestat/Regional%20Accounts/ACA03.px"
ACA03df <- as.data.frame(pxR::read.px(url))
Crops <- ACA03df %>% 
    filter(Statistic %in% levels(ACA03df$Statistic)[10:16]) %>% #restrict to data about crops
    filter(Region == "State")

shinyUI(fluidPage(
    
    titlePanel("Irish Crop Values Over Time"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("Statistic", label = "Select a Crop", choices = unique(Crops$Statistic))
        ),
        
        mainPanel(
            plotOutput("yearplot"),
            dataTableOutput("yeartable")
        )
    )
))
