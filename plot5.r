#########################
## Author: Trevor
## Date: 8/16/2015
#########################
# dependencies
#install.packages("ggplot2")
#install.packages("gridExtra")
#install.packages("grid")
#install.packages("dplyr")
#install.packages("lubridate")
#install.packages("reshape2")
library(dplyr)
library(ggplot2)
#library(lubridate)
#library(scales)
library(grid)
library(gridExtra)
#library(reshape2)

# adjust to your own working directory
setwd("C:\\github\\ExData_Plotting2")

# get data set files
if(!file.exists("summarySCC_PM25.rds")){
  if(!file.exists("FNEI_data.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
  }
  unzip("FNEI_data.zip")
}

# get baltimore data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
totalrecords <- merge(NEI, SCC, by.x = "SCC", by.y = "SCC")
baltimoredata <- subset(totalrecords, fips == "24510")

# filter on Vehicles to get all road motor vehicals
baltimorevehdata <- subset(baltimoredata, grepl(glob2rx("*Vehicles*") , baltimoredata$EI.Sector))
#baltimoreonroad <- subset(baltimoredata, type == "ON-ROAD")

# sum the Emissions and transform data 
sbaltimorevehdata <- tapply(baltimorevehdata$Emissions, baltimorevehdata$year, FUN=sum)
tbaltimorevehdata <- transform(sbaltimorevehdata)
tbaltimorevehdata$year <- rownames(tbaltimorevehdata)

#plot data
ggplot(data=tbaltimorevehdata, aes(x = year, y = X_data)) +
  geom_bar(stat="identity") +
  ggtitle("Baltimore Vehical Emissions") +
  ylab("Emissions") +
  xlab("year")

#save png file
dev.copy(png, file="plot5.png", height=480, width=480)
dev.off()