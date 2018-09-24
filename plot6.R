require(dplyr)
require(reshape2)
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

## Create a vector of Source Classification Codes corresponding to motor vehicle sources
## The easiest way to identify these, in my opinion, is by looking at the variable SCC.Level.Two
## and searching for the string "Vehicle"

SCCVehicles<- SCC %>% 
  filter(grepl("Vehicle",SCC.Level.Two)) %>%
  select(SCC)

# We now extract the data from Baltimore and LA County, with the SCC corresponding to motor vehicles,
# and compute the totals
# We also add a new column "change", which measures the emissions in each year as a percentage of the 1999 emissions for that particular region.


NEIVehiclesBaltimoreLA<- NEI %>% filter(SCC %in% SCCVehicles[,1], fips == "24510" | fips == "06037" ) %>%
  group_by(year,fips) %>%
  summarise(total=sum(Emissions)) %>%
  group_by(fips) %>%
  mutate(change=100*total/first(total))

# Since it appears to be tricky to draw two plots using values from different columns, 
# we then melt the data before plotting (there may be an easier way of doing this, but I cannot find one).

melted<-melt(NEIVehiclesBaltimoreLA,id.vars = c("year","fips"))

##As we are going to plot both total emissions and emissions as a percentage, we create a vector of plot names
plotnames<-c(total="Total Emissions in tons",change="Emissions as a percentage \n of 1999 values")

##Make the plots

ComparisonPlot<-ggplot(melted,aes(year,value,colour=fips))+
  labs(title="PM2.5 Emissions in Baltimore City and LA County, 1999-2008",y="",x="Year",color="Region")+
  geom_line(size=1)+
  facet_wrap(.~variable,scales="free",labeller=labeller(variable=plotnames))+
  scale_x_discrete(name="Year",limits=melted$year)+
  scale_color_discrete(labels=c("LA County", "Baltimore City"))

##Save the plots
ggsave("plot6.png",ComparisonPlot,device="png")
