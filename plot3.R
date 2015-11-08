## Checks to see if file with household data exists in working directory, downloads and extracts file if missing
if (!file.exists("household_power_consumption.txt")) {
	temp <- tempfile()
	download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
	unzip(temp, overwrite = TRUE)
	unlink(temp)
	rm(temp)
}

## Read in data for given dates: 2/1/2007 - 2/2/2007
header <- read.table("household_power_consumption.txt", header = FALSE, sep = ";", nrows = 1)
data <- read.table("household_power_consumption.txt", header = FALSE, sep = ";", na.strings = "?", skip = grep("1/2/2007", readLines("household_power_consumption.txt")), nrows = 2879)
colnames(data) <- unlist(header)
rm(header)

## Convert data col to dat format add column with date & time
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$DateTime <- strptime(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S")

## Plot a histogram
with(data, plot(DateTime,Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering", cex.lab = 0.75, cex.axis = 0.75))
with(data, points(DateTime,Sub_metering_2, type = "l", col = "red"))
with(data, points(DateTime,Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, cex = 0.75) 

## Copy graph to a png file
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()