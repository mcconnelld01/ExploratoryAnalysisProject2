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


## Create a table of total emissions by year
NEItotals<- NEI %>%
  group_by(year) %>%
  summarise(total=sum(Emissions))
  
#Make the plot
barplot(NEItotals$total,names.arg=NEItotals$year,main="Total PM2.5 Emissions from All Sources",ylab="Millions of Tons",xlab="Year",yaxt="n")
#Change the y-axis labels for readability
axis(2,at=(0:8)*1e+06,labels=0:8 )
#Save the plot
dev.copy(png, file = "plot1.png")
dev.off()