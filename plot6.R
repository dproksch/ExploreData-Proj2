#
# Question5:  Compare emissions from motor vehicle sources in Baltimore City with emissions 
#             from motor vehicle sources in Los Angeles County, CA (fips == "06037").
#             Which city has seen greater changes over time in motor vehicle emissions?
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
# subset the SCC based upon the below inValues
#
inValues <- c("Highway Vehicles - Gasoline", "Highway Vehicles - Diesel", 
              "Off-highway Vehicle Gasoline, 2-Stroke", "Off-highway Vehicle Gasoline, 4-Stroke")

gasSCC <- subset(SCC, SCC.Level.Two %in% inValues) %>%
  select(SCC) 

#
# subset to just Baltimore FIPS code
#
baltimore <- subset(NEI,NEI$fips == "24510") %>%
  select(year,SCC,Emissions)

#
# subset to just LA FIPS code
#
lax <- subset(NEI,NEI$fips == "06037") %>%
  select(year,SCC,Emissions)

#
# Use an INNER JOIN to join the two filtered data sets
#
b_results <- inner_join(baltimore, gasSCC, by=c("SCC","SCC")) %>% select(year, Emissions)
lax_results <- inner_join(lax, gasSCC, by=c("SCC","SCC")) %>% select(year, Emissions)

#
# Aggregate Emmissions by Year
#
b_aggResults <- aggregate(b_results$Emissions, by=list(b_results$year), FUN=sum)
lax_aggResults <- aggregate(lax_results$Emissions, by=list(lax_results$year), FUN=sum)

#
# set column names to something useful
#
names(b_aggResults) <- c("year","Emissions")
names(lax_aggResults) <- c("year","Emissions")
b_aggResults$location <- "Baltimore"
lax_aggResults$location <- "Los Angeles"

u <- union(b_aggResults,lax_aggResults)

png("plot6.png", width = 480, height = 480, units="px")
p <- ggplot(data=u, aes(x=year, y=Emissions, group=location, colour=location)) + geom_line() + 
  geom_point() + geom_smooth(method = "lm", se = FALSE, show.legend = TRUE)
p
dev.off()
    