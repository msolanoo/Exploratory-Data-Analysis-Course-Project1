#*****************************************************************************
#Reading the text file: probably one of the most important steps after the generation of the plot of couse!!

	# The reason, the data text table is read with the following read.csv command and with the specified parameters is explained as follows...Taken from "http://science.nature.nps.gov/im/datamgmt/statistics/r/fundamentals/manipulation.cfm"

	#There are 2 parts to dealing with missing values. First, during data import, only blanks are guaranteed to default to missing values, so you may need to specify na.strings or otherwise tell R what to treat as missing values. For example, if your csv file uses the SAS convention of dot for missing values:
		# read.csv("MyData.csv",header=TRUE,na.strings="?").  Since there is a bunch of values with "?" then, we need to set them up to NA.

	#Note that the parameter is na.strings plural! If you have more than one indicator for missing values in your file, na.strings accepts a vector of strings, which is easiest to specify with the c() function:
		# read.csv("MyDataHasHoles.csv",header=TRUE,na.strings=c(".","....",".....","****","*****"," "))

	#Second, R is careful about handling missing values. By default, any operation (including well-written functions) that operates on an object with missing values will return a missing value. For example, mean(x) will return NA if any of the values of x are missing. That helps prevent missing values from sneaking past you through several steps of an analysis: the first operation that includes at least one NA will return NA. If you want summary statistics computed on the non-missing values, you can use na.rm=TRUE:
		# mean(x,na.rm=TRUE)

	#nrows: Specifying the 'nrows' argument doesn't necessary make things go faster but it can help a lot with memory usage. R doesn't know how many rows it's going to read in so it first makes a guess, and then when it runs out of room it allocates more memory. The constant allocations can take a lot of time, and if R overestimates the amount of memory it needs, your computer might run out of memory.  Taken from "http://www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html"

	#check.names: Unless you specify check.names=FALSE, R will convert column names that are not valid variable names (e.g. contain spaces or special characters or start with numbers) into valid variable names, e.g. by replacing spaces with dots.  Taken from "Unless you specify check.names=FALSE, R will convert column names that are not valid variable names (e.g. contain spaces or special characters or start with numbers) into valid variable names, e.g. by replacing spaces with dots"

	#stringsAsFactors=FALSE: this allows the values that are numeric from being captured as plain text and causing issues in calculates when the histogram is created

			HousePower <- read.csv("household_power_consumption.txt", header=T, sep=';', na.strings="?", nrows=2075259, check.names=FALSE, stringsAsFactors=FALSE) #FILE IS READ HERE



#*****************************************************************************
#Need to convert the column date to date format
			HousePower$Date <- as.Date(HousePower$Date, format="%d/%m/%Y") #DATE IS CONVERTED HERE



#*****************************************************************************
#We need to subset the data in a way that we only select data for the 2 days required in the project
			HousePowerSample <- subset(HousePower, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))  # HERE WE DO THE SAMPLING FROM THE MAIN DATAFRAME
			rm(HousePower) # GOOD PRACTICE IS TO REMOVE WHATEVER IS NOT IN USE FROM MEMORY, IN THIS CASE UNLOAD THE ORIGINAL DATAFRAME...GOOD FOR PERFORMANCE.



#*****************************************************************************
#A column with Date/Times is generated
DateTime <- paste(as.Date(HousePowerSample$Date), HousePowerSample$Time) # A vector is created usign Date and Time from the DataFrame
HousePowerSample$DateTime <- as.POSIXct(DateTime) # The converted DateTime is added to the original DataFrame with the proper format.  This is used widely in Plot 2, 3 and 4



#*****************************************************************************
#Plotting the plots in same plot window
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(HousePowerSample, {
    plot(Global_active_power~DateTime, type="l", 
         ylab="Global Active Power", xlab="")
    plot(Voltage~DateTime, type="l", 
         ylab="Voltage", xlab="datetime")
    plot(Sub_metering_1~DateTime, type="l", 
         ylab="Energy sub metering", xlab="")
    lines(Sub_metering_2~DateTime,col='Red')
    lines(Sub_metering_3~DateTime,col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Global_reactive_power~DateTime, type="l", 
         ylab="Global_reactive_power",xlab="datetime")
})



#*****************************************************************************
#Save the time based Plot to a file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
