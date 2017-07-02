library(dplyr)
library(reshape2)
#Load the datasets
Testdata<- read.table("./UCI HAR Dataset/test/X_test.txt")
Traindata<- read.table("./UCI HAR Dataset/train/X_train.txt")

#Load the subjects and activities of both
testsubject<- read.table("./UCI HAR Dataset/test/subject_test.txt")
testactivity<- read.table("./UCI HAR Dataset/test/y_test.txt")
trainactivity<- read.table("./UCI HAR Dataset/train/y_train.txt")
trainsubject<- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Load the featurs and activity labels
features<- read.table("./UCI HAR Dataset/features.txt")
activity<- read.table("./UCI HAR Dataset/activity_labels.txt")

#Merge the datasets
mergedData<- merge(Traindata,Testdata,all = TRUE)
mergedsubjects<- merge(testsubject, trainsubject, all = TRUE)
mergedactivity<- rbind(testactivity,trainactivity)
colnames(mergedactivity)<- c("Activity")
colnames(mergedsubjects)<-c("Subjects")


#assign the colnames as the features
colnames(mergedData)<- as.character(features[,2])

#select The datasets with regard to only the mean and standard deviation
stdmean<-grep(".*mean.*|.*std.*", names(mergedData))
mergedData<- mergedData[,stdmean]
mergedData<-cbind(mergedData,mergedsubjects, mergedactivity)

#Convert data set to factors
mergedData$Subjects<- as.factor(mergedData$Subjects)
mergedData$Activity<- factor(mergedData$Activity, levels = c(1,2,3,4,5,6), labels = c('WALKING',	'WALKING_UPSTAIRS',	'WALKING_DOWNSTAIRS',	'SITTING',	'STANDING',	'LAYING'))


#creating the tidy data setwith average of each activity and subject
mergedDatamelt<- melt(mergedData, id=c("Activity","Subjects"))
mergeddcast<-dcast(mergedDatamelt, Subjects+Activity~variable, mean)
write.table(mergeddcast, "tidydata.txt", row.names = FALSE, quote = FALSE)
