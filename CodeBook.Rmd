Clean Data Project 
========================================================

The data for this project can be downloaded here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

After extracting files, see README.txt file in the UCI HAR dataset directory for overview of all files and features_info.txt for variable information.  

First, putting the X data sets together from test and train.  Bind the rows with test on top and train below.

```{r}
xtest <-read.table("./data/X_test.txt")
xtrain <- read.table("./data/X_train.txt")
xdata <- rbind(xtest, xtrain)
```

Next, access features.txt in order to collect column names for all the X numeric data.  Grep the feature values to extract those that include "mean" and "std".  However, those with "meanFreq" are to be redacted. The <b>grepl</b> function is used to return a logical vector that can be easily broken into subsets.  Finally, the features are temporarily stored in a vector which is used to create the column names for the X data.  

```{r }
features.data <- read.table("./data/features.txt")
colnames(features.data) <- c("featuresID", "featureActivity")
head(features.data)

######## Get columns with means and std including their column ID
features.logical <- features.data[grepl("mean|std",features.data[ , 2]), c(1,2)]
########## Get the meanFreqs out
features.logical <- features.logical[!grepl("Freq",features.logical[ , 2]), c(1,2)]

###          View(features.logical)

########### construct xdata with new, simple data 
col.list <- features.logical[ , "featuresID" ]
feat.list <- features.logical[ , "featureActivity"]

xdata.new <- xdata[ , col.list]
colnames(xdata.new) <- feat.list
```
Periodically, clean up the garbage.  So, remove temporary vectors and data frames.  

```{r}

rm(col.list, feat.list, xdata)
rm(features.logical, features.data)
```
Get Y data in similar fashion as above.  First, Y test; then, Y train bounded as test on top and train on bottom.  Rename column as "actID."  Finally, collect the garbage to free memory.

```{r}
############## Get activity data from Y set of data

ytest <- read.table("./data/Y_test.txt")
ytrain <- read.table("./data/Y_train.txt")
ydata <- rbind(ytest, ytrain)
colnames(ydata) <- "actID"

rm(xtest, xtrain, ytest, ytrain)  ##### remove to free memory

```
Since the actID is merely a number value corresponding to the activity_labels.txt file, the two fields can be matched together to form a category with more usefull activities listed ("LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS").  There has to be a more efficient way to match these values other than the subsequent for loop.  I tried replace, match, and merge to no avail.  Given more time, I could try sub or other methods later.

```{r}
##### Get Activity Labels
act_labels <- read.table ("./data/activity_labels.txt")
colnames(act_labels) <- c("actID", "activity")

for(i in 1:nrow(ydata))
{
  if (ydata[i, 1] == 1)
    ydata[ i, 1 ] <- as.character(act_labels[ 1, 2])
  else if (ydata[i, 1] == 2)
    ydata[ i, 1 ] <- as.character(act_labels[ 2, 2])
  else if (ydata[i, 1] == 3)
    ydata[ i, 1 ] <- as.character(act_labels[ 3, 2])
  else if (ydata[i, 1] == 4)
    ydata[ i, 1 ] <- as.character(act_labels[ 4, 2])
  else if (ydata[i, 1] == 5)
    ydata[ i, 1 ] <- as.character(act_labels[ 5, 2])
  else 
    ydata[ i, 1 ] <- as.character(act_labels[ 6, 2])
}

############# change colnames to activity
colnames(ydata) <- "activity"

head(ydata)

```
Now, actives and data for each are captured.  So, get subjects.  There is a subject test and train text file.  Once each set is opened, bind them together same as other data sets: test on top, train on bottom.  And, rename column sbjID.  Also, free up memory.  

```{r}

####### Get Subject IDs
sbj_test <- read.table("./data/subject_test.txt")
sbj_train <- read.table("./data/subject_train.txt")
sbj_ids <- rbind(sbj_test, sbj_train)
colnames(sbj_ids) <- "sbjID"
rm(sbj_test, sbj_train)
```

At least, these three data frames can be bound column wise to form complete data set.  The order is: subject ID, activity names, data values...  The sbjID is a discrete, numeric value used to identify each subject.  The activity variable is a character, categorical value that defines each activity for which data for captured.  Each following column of continuous, discrete data is either a mean or standard deviation (std) of the data captured for each activity.  The column name gives an idea of how the data was captured (e.g., tBodyAcc or tGravityAcc).  See features_info.txt for more information on mean and std data.  

```{r}
######## put the data all together
data.set <- cbind(sbj_ids, ydata, xdata.new) 

###          View(data.set)
```
Time to tidy up the data just a bit more.  Use aggregate function to get the means of all data by sbjID and activity.  Then, order data by sbjID.  

```{r}

###xt compress data into means by sbjID and actID to make tidy.data
tidy.data <- aggregate( . ~ sbjID + activity, data.set, mean)
tidy.data <- tidy.data[order(tidy.data$sbjID), ]
dim(tidy.data)

head(tidy.data, n=3)
```

Export tidy.data as comma delimited text file.

```{r}
######  Create data file for tidy.data as a txt file
write.table(tidy.data, "./data/tidy_data.txt", sep=",", row.names=FALSE)
```



