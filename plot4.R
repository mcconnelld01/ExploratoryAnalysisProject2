require(dplyr)
require(ggplot2)

## If one or other ot the necessary files does not exist, download and unzip the dataset
if(!file.exists("summarySCC_PM25.rds")|!file.exists("Source_Classification_Code.rds"))
{
  download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="temp.zip")
  unzip("temp.zip")
  file.remove("temp.zip")
}

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Create a vector of SCC numbers that correspond to coal combustion related sources.
# The easiest way to do this appears to be searching the column EI.Sector for the strings
# "Coal" and "Comb", and filtering those rows that contain both strings.
coalSCC<- SCC %>%
  filter(grepl("Coal",EI.Sector),grepl("Comb",EI.Sector)) %>%
  select(SCC)

## Create a data frame with the total emissions from coal combustion by year
coalTotals<-NEI %>%
  filter(SCC %in% coalSCC[,1]) %>%
  group_by(year) %>%
  summarise(total=sum(Emissions))
  

# Make the plot.  Note: we use thousands of tons on the y-axis for readability.

coalplot<-ggplot(coalTotals,aes(year,total))+
  geom_bar(stat="identity")+
  ggtitle("Total PM2.5 Emissions from Coal Combustion, 1999-2008")+
  scale_x_discrete(name="Year",limits=coalTotals$year)+
  scale_y_continuous(name="Emissions in Thousands of Tons",breaks=(1:6)*1e+05,labels=(1:6)*1e+02)

#Save the plot
ggsave("plot4.png",coalplot,device="png")
