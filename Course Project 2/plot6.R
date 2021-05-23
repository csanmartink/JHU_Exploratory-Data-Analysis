
#*******************************************************************************************
#*      
#*      Topic: Course Project 2
#*      Course: Exploratory Data Analysis - JHU
#*      Date: 23 may 2021
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


# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

# Preparing data
subset <- NEI[(NEI$fips=="24510" | NEI$fips=="06037") & NEI$type=="ON-ROAD",  ]
total <- aggregate(Emissions ~ year + fips, subset, sum)
total$fips[total$fips=="24510"] <- "Baltimore"
total$fips[total$fips=="06037"] <- "Los Angeles"

# Create png file
png("plot6.png", width = 700, height = 500)

# Create plot
bcvplot <- ggplot(total, aes(factor(year), round(Emissions/1000, 2)))
bcvplot <- bcvplot + geom_bar(stat = "identity", aes(fill = fips)) + facet_grid(. ~ fips) +
        ylab(expression("PM2.5 Emissions in Kilotons")) + xlab("Year") +
        ggtitle("Total Emissions from motor vehicle in Los Angeles vs Baltimore Vehicle Emissions, period 1999-2008")
print(bcvplot)

# Close the png file
dev.off()
