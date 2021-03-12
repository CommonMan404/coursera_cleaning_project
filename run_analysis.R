#This is the script for the getting and cleaning coursera course project

#This bit downloads the data, unzips it and sets the wd, not necessary if you have the files
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","samsungfiles.zip")
#unzip("samsungfiles.zip")
#setwd("UCI HAR Dataset")

#gets all the data and reads it in
library(dplyr)
setwd("train")
trainingset <- read.table("x_train.txt")
trainingsubjects <- read.table("subject_train.txt")
traininglabels <- read.table("y_train.txt")
setwd('..')
setwd("test")
testset <- read.table("x_test.txt")
testsubjects <- read.table("subject_test.txt")
testlabels <- read.table("y_test.txt")
setwd('..')
features <- read.table("features.txt")
activity_descriptions <- read.table("activity_labels.txt")

#combining the sets
labels <- rbind(testlabels,traininglabels)
subject <- rbind(testsubjects, trainingsubjects)
df <- rbind(testset,trainingset)

#gets the label descriptions and replaces the numbers with them
for (i in 1:6) {
  tmp <- i
  labels[,1] <- gsub(tmp, activity_descriptions[tmp,2], labels[,1])
}


#get the needed column numbers and names from the features txt
columns <- sort(c(grep("mean", features[,2], ignore.case = TRUE),grep("std", features[,2], ignore.case = TRUE)))
columnnames <- features[columns,2]

#subset df to only needed columns and set column names
df <- df[,columns]
colnames(df) <- columnnames
colnames(labels) <- "activity"
colnames(subject) <- "subject"

tidyset <- cbind(subject,labels,df)

#creates a second dataset that has the means for each variable by subject and activity
tidysetmeans <- tidyset %>%
      group_by(activity,subject) %>%
      summarise_each(funs(mean))

#writes the second set

write.table(tidysetmeans, "tidydataset.txt", row.names = FALSE)
#removing some of the clutter left behind
rm(testlabels)
rm(traininglabels)
rm(testsubjects)
rm(trainingsubjects)
rm(testset)
rm(trainingset)
rm(features)
rm(labels)
rm(subject)
rm(columnnames)
rm(columns)
rm(i)
rm(tmp)
rm(df)
rm(activity_descriptions)


