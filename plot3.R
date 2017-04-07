#
# Question3:  Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎
#              (point, nonpoint, onroad, nonroad) variable, which of these four sources have 
#             seen decreases in emissions from 1999–2008 for Baltimore City? 
#             Which have seen increases in emissions from 1999–2008?
#             Use the ggplot2 plotting system to make a plot answer this question.

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
              select(year,type,Emissions)

#
# Aggregate all Emissions data, grouping by type, year
#
alldata <- aggregate(baltimore$Emissions, by=list(baltimore$type,baltimore$year), FUN=sum)


#
# set column names to something useful
#
names(alldata) <- c("type","year","Emissions")

# 
# plot the data
# 
png("plot3.png", width = 480, height = 480, units="px")
p <- ggplot(alldata, aes(year,Emissions)) + geom_point()
p + facet_grid(. ~ type)
dev.off()

