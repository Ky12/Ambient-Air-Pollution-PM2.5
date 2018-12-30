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
code.coal <- code[grep("[Cc]oal", code$EI.Sector),]
scc.coal <- subset(scc, scc$SCC %in% code.coal$SCC)
scc.code.coal <- merge(x = scc.coal, y = code.coal, by.x = "SCC", by.y = "SCC")
emissions_coal <- subset(scc.code.coal, select = c(year, Emissions))
ann_scc.code.coal <- aggregate(emissions_coal$Emissions, by = list(year = emissions_coal$year), FUN = sum)

#plotting a graph
png(filename = "plot4.png")
ggplot(ann_scc.code.coal, aes(factor(year),x)) + geom_bar(stat = "identity" ,color = "steelblue", fill = "steelblue") + labs(title = "Total Emissions form Coal sources 1999-2008", x="Year", y="Total Emissions [Tons]")
dev.off()