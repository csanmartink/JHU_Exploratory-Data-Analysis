
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


# 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
scc_vehicles <- SCC[grep("[Vv]ehicle", SCC$EI.Sector), "SCC"]
vehicle_emissions <- NEI %>% 
        filter(SCC %in% scc_vehicles & fips == "24510") %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions))

# Create png file
png("plot5.png", width = 600, height = 400)

# Create plot
vplot <- ggplot(coal_summary, aes(factor(year), round(Emissions/1000,2)))
vplot <- vplot + geom_bar(stat="identity", fill="darkgreen") + theme_minimal() + 
        ylab(expression("PM2.5 Emissions in Kilotons")) + xlab("Year") +
        ggtitle("Baltimore Vehicle Emissions in period 1999-2008")
print(vplot)

# Close the png file
dev.off()
