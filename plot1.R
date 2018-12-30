#url for the dataset
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destfile <- "exdata_data_NEI_data.zip"

#downloading file from web and uzipping it
if(!file.exists(destfile)) {
  download.file(url, destfile = destfile)
  unzip(destfile)
}

#reading data into R
scc <- readRDS("summarySCC_PM25.rds")
code <- readRDS("Source_Classification_Code.rds")

#aggregating annual emmission values for the US
ann_emissions <- aggregate(scc$Emissions, by = list(year = scc$year), FUN = sum)

#plotting a graph
png(filename = "plot1.png")
plot(ann_emissions[,1], ann_emissions[,2],type = "o", xlab = "Year", ylab = "Total Annual Emissions [Tons]", main = "Total Annual Emissions in the US by Year", cex = 2, pch = 20, col = "blue", lwd = 3)
dev.off()