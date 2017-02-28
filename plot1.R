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
    par(mfrow = c(1,1));
    hist(hpc$Global_active_power, col='red', xlab = "Global Active Power (kilowatts)", main="Global Active Power");
}

hpc <- loadDataset();

#output to png
png('Plot1.png');
doPlot(hpc);
dev.off();

#output to screen
doPlot(hpc)

