# script to collect, load, work, and clean data for the Course Project of the 'Getting and cleaning Data'



# settings ----------------------------------------------------------------

library(readr)   # reading and writing data
library(dplyr)   # manipulating data
library(tidyr)   # reshaping data
library(stringr) # string manipulation


# collecting data ---------------------------------------------------------

# folder with data
folder_name <- "UCI HAR Dataset"
folder_name_zip <- "UCI HAR Dataset.zip" 
# downloads data, if not present
if (!file.exists(folder_name)) {
    # download data
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, folder_name_zip)
}
# uncompress .zip, if downloaded by first time
if (!file.exists(folder_name)) {
    unzip(folder_name_zip)
}


# loading data ------------------------------------------------------------

# measures
train_raw <- read_table("UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
test_raw  <- read_table("UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
# labels
labels_train <- read_csv("UCI HAR Dataset/train/y_train.txt", col_names = FALSE)
labels_test  <- read_csv("UCI HAR Dataset/test/y_test.txt", col_names = FALSE)
# subjets
subject_train <- read_csv("UCI HAR Dataset/train/subject_train.txt",  col_names = FALSE)
subject_test  <- read_csv("UCI HAR Dataset/test/subject_test.txt",  col_names = FALSE)
# features
features_raw  <- read_table2("UCI HAR Dataset/features.txt", col_names = FALSE)
# activity names
activity <- read_table("UCI HAR Dataset/activity_labels.txt", col_names = FALSE)



# keep variable names -----------------------------------------------------

features <- select(features_raw, -X1)


# add names ---------------------------------------------------------------

names(train_raw) <- features$X2
names(test_raw)  <- features$X2


# add subject ------------------------------------------------------------

train <- subject_train %>% rename(subject = X1) %>% bind_cols(train_raw)
test  <- subject_test  %>% rename(subject = X1) %>% bind_cols(test_raw)


# add activity ------------------------------------------------------------

# vector to replace integers with labels
activity_vector <- activity$X2
names(activity_vector) <- activity$X1
## Replace numbers for activity labels, and add them to data
# train
train_labeled <- labels_train %>% rename(activity = X1) %>% 
    mutate(activity = str_replace_all(activity, pattern = activity_vector)) %>%
    bind_cols(train)
# test
test_labeled <- labels_test %>% rename(activity = X1) %>% 
    mutate(activity = str_replace_all(activity, pattern = activity_vector)) %>%
    bind_cols(test)


# merging -----------------------------------------------------------------

# join training and test data
data_merged <- rbind(train_labeled, test_labeled)


# extract mean and standard deviations ------------------------------------

# position of such variables
position_mean_or_std <- str_detect(features$X2, pattern = "(mean)|(std)") %>% which() + 2
# add two because I add to variables and the beginning
data <- data_merged[, c(1, 2, position_mean_or_std)]
# improve variable names
names(data) <- str_replace_all(string = names(data), 
                               pattern = c("\\(|\\)|-" = "", "mean" = "Mean", "std" = "Std"))


#  average of each variable for each activity and each subject ------------

# tidy data, a variable per column, the get respective averages
data_averages <- data %>%
    gather(key = variable, value = value, -activity, -subject) %>% 
    group_by(activity, subject, variable) %>% 
    summarise(average = mean(value, na.rm = TRUE))


# output ------------------------------------------------------------------

write_csv(data_averages, "data_tidy.csv")






