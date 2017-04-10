#
# Question4:  Across the United States, 
#             how have emissions from coal combustion-related sources 
#             changed from 1999–2008?
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
# subset the coal and combustion related records.
#
coalSCC <- subset(SCC, grepl("coal", SCC.Level.Four, ignore.case = TRUE)) %>%
  subset(grepl("combustion", SCC.Level.One, ignore.case = TRUE)) %>%
  select(SCC) 

#
# get all the unique IDs
#
coalSCC <- unique(coalSCC$SCC)

#
# subset the NEI dataset based upon the unique values in coalSCC
#
coalNEI <- subset(NEI, NEI$SCC %in% coalSCC) %>% select(year, Emissions)

#
# aggregate data by year
# 
alldata <- aggregate(coalNEI$Emissions, by=list(coalNEI$year), FUN=sum)

#
# set column names to something useful
#
names(alldata) <- c("year","Emissions")


png("plot4.png", width = 480, height = 480, units="px")
p <- ggplot(alldata, aes(year,Emissions)) + geom_point() + geom_smooth(method = "lm", se = FALSE)
p
dev.off()
