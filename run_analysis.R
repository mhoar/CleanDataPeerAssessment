############## Data Tool Box Assignment

xtest <-read.table("./data/X_test.txt")
xtrain <- read.table("./data/X_train.txt")
xdata <- rbind(xtest, xtrain)

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

head(xdata.new)

rm(col.list, feat.list, xdata)
rm(features.logical, features.data)

############## Get activity data from Y set of data

ytest <- read.table("./data/Y_test.txt")
ytrain <- read.table("./data/Y_train.txt")
ydata <- rbind(ytest, ytrain)
colnames(ydata) <- "actID"

rm(xtest, xtrain, ytest, ytrain)  ##### remove to free memory

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

####### Get Subject IDs
sbj_test <- read.table("./data/subject_test.txt")
sbj_train <- read.table("./data/subject_train.txt")
sbj_ids <- rbind(sbj_test, sbj_train)
colnames(sbj_ids) <- "sbjID"
class(sbj_ids)

rm(sbj_test, sbj_train)

######## put the data all together
data.set <- cbind(sbj_ids, ydata, xdata.new) 

###          View(data.set)

###xt compress data into means by sbjID and actID to make tidy.data
tidy.data <- aggregate( . ~ sbjID + activity, data.set, mean)
tidy.data <- tidy.data[order(tidy.data$sbjID), ]
dim(tidy.data)

head(tidy.data, n=3)

######  Create data file for tidy.data as a txt file
write.table(tidy.data, "./data/tidy_data.txt", sep=",", row.names=FALSE)
