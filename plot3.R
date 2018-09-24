require(ggplot2)
require(dplyr)

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

# Extract the data for Baltimore, group by year and type, and then compute totals
NEIBaltimore<- NEI %>%
  filter(fips=="24510") %>%
  group_by(year,type) %>%
  summarise(total=sum(Emissions))

#Make the plot

BaltimorePlot<-ggplot(NEIBaltimore,aes(year,total,colour=type))+
  geom_line(size=1)+
  labs(title="PM2.5 Emissions by Type in Baltimore, 1999-2008",color="Type")+
  ylab("Tons")+
  scale_x_discrete(name="Year",limits=NEIBaltimore$year)
  
#Save the plot
ggsave("plot3.png",BaltimorePlot,device="png")