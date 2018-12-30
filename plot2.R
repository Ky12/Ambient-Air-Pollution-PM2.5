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

#aggregating annual emmission values for the Baltimore City
emissions_BC <- subset(scc, fips == "24510", select = c(year, Emissions))
ann_emissions_BC <- aggregate(emissions_BC$Emissions, by = list(year = emissions_BC$year), FUN = sum)

#plotting a graph
png(filename = "plot2.png")
plot(ann_emissions_BC$year, ann_emissions_BC$x, xlab = "Year", ylab = "Total Annual Emission [Tons]", main = "Total Annual Emissions in Baltimore City by Year", cex = 2, type = "o", pch = 20, col = "red", lwd = 3)
dev.off()

