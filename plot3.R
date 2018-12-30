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
scc <- transform(scc, type = as.factor(type))
emissionsType_BC <- subset(scc, fips == "24510", select = c(year, type, Emissions))
ann_emissions_allType <- aggregate(emissionsType_BC$Emissions, by = list(type = emissionsType_BC$type, year = emissionsType_BC$year), FUN = sum)

#plotting a graph
png(filename = "plot3.png")
ggplot(ann_emissions_allType, aes(year,x)) + geom_bar(stat = "identity",color = "steelblue", fill = "steelblue")+ facet_grid(.~type) + labs(title = "Annual Emissions in US by Type", x = "Type of Emission", y = "Total Annual Emissions [Tons]")
dev.off()