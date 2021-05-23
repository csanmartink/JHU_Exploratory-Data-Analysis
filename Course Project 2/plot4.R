
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


# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# Getting tidy data to analysis
coal_SCC <- SCC[grep("[Cc][Oo][Aa][Ll]", SCC$EI.Sector), "SCC"]
coal_NEI <- NEI %>% filter(SCC %in% coal_SCC)
coal_summary <- coal_NEI %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

# Create png file
png("plot4.png", width = 600, height = 400)

# Create plot
cplot <- ggplot(coal_summary, aes(factor(year), round(Emissions/1000,2))) 
cplot <- cplot + geom_bar(stat="identity", fill="steelblue") + theme_minimal() +
        ylab(expression("PM2.5 Emissions in Kilotons")) + 
        xlab("Year") +
        ggtitle("Coal Combustion Emissions in period 1999-2008")
print(cplot)

# Close the png file
dev.off()

        