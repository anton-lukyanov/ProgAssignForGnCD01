library(plyr)
library(reshape2)

#read feature names
features<-read.table("features.txt", sep="")

#find names containig  "mean()" or "std()" and without "Freq"
feat<-(grepl("mean()",features$V2) | grepl("std()",features$V2)) & ! grepl("Freq",features$V2)
#read activity labels for the further joining
act<-read.table("activity_labels.txt", sep="")

#read training set
train_x<-read.table("X_train.txt", sep="")
train_subj<-read.table("subject_train.txt", sep="")
train_act_p<-read.table("y_train.txt", sep="")

#change activity type from number label to descriptive label
train_act<-join(train_act_p,act, by="V1",type="left")$V2
names(train_x)<-features$V2

#drop off columns withour "mean" and "std" in names
train_x<-subset(train_x[,feat])

#create table with features enriched with subject and activity type
train<-train_x
train$activity<-train_act
names(train$activity)<-"activity"

train$subject<-as.numeric(unlist(train_subj))
names(train$subject)<-"subject"


#same algo for the test set
test_x<-read.table("X_test.txt", sep="")
test_subj<-read.table("subject_test.txt", sep="")
test_act_p<-read.table("y_test.txt", sep="")
test_act<-join(test_act_p,act, by="V1",type="left")$V2
names(test_x)<-features$V2
test_x<-subset(test_x[,feat])

test<-test_x
test$activity<-test_act
names(test$activity)<-"activity"

test$subject<-as.numeric(unlist(test_subj))
names(test$subject)<-"subject"

rownames(test)<-as.numeric(rownames(test))+as.numeric(nrow(train))

#merge test and trainig sets
new_set<-rbind(train,test)

#create independent tidy data set with the average of each variable for each activity and each subject
set<-melt(new_set,id=c("activity","subject"),variable.name="variable",
          value.name="measurement")

tidy_ds<-aggregate(measurement ~ activity + subject + variable, data = set, FUN= "mean" )

write.table(tidy_ds,file="tidy_ds.txt",row.name=FALSE)