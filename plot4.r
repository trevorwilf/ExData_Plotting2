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

# first get combustion related records, then filter for coal
combsubset <- subset(totalrecords, grepl(glob2rx("*Comb*") , totalrecords$Short.Name))
coalsubset <- subset(combsubset, grepl(glob2rx("*Coal*") , combsubset$EI.Sector))

# transform data
scoalsubset <- tapply(coalsubset$Emissions, coalsubset$year, FUN=sum)
tcoalsubset <- transform(scoalsubset)
tcoalsubset$year <- rownames(tcoalsubset)

#plot data
ggplot(data=tcoalsubset, aes(x = year, y = X_data)) +
  geom_bar(stat="identity") +
  ggtitle("Total Coal Combustion Emissions") +
  ylab("Emissions") +
  xlab("year")

#save png file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()