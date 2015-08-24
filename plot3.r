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
baltimoredata <- subset(NEI, fips == "24510")
baltimorepoint <- subset(baltimoredata, type == "POINT")
baltimorenonpoint <- subset(baltimoredata, type == "NONPOINT")
baltimoreonroad <- subset(baltimoredata, type == "ON-ROAD")
baltimorenonroad <- subset(baltimoredata, type == "NON-ROAD")

# transform data
sbaltimoredata <- tapply(baltimoredata$Emissions, baltimoredata$year, FUN=sum)
sbaltimorepoint <- tapply(baltimorepoint$Emissions, baltimorepoint$year, FUN=sum)
sbaltimorenonpoint <- tapply(baltimorenonpoint$Emissions, baltimorenonpoint$year, FUN=sum)
sbaltimoreonroad <- tapply(baltimoreonroad$Emissions, baltimoreonroad$year, FUN=sum)
sbaltimorenonroad <- tapply(baltimorenonroad$Emissions, baltimorenonroad$year, FUN=sum)

tbaltimoredata <- transform(sbaltimoredata)
tbaltimorepoint <- transform(sbaltimorepoint)
tbaltimorenonpoint <- transform(sbaltimorenonpoint)
tbaltimoreonroad <- transform(sbaltimoreonroad)
tbaltimorenonroad <- transform(sbaltimorenonroad)

tbaltimoredata$year <- rownames(tbaltimoredata)
tbaltimorepoint$year <- rownames(tbaltimorepoint)
tbaltimorenonpoint$year <- rownames(tbaltimorenonpoint)
tbaltimoreonroad$year <- rownames(tbaltimoreonroad)
tbaltimorenonroad$year <- rownames(tbaltimorenonroad)

# plot data
# on the following plots I decided not to calibrate each Y access to 2150.
# The question is only concerned with what each type of pollution has done, 
# and does not care about how they compare to each other.  There fore there
# is no need to standardize the observation across each plot.  I have left 
# in the code to calibrate the Y coordinates if someone wants to see how 
# each compares to the other in the future.  Just un comment the lines.
baltpoint <- ggplot(data=tbaltimorepoint, aes(x = year, y = X_data)) +
  geom_bar(stat="identity") +
  ggtitle("Baltimore Point Pollution") +
  ylab("Pollution") +
  xlab("year") #+
#  scale_y_continuous(limits = c(0, 2150))

baltnonpoint <- ggplot(data=tbaltimorenonpoint, aes(x = year, y = X_data)) +
  geom_bar(stat="identity") +
  ggtitle("Baltimore NON-Point Pollution") +
  ylab("Pollution") +
  xlab("year") #+
#  scale_y_continuous(limits = c(0, 2150))

baltonroad <- ggplot(data=tbaltimoreonroad, aes(x = year, y = X_data)) +
  geom_bar(stat="identity") +
  ggtitle("Baltimore On-Road Pollution") +
  ylab("Pollution") +
  xlab("year") #+
#  scale_y_continuous(limits = c(0, 2150))

baltonroad <- ggplot(data=tbaltimorenonroad, aes(x = year, y = X_data)) +
  geom_bar(stat="identity") +
  ggtitle("Baltimore Non-Road Pollution") +
  ylab("Pollution") +
  xlab("year") #+
#  scale_y_continuous(limits = c(0, 2150))

grid.arrange(baltpoint, baltnonpoint, baltonroad, baltonroad)

#save png file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()