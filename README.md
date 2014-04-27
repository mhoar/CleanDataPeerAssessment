Clean Data Project 
========================================================

The data for this project can be downloaded here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The CodeBook.Rmd file contains the description of data, variables, and procedures for transforming the raw data above into the tidy data.  

The tidy_data.txt file contains the tidy data in a comma separated text file. 

After downloading and extracting the Dataset.zip file, all files with relevant data were moved to a sub directory of the working directory: 
./data/X_test.txt
./data/X_train.txt
./data/Y_test.txt
./data/Y_train.txt
./data/subject_test.txt
./data/subject_train.txt
./data/features.txt
./data/activity_labels.txt

The run_analysis.R file contains the script to transform data into tidy data once the files.  
NOTE: the script assumes the files have been downloaded, extracted, and placed in the ./data directory.  

