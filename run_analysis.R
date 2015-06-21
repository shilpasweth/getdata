## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set
## 2. Extracts only the measurements on the mean and standard deviation for each measurement
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

if (!require("data.table"))
{
  install.packages("data.table")
}
if (!require("reshape2"))
{
  install.packages("reshape2")
}
require("data.table")
require("reshape2")



activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]  #Loads the activity labels into activity_labels
features <- read.table("./UCI HAR Dataset/features.txt")[,2]  #Loads the data column names into features
extract_features <- grepl("mean|std", features)  #Extracts the measurements on the mean and standard deviation for each measurement from features into extract_features



X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")  #Loads the X_test data into X_test
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")  #Loads the y_test data into y_test
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")  #Loads the subject_test data into subject_test
names(X_test) <- features  #Loads data column names into X_test



X_test <- X_test[,extract_features]  #Extracts the measurements on the mean and standard deviation for each measurement into X_test
y_test[,2] <- activity_labels[y_test[,1]]  #Loads activity labels into y_test
names(y_test) <- c("Activity_ID", "Activity_Label")  #Loads data column names into y_test
names(subject_test) <- "subject"  #Loads data column names into subject_test

test_data <- cbind(as.data.table(subject_test), y_test, X_test)  #Binds data of X_test and y_test together into test_data



X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")  #Loads the X_train data into X_train 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")  #Loads the y_train data into y_train
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")  #Loads the subject_train data into subject_train
names(X_train) <- features  #Loads data column names into X_train



X_train <- X_train[,extract_features]  #Extracts the measurements on the mean and standard deviation for each measurement into X_train
y_train[,2] <- activity_labels[y_train[,1]]  #Loads activity labels into y_train 
names(y_train) <- c("Activity_ID", "Activity_Label")  #Loads data column names into y_train
names(subject_train) <- "subject"  #Loads data column names into subject_train

train_data <- cbind(as.data.table(subject_train), y_train, X_train)  #Binds data of X_train and y_train together into train_data



data <- rbind(test_data, train_data)  #Merges test and train data together into data
id_labels <- c("subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = data_labels)



tidy_data <- dcast(melt_data, subject + Activity_Label ~ variable, mean)  #Applies mean function to dataset
write.table(tidy_data, file = "./tidy_data.txt",row.names=FALSE)  #Creates tidy data set called tidy_data