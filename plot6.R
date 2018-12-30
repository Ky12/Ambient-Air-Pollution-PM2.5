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

emissions_motor_LA <- subset(scc.code.motor, fips == "06037", select = c(year, Emissions))
ann_scc.code.motor_LA <- aggregate(emissions_motor_LA$Emissions, by = list(year = emissions_motor_LA$year), FUN = sum)
ann_scc.code.motor_BC2 <- cbind(ann_scc.code.motor_BC, "City" = rep("Baltimore City",4))
ann_scc.code.motor_LA2 <- cbind(ann_scc.code.motor_LA, "City" = rep("Los Angeles County"))
ann_scc.code.motor_BCLA <- rbind(ann_scc.code.motor_BC2, ann_scc.code.motor_LA2)


#plotting a graph
png(filename = "plot6.png")
ggplot(ann_scc.code.motor_BCLA, aes(factor(year),x, col = City)) + geom_point(size = 4) + labs(title = "Comparision of Total Emissions form Motorvehicles in Baltimore City and Los Angeles 1999-2008", x="Year", y="Total Emissions [Tons]")
dev.off()
