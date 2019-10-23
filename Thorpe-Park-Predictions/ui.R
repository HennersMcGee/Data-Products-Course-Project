

library(shiny); library(dplyr); library(plotly); library(caret); library(randomForest)

load("dt1.rds")
load("dtDelays.rds")

rideList <- unique(dt1 %>% arrange(Ride) %>% select(Ride))
dayList <- unique(dt1 %>% arrange(Date) %>% select(Date))

# Define UI for application that draws a histogram
shinyUI(navbarPage("Thorpe Park",
                   tabPanel("Documentation",
                            h1("Instructions for Use"),
                            h4("The purpose of this shiny pack is to look at 
                               theme park waiting times, and build a model to 
                               predict the queue based on a chosen time frame 
                               and ride. The date has been collected every 5 
                               minutes during the theme parks opening hours. 
                               Delays were also collected.The different sections 
                               are explained below."),
                            h2("Data by Ride"),
                            h4("This section allows the user to look at the 
                               waiting times for a chosen ride, for many 
                               different days. The user can select the ride and 
                               date period to view."),
                            h2("Data by Day"),
                            h4("This section allows the user to look at the 
                               waiting times for a chosen day, for many 
                               different rides. The user can select the day to 
                               view."),
                            h2("Delays"),
                            h4("This section shows the total number of delays 
                               for each ride. A count of one means there was a 
                               5 minute interval where the ride was delayed."),
                            h2("Prediction"),
                            h4("This section allows the user to build a model on 
                               the data. The user selects a ride, and date 
                               period and then fits a random forest using time 
                               of day. The prediction is then plotted showing 
                               how the queue for that ride varies by time.")
                            ),
                   tabPanel("Data by Ride",
                            h4("You can select/deselect days by clicking the 
                               color in the legend."),
                            sidebarLayout(
                                sidebarPanel(
                                    dateRangeInput("daterange2",
                                                   "Date Range:",
                                                   start="2019-08-08",
                                                   end="2019-09-27"),
                                    selectInput("RideList2", "Ride:",
                                                rideList),
                                    submitButton("Show")
                                ),
                                
                                mainPanel(
                                    plotlyOutput("byRide")
                                )
                            )
                            ),
                   tabPanel("Data by Day",
                            h4("You can select/deselect rides by clicking the color in the legend."),
                            sidebarLayout(
                                sidebarPanel(
                                    selectInput("DayList3", "Date:",
                                                dayList),
                                    submitButton("Show")
                                ),
                                
                                mainPanel(
                                    plotlyOutput("byDay")
                                )
                            )
                            ),
                   tabPanel("Delays",
                            h4("This information is for the full date range."),
                                mainPanel(
                                    plotlyOutput("delays")
                                )
                            ),
                   tabPanel("Prediction",
                            h4("This may take up to a minute to fit a random forest"),
                            sidebarLayout(
                                sidebarPanel(
                                    dateRangeInput("daterange1",
                                                   "Date Range:",
                                                   start="2019-08-08",
                                                   end="2019-09-27"),
                                    selectInput("RideList1", "Ride:",
                                                rideList),
                                    submitButton("Predict")
                                ),
                                
                                mainPanel(
                                    plotlyOutput("predPlot")
                                )
                            )
                   )
))



