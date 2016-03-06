# Process data from a Human Activity Recognition dataset
# Created as assignment from Getting and Cleaning Data, a class on Coursera
# author: Christopher Anderson
#
# From the README included with the data:
# The experiments have been carried out with a group of 30 volunteers within
# an age bracket of 19-48 years. Each person performed six activities
# (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
# wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded
# accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial
# angular velocity at a constant rate of 50Hz. The experiments have been
# video-recorded to label the data manually. The obtained dataset has been
# randomly partitioned into two sets, where 70% of the volunteers was selected for
# generating the training data and 30% the test data.
#

library(reshape2)
library(dplyr)
library(data.table)

# Download and unzip the data
if (!file.exists("data")) dir.create("data")
if (!file.exists("data/HARdata.zip")) {
  fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  filepath <- "./data/HARdata.zip"
  download.file(fileurl, filepath, method="curl")
  unzip(filepath, exdir = "./data")
}

# Column names for our X data (features) and
# Column names for our y data (activity_labels)
features <- read.table("./data/UCI HAR Dataset/features.txt")[,2]
onlyMeanStd <- grepl("mean|std", features)
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")[,2]

# Load the training and test data
train_subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train_set <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
test_subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test_set <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

# Assign column names to X and subject data and
# Attach activity label column to y data
names(train_set) <- features
names(test_set) <- features
names(test_subject) <- "ID"
names(train_subject) <- "ID"
test_labels[,2] = activity_labels[test_labels[,1]]
names(test_labels) = c("Activity", "Description")
train_labels[,2] = activity_labels[train_labels[,1]]
names(train_labels) = c("Activity", "Description")

# Extract measurements on the mean and standard deviation
train_set_extract <- train_set[,onlyMeanStd]
test_set_extract <- test_set[,onlyMeanStd]

# Bind our data into data frames and
# Merge the test and train data
test_data <- cbind(data.frame(test_subject), test_labels, test_set_extract)
train_data <- cbind(data.frame(train_subject), train_labels, train_set_extract)
data = rbind(test_data, train_data)

# Preparing a new dataset
id_labels = c("ID", "Activity", "Description")
data_labels <- data %>%
  colnames() %>%
  setdiff(id_labels)
new_data <- data %>%
  melt(id = id_labels, measure.vars = data_labels) %>%
  dcast(ID + Activity ~ variable, mean)

# Write it as a csv
write.csv(file="new_data.csv", new_data)
