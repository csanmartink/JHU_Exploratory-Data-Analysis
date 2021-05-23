
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
packages <- c("dplyr","ggplot2")
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

# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

# Getting tidy data to analysis
b_emissions <- NEI %>%
        filter(fips == "24510") %>%
        group_by(year, type) %>%
        summarise(Emissions=sum(Emissions))

# Create png file
png("plot3.png", width = 600, height = 400)

# Create plot
bplot <- ggplot(data = b_emissions, aes(x = factor(year), y = Emissions, fill = type, colore = "black")) +
        geom_bar(stat = "identity") + facet_grid(. ~ type) + 
        xlab("Year") + ylab(expression("PM2.5 Emission")) +
        ggtitle('Total Emissions in Baltimore City, Maryland (fips == "24510") from 1999 to 2008') 
print(bplot)

# Close the png file
dev.off()
