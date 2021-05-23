
#*******************************************************************************************
#*      
#*      Topic: Course Project 2
#*      Course: Exploratory Data Analysis - JHU
#*      Date: 22 may 2021
#*      Author: Carolina San Martín
#*      Theme: auxiliar file
#*
#*******************************************************************************************

# Loading required packages
packages <- c("dplyr")
for(p in packages) {
        if (!require(p,character.only = TRUE)) 
                install.packages(p); 
        library(p,character.only = TRUE)
}

#Getting data 
filename <- "exdata-data-NEI_data.zip"

if (!file.exists(filename)) {
        download_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(download_url, destfile = filename)
        unzip (zipfile = filename)
}

if (!exists("NEI")) {
        NEI <- readRDS("summarySCC_PM25.rds") 
}

if (!exists("SCC")) {
        SCC <- readRDS("Source_Classification_Code.rds")
}

# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Create data
total_annual_emissions <- aggregate(Emissions ~ year, NEI, FUN = sum)
color_range <- 2:(length(total_annual_emissions$year)+1)

# Create png file
png("plot1.png", width = 600, height = 400)

# Create plot
with(total_annual_emissions, 
     barplot(height=Emissions/1000, names.arg = year, col = color_range, 
             xlab = "Year", ylab = expression('PM2.5 in Kilotons'),
             main = expression('Annual Emission PM2.5 from 1999 to 2008')))

# Close the png file
dev.off()
