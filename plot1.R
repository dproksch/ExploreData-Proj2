#
# Question1:  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
#             Using the base plotting system, make a plot showing the total PM2.5 emission from all 
#             sources for each of the years 1999, 2002, 2005, and 2008.
#

#
# Import required libraries
#

#
# Read the datasets
#
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

#
# Filter by year
#
n1999 <- NEI[NEI$year == 1999,]
n2002 <- NEI[NEI$year == 2002,]
n2005 <- NEI[NEI$year == 2005,]
n2008 <- NEI[NEI$year == 2008,]

#
# Total emissions for each year
#
s1999 <- sum(n1999$Emissions)
s2002 <- sum(n2002$Emissions)
s2005 <- sum(n2005$Emissions)
s2008 <- sum(n2008$Emissions)

# vector of Years
xy <- c(1999,2002,2005,2008)

#
# Produce the chart
# 
png("plot1.png", width = 480, height = 480, units="px")
plot(xy,c(s1999,s2002,s2005,s2008), type = "b", ylab = "Total Emissions Output", xlab = "Years", main = "Total PM25 Emissions / Year")
dev.off()