
library(plyr)

## data downloaded and file preperation

## unzip the data after downloaded

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, "data_final.zip", method="curl")

if(!file.exists("./UCI HAR Dataset")) {

    unzip("data_final.zip")

}


## Reading Features Files:

TrainData  <- read.table("./cleaning data/UCI HAR Dataset/train/X_train.txt")

TestData  <- read.table("./cleaning data/UCI HAR Dataset/test/X_test.txt")

## Reading Activity Files

TrainActiv    <- read.table("./cleaning data/UCI HAR Dataset/train/Y_train.txt")

TestActiv     <- read.table("./cleaning data/UCI HAR Dataset/test/Y_test.txt")

## Reading Subject Files

TrainSub <- read.table("./cleaning data/UCI HAR Dataset/train/subject_train.txt")

TestSub  <- read.table("./cleaning data/UCI HAR Dataset/test/subject_test.txt")

## Reading Labels and features

activityLabels <- read.table("./cleaning data/UCI HAR Dataset/activity_labels.txt")

featuresNames  <- read.table("./cleaning data/UCI HAR Dataset/features.txt")



## 1. Merge the training and test sets to create one data set


## Merging the Feature Data

FeatureTRTS <- rbind(TrainData, TestData)


## Merging the Activity Data

ActivityTRTS <- rbind(TrainActiv, TestActiv)

## Merging Subject data

subjectData <- rbind(TrainSub, TestSub)

## set names to variables

names(subjectData)   <- "Subject"

names(ActivityTRTS) <- "Activity"

names(FeatureTRTS) <- featuresNames$V2

## Merging all datasets

MergeData <- cbind(FeatureTRTS, ActivityTRTS, subjectData)


## 2. Extract only the measurements on the mean and standard deviation for each measurement


## get only columns with mean() or std() in their names

mean_and_std_features <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]


## subset the desired columns

ColSelected <- c(as.character(mean_and_std_features), "subject", "activity" )

MergeData <- subset(MergeData, select=ColSelected)


# 3. Use descriptive activity names to name the activities in the data set


## update values with correct activity names

MergeData$Activity <- activityLabels[MergeData$Activity, 2]


## 4. Appropriately label the data set with descriptive variable names

names(MergeData) <-gsub("^t", "time", names(MergeData))

names(MergeData) <-gsub("^f", "frequency", names(MergeData))

names(MergeData) <-gsub("Acc", "Accelerometer", names(MergeData))

names(MergeData) <-gsub("Gyro", "Gyroscope", names(MergeData))

names(MergeData) <-gsub("Mag", "Magnitude", names(MergeData))

names(MergeData) <-gsub("BodyBody", "Body", names(MergeData))


# 5. From the data set in step 4, creates a second, independent tidy data set

# with the average of each variable for each activity and each subject.


TidyData <- ddply(MergeData, .(Subject, Activity), function(x) colMeans(x[, 1:66]))

write.table(TidyData, "tidy.txt", row.name=FALSE)

