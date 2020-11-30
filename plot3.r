#JH Datascience - exploratory data - week 1 
#plot 3

#packages

library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)
#load the data

fileurl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("household_power_consumption.txt")){
        download.file(fileurl,destfile="/HPCdata",method="curl")
        unzip("HPCdata.zip")}

filedest <- paste0(getwd(),"/household_power_consumption.txt")

HPCdata <- read.table("household_power_consumption.txt",sep=";",header=T)

#select date range and apply date and time formatting
HPCdata1 <- HPCdata

HPCdata1$Time <- hms::as_hms(as.character(HPCdata1$Time))
HPCdata1$Date <- as.Date(as.character(HPCdata1$Date), "%d/%m/%Y")

#Select relevant date range & remove unnecessary data

HPC_slim <- filter(HPCdata1,Date >= ymd("2007-02-01"))
HPC_slim <- filter(HPC_slim, Date <= ymd("2007-02-02"))

rm(HPCdata,HPCdata1)

#prepare data
HPC_slim <- HPC_slim %>% mutate(Date.time = paste0(Date," ",Time))
HPC_slim$Date.time <- ymd_hms(HPC_slim$Date.time)

HPC_slim$Sub_metering_1 <- as.numeric(as.character(HPC_slim$Sub_metering_1))
HPC_slim$Sub_metering_2 <- as.numeric(as.character(HPC_slim$Sub_metering_2))
HPC_slim$Sub_metering_3 <- as.numeric(as.character(HPC_slim$Sub_metering_3))

#create ping file
png("plot3.png", width = 480, height = 480)
#plot data

plot(HPC_slim$Date.time,HPC_slim$Sub_metering_1,
     type="l",
     xlab= "",
     ylab = "Energy submetering",
     col="black") 
lines(HPC_slim$Date.time,HPC_slim$Sub_metering_2,lty=1, type="l", col="red")
lines(HPC_slim$Date.time,HPC_slim$Sub_metering_3,lty=1, type="l",col="blue")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("Black","Red","Blue"),
       lty=1,cex=0.75)
#close plot 
dev.off()

