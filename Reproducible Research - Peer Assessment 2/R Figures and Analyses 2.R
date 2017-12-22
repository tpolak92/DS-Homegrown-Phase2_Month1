

activityData <- read.csv('activity.csv')
library(ggplot2)
library(scales)
library(Hmisc)

install.packages("Hmisc")

str(activityData)

stepsByDay <- activityData %>%
  na.omit() %>% 
  group_by(date) %>% 
    summarise(TotalSteps = sum(steps))

ggplot(stepsByDay,aes(x=TotalSteps)) +
  geom_histogram(binwidth = 500)



mean(stepsByDay$TotalSteps)
median(stepsByDay$TotalSteps)

str(stepsByDay)

averageStepsPerTimeBlock <- aggregate(x=list(meanSteps=activityData$steps), by=list(interval=activityData$interval), FUN=mean, na.rm=TRUE)

stepsByTimeBlock <- activityData %>% 
  na.omit() %>% 
  group_by(interval) %>% 
    summarise(TotalSteps = sum(steps))

mean(stepsByTimeBlock$TotalSteps)

numMissingValues <- length(which(is.na(activityData$steps)))

activityDataImputed <- activityData

# Find the NA positions
na_pos <- which(is.na(activityData$steps))

# Create a vector of means
mean_vec <- rep(mean(activityData$steps, na.rm=TRUE), times=length(na_pos))

# Replace the NAs by the means
activityDataImputed[na_pos, "steps"] <- mean_vec

# Compute the total number of steps each day (NA values removed)
sum_data <- aggregate(activityDataImputed$steps, by=list(activityDataImputed$date), FUN=sum)

# Rename the attributes
names(sum_data) <- c("date", "total")

# Compute the histogram of the total number of steps each day
hist(sum_data$total, 
     breaks=seq(from=0, to=25000, by=2500),
     col="blue", 
     xlab="Total number of steps", 
     ylim=c(0, 30), 
     main="Histogram of the total number of steps taken each day\n(NA replaced by mean value)")

head(activityDataImputed)
