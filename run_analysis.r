 ## Getting and Cleaning data project

## Download dataset and unzip into working directory
if(!file.exists("./data/Samsung")){dir.create("./data/Samsung")}
setwd("./data/Samsung")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,"samsung.zip")
unzip("samsung.zip",exdir=".")
dir() ## Examine downloaded files

## Rename folder and examine files in folder
file.rename("UCI HAR Dataset","UCI"); dir("./UCI"); dir("./UCI/train"); dir("./UCI/test")

## Load training,testing set, and labels
train <- read.table("./UCI/train/X_train.txt")
train_label <- read.table("./UCI/train/y_train.txt")
test <- read.table("./UCI/test/X_test.txt")
test_label <- read.table("./UCI/test/y_test.txt")

## Load subjects identifier, features and activiity labels
trainId <- read.table("./UCI/train/subject_train.txt")
testId <- read.table("./UCI/test/subject_test.txt")
actiLabel <- read.table("./UCI/activity_labels.txt")
features <- read.table("./UCI/features.txt")

## Merge test and train dataset
merged <- rbind(train,test);dim(merged)

## Merge train and test sets subject Identifier and label
merged_label <- rbind(train_label,test_label)
merged_Id <- rbind(trainId,testId)

## Create a subset with features containing mean and std
merged1 <- merged[,grep("mean\\()|std\\()",features$V2)]

## Name the features in the subset with the appropriate name in the features table
colnames(merged1) <- features[grep("mean\\()|std\\()",features$V2),2]

## Remove parenthesis from the variable names
names(merged1) <- gsub("\\(|\\)", "",names(merged1))

## Create activity variable with activity label table
merged1$Activity <- factor(merged_label$V1, levels=actiLabel$V1, labels=actiLabel$V2)

## Add the subjects Id to the merged train and test dataset(merged1)
merged1$Subject <- merged_Id$V1
merged1 <- merged1[order(merged1$Subject),]

## Remove unwanted objects from memory
rm(test,train,merged,features,test_label,train_label,testId,
   trainId,actiLabel,merged_Id,merged_label)

## Create a tidy dataset with the average of each variable for each activity for each subject
library(data.table)
merged1 <- as.data.table(merged1)
merged2 <- merged1[,lapply(.SD, mean), by = .(Subject=Subject, Activity=Activity)]

## Save output dataset into txt file
write.table(merged2, file="merged2.txt", row.names=FALSE)


