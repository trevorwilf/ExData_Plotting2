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

# get data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
totalrecords <- merge(NEI, SCC, by.x = "SCC", by.y = "SCC")

# Baltimore: Vehical pollution
baltimoredata <- subset(totalrecords, fips == "24510")
baltimorevehdata <- subset(baltimoredata, grepl(glob2rx("*Vehicles*") , baltimoredata$EI.Sector))
sbaltimorevehdata <- tapply(baltimorevehdata$Emissions, baltimorevehdata$year, FUN=sum)
tbaltimorevehdata <- transform(sbaltimorevehdata)
tbaltimorevehdata$year <- rownames(tbaltimorevehdata)
colnames(tbaltimorevehdata)[1] <- "balt"

# LA: Vehical pollution
LAdata <- subset(totalrecords, fips == "06037")
LAvehdata <- subset(LAdata, grepl(glob2rx("*Vehicles*") , LAdata$EI.Sector))
sLAvehdata <- tapply(LAvehdata$Emissions, LAvehdata$year, FUN=sum)
tLAvehdata <- transform(sLAvehdata)
tLAvehdata$year <- rownames(tLAvehdata)
colnames(tLAvehdata)[1] <- "LA"

# combine data set
finalpollution <- merge(tLAvehdata, tbaltimorevehdata, by.x = "year", by.y = "year")

#plot data - I provided two sets of plots.  One is scaled so that 
# the observer can view like next like and compare total in a visually
# accurate way.
LAPlot <- ggplot(data=finalpollution, aes(x = year, y = LA)) +
  geom_bar(stat="identity") +
  ggtitle("LA Vehical Emissions") +
  ylab("Emissions") +
  xlab("year")

BALTPlot <- ggplot(data=finalpollution, aes(x = year, y = balt)) +
  geom_bar(stat="identity") +
  ggtitle("Baltimore Vehical Emissions") +
  ylab("Emissions") +
  xlab("year")

LAPlotstd <- ggplot(data=finalpollution, aes(x = year, y = LA)) +
  geom_bar(stat="identity") +
  ggtitle("LA Vehical Emissions (scaled)") +
  ylab("Emissions") +
  xlab("year") +
  scale_y_continuous(limits = c(0, 4700))

BALTPlotstd <- ggplot(data=finalpollution, aes(x = year, y = balt)) +
  geom_bar(stat="identity") +
  ggtitle("Baltimore Vehical Emissions (scaled)") +
  ylab("Emissions") +
  xlab("year")+
  scale_y_continuous(limits = c(0, 4700))

grid.arrange(LAPlot, BALTPlot, LAPlotstd, BALTPlotstd)

#save png file
dev.copy(png, file="plot6.png", height=480, width=480)
dev.off()