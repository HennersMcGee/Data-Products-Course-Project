## ---------------------------
##
## Script name: Extract and Prep Data
##
## Purpose of script:
##
## Author: Henry Letton
##
## Date Created: 2019-10-20
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

#Load Packages
library(RMySQL); library(dplyr); library(plotly); library(caret)

## Get Thorpe Park Data

password <- readline(prompt="Enter password: ")

mydb = dbConnect(MySQL(), 
                 user='u235764393_HL', 
                 password=password, 
                 dbname='u235764393_HLDB', 
                 host='sql134.main-hosting.eu',
                 trusted_connection="True")

ThorpePark_DataClean <- dbGetQuery(mydb, "select * from ThorpePark_DataClean")

for (i in dbListConnections(MySQL())) {dbDisconnect(i)}

## Filter for use in shiny

dt1 <- ThorpePark_DataClean %>%
    dplyr::filter(Wait>=0) %>%
    dplyr::mutate(Date=as.Date(as.POSIXct(Scrape_Date))) %>%
    dplyr::mutate(Time=format(as.POSIXct(Scrape_Date),format="%H:%M:%S")) %>%
    dplyr::select(Ride, Date, Time, Wait) %>%
    dplyr::mutate(Time2=as.numeric(gsub("[: -]", "" , Time, perl=TRUE))) %>%
    arrange(Date,Time,Ride)

rideList <- unique(dt1 %>% arrange(Ride) %>% select(Ride))
dayList <- unique(dt1 %>% arrange(Date) %>% select(Date))

dtDelays <- ThorpePark_DataClean %>%
    dplyr::filter(Wait==-2) %>%
    dplyr::group_by_at("Ride") %>%
    dplyr::summarise(Count=n())

save(dt1,file="dt1.rds")
load("dt1.rds")

save(dtDelays,file="dtDelays.rds")
load("dtDelays.rds")

## Random Ride

Rides <- c("Colossus","Derren Brown","SAW - The Ride","Stealth","Swarm")
sample(Rides,1)
