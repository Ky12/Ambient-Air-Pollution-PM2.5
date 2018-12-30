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
code.motor <- code[grep("[Vv]eh", code$Short.Name),]
scc.motor <- subset(scc, scc$SCC %in% code.motor$SCC)
scc.code.motor <- merge( x = scc.motor, y = code.motor, by.x = "SCC", by.y = "SCC")
emissions_motor_BC <- subset(scc.code.motor, fips == "24510", select = c(year, Emissions))
ann_scc.code.motor_BC <- aggregate(emissions_motor_BC$Emissions, by = list(year = emissions_motor_BC$year), FUN = sum)

#plotting a graph
png(filename = "plot5.png")
ggplot(ann_scc.code.motor_BC, aes(factor(year),x)) + geom_bar(stat = "identity" ,color = "steelblue", fill = "steelblue") + labs(title = "Total Emissions form Motorvehicles 1999-2008", x="Year", y="Total Emissions [Tons]")
dev.off()