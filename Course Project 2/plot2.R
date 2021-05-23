
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

# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

# Create data
b_total_emissions <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions))

# Create png file
png("plot2.png", width = 600, height = 400)

# Create plot
with(b_total_emissions,
     barplot(height=Emissions/1000, names.arg = year, col = color_range, 
             xlab = "Year", ylab = expression('PM2.5 in Kilotons'),
             main = expression('Baltimore, Maryland Emissions from 1999 to 2008'))
)

# Close the png file
dev.off()
