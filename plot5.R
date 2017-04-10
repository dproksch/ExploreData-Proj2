#
# Question5:  How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore?
#

#
# Import required libraries
#
library(dplyr)
library(ggplot2)

#
# Read the datasets
#
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#
# subset to just Baltimore FIPS code
#
baltimore <- subset(NEI,NEI$fips == "24510") %>%
  select(year,SCC,Emissions)

#
# subset the SCC based upon the below inValues
#
inValues <- c("Highway Vehicles - Gasoline", "Highway Vehicles - Diesel", 
              "Off-highway Vehicle Gasoline, 2-Stroke", "Off-highway Vehicle Gasoline, 4-Stroke")

gasSCC <- subset(SCC, SCC.Level.Two %in% inValues) %>%
  select(SCC) 

#
# Use an INNER JOIN to join the two filtered data sets
results <- inner_join(baltimore, gasSCC, by=c("SCC","SCC")) %>% select(year, Emissions)

#
# Aggregate Emmissions by Year
#
aggResults <- aggregate(results$Emissions, by=list(results$year), FUN=sum)

#
# set column names to something useful
#
names(aggResults) <- c("year","Emissions")


png("plot5.png", width = 480, height = 480, units="px")
p <- ggplot(aggResults, aes(year,Emissions)) + geom_point() + geom_smooth(method = "lm", se = FALSE)
p
dev.off()