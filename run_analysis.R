run_analysis<-function(){
    library(dplyr)
    ##read in the data, assuming your in the Samsung Data working directory
    activities<-read.table('activity_labels.txt')
    features<-read.table('features.txt')
    x_test<-read.table('test/X_test.txt')
    y_test<-read.table('test/y_test.txt')
    subject_test<-read.table('test/subject_test.txt')
    x_train<-read.table('train/X_train.txt')
    y_train<-read.table('train/y_train.txt')
    subject_train<-read.table('train/subject_train.txt')
    ##label these to spare the headache after columnbinding...
    colnames(subject_test)<-"Subject"
    colnames(subject_train)<-"Subject"
    colnames(y_train)<-"Activity"
    colnames(y_test)<-"Activity"
    test_data<-cbind(subject_test,y_test,x_test)
    train_data<-cbind(subject_train, y_train, x_train)
    mergedData<-merge(test_data,train_data, all=TRUE)
    ##the column names from "features" meet the "descriptive variable names" criterion in my book
    colnames(mergedData)[3:ncol(mergedData)]<-as.character(features[[2]])
    ##so do the labels from "activities"
    mergedData$Activity<-sapply(mergedData$Activity,function(activity){activity=activities[activity,2]})
    ##now extract mean and std measurements using regexes, put this last since it's easiest with all columns appropriately named. keep the subject and activity columns
    mergedData<-mergedData[,c(1,2,grep(".*mean|.*std", names(mergedData)))]
    ##get rid of those meanFreq() measurements...don't want those
    mergedData<-mergedData[,!grepl(".*Freq", names(mergedData))]
    ##Now we've got the dataset as specified in 1-4, time to take the sums of the variables per subject and activity...use dplyr
    tidyData_tbl<-tbl_df(mergedData)
    tidyData<-tidyData_tbl%>%
        group_by(Subject,Activity)%>%
        ##note this function does not appear in dplyr<0.2
        summarise_each(funs(mean))
    #write that tidy dataset!
    write.table(tidyData,file="tidy_samsung_data.txt", row.names =FALSE)
    
}
