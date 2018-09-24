require(dplyr)

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

# Extract the data for Baltimore, group by year, and construct table of totals

NEIBaltimoreTotals<-NEI %>%
  filter(fips=="24510") %>%
  group_by(year) %>%
  summarise(total=sum(Emissions))
  
#Make the plot

barplot(NEIBaltimoreTotals$total,names.arg=NEIBaltimoreTotals$year,main="Total PM2.5 Emissions in Baltimore, all sources", ylab="Tons",xlab="Year",yaxt="n")

# Change the y-axis

axis(2,at=(0:4)*1e+03,labels=c(0,1000,2000,3000,4000) )

#Save the plot
dev.copy(png, file = "plot2.png")
dev.off()
