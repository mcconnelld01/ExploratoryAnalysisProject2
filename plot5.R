require(dplyr)
require(ggplot2)

## If one or other ot the necessary files does not exists, download and unzip the dataset
if(!file.exists("summarySCC_PM25.rds")|!file.exists("Source_Classification_Code.rds"))
{
  download.file(url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="temp.zip")
  unzip("temp.zip")
  file.remove("temp.zip")
}

# Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


## Create a vector of Source Classification Codes corresponding to motor vehicle sources
## The easiest way to identify these, in my opinion, is by looking at the variable SCC.Level.Two
## and searching for the string "Vehicle"

SCCVehicles<- SCC %>% 
  filter(grepl("Vehicle",SCC.Level.Two)) %>%
  select(SCC)

# We now extract the data from Baltimore with the SCC corresponding to motor vehicles,
# and compute the totals

NEIVehiclesBaltimore<- NEI %>% filter(SCC %in% SCCVehicles[,1], fips == "24510" ) %>%
  group_by(year) %>%
  summarise(total=sum(Emissions))

#Create the plot

BaltimoreVehiclesPlot<-ggplot(NEIVehiclesBaltimore,aes(year,total))+
  geom_bar(stat="identity")+
  ggtitle("Total PM2.5 Emissions from Motor Vehicles, Baltimore, 1999-2008")+
  scale_x_discrete(name="Year",limits=NEIVehiclesBaltimore$year)+
  scale_y_continuous(name="Emissions in Tons")

## Save as plot5.png
ggsave("plot5.png",BaltimoreVehiclesPlot,device="png")