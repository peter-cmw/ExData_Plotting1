#download dataset if not exists
loadDataset <- function() {
    
    datasetFilenameZip <- 'ElectricPowerConsumption.zip';
    datasetFilename <- 'household_power_consumption.txt';
    if (!file.exists(datasetFilename)) {
        #download dataset if not exists
        if (!file.exists(datasetFilenameZip)) {
            download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
                          datasetFilenameZip, mode='wb');
        }
        #unzip dataset
        unzip(datasetFilenameZip);
    }    
    
    #load dataset
    hpc = read.table(datasetFilename, sep=';', header = TRUE, na.strings = '?'
                     , colClasses = c('character','character'
                                      ,'numeric','numeric','numeric'
                                      ,'numeric','numeric','numeric'
                                      ,'numeric'), stringsAsFactors = FALSE);
    
    #filterOutDates
    hpc <- hpc[hpc$Date == '1/2/2007' | hpc$Date == '2/2/2007', ]
    #convert to date time
    hpc$datetime <- strptime(paste0(hpc$Date, hpc$Time), format='%d/%m/%Y%H:%M:%S');
    hpc
}

doPlot <- function(hpc) {
    par(mfrow = c(2,2));
    
    #plot2
    plot(hpc$datetime, hpc$Global_active_power,  ylab = "Global Active Power (kilowatts)", xlab=NA, type='n');
    lines(hpc$datetime, hpc$Global_active_power);
    
    #plot Voltage
    
    plot(hpc$datetime, hpc$Voltage,  ylab = "Voltage", xlab='datetime', type='n');
    lines(hpc$datetime, hpc$Voltage);
    
    #plot3
    
    srcY <- c(hpc$Sub_metering_3, hpc$Sub_metering_1,hpc$Sub_metering_2);
    y <- c(min(srcY), max(srcY));
    plot(c(min(hpc$datetime), max(hpc$datetime)), y, ylab = "Energy sub metering", xlab=NA,  type='n');
    lines(hpc$datetime, hpc$Sub_metering_1);
    lines(hpc$datetime, hpc$Sub_metering_2, col='red');
    lines(hpc$datetime, hpc$Sub_metering_3, col='blue');
    legend('topright', lty = 1, col = c('black', 'red', 'blue'), 
           legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))
    
    #plot reactive power
    
    plot(hpc$datetime, hpc$Global_reactive_power,  ylab = "Global_reactive_power",  xlab='datetime', type='n');
    lines(hpc$datetime, hpc$Global_reactive_power);
}

hpc <- loadDataset();

#output to png
png('Plot4.png');
doPlot(hpc);
dev.off();

#output to screen
doPlot(hpc)

