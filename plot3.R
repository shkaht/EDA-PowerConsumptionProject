library(dplyr)
library(lubridate)

setwd("C:/Users/207014104/Desktop/DataScience/ExploratoryDataAnalysis")

#download dataset and unzip
filename <- "ElecPowerCons.zip"
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileURL, filename)
}  
if (!file.exists("household_power_consumption.txt")) { 
        unzip(filename) 
}

#read data as a dplyr tibble and wrangle
PowerCons <- tbl_df(read.table("household_power_consumption.txt", 
                               header = TRUE,
                               sep = ";", 
                               na.strings = "?", 
                               stringsAsFactors = FALSE))  %>%
        
        mutate(DateTime = paste(Date, Time)) %>%
        mutate(Date = as.Date(dmy(Date))) %>%
        mutate(Time = hms::as.hms(Time)) 

PowerCons$DateTime <- dmy_hms(PowerCons$DateTime)

#subset just February 1 and 2, 2007
PowerDates <- filter(PowerCons, grepl("2007-02-01|2007-02-02", Date))

#create plot 3

png(file = "plot3.png")

with(PowerDates, plot(DateTime, Sub_metering_1, 
                      type = "l",
                      xlab = "", 
                      ylab = "Energy sub metering"))
with(PowerDates, lines(DateTime, Sub_metering_2, col = "red"))
with(PowerDates, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright", 
       lty = 1, 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1",
                  "Sub_metering_2", 
                  "Sub_metering_3"
                  ) 
       )

dev.off()