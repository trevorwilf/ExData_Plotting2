#########################
## Author: Trevor
## Date: 8/16/2015
#########################
# dependencies
#library(dplyr)
#library(ggplot2)
#library(lubridate)
#library(scales)
#library(grid)
#library(gridExtra)
#library(reshape2)

# adjust to your own working directory
setwd("C:\\github\\ExData_Plotting2")

# get data set
if(!file.exists("summarySCC_PM25.rds")){
  if(!file.exists("FNEI_data.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "FNEI_data.zip")
  }
  unzip("FNEI_data.zip")
}

# get data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
baltimoredata <- subset(NEI, fips == "24510")

# sum Emission by year transform data
sbaltimoredata <- tapply(baltimoredata$Emissions, baltimoredata$year, FUN=sum)
tbaltimoredata <- transform(sbaltimoredata)

#plat data
barplot(tbaltimoredata$X_data, main = "Baltimore Emissions by Year", xlab = "Year", ylab = "Emissions", col="PURPLE")

dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()