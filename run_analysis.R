# 



# settings ----------------------------------------------------------------

library(readr)
library(dplyr)
library(tidyr)
library(stringr)

# loading -----------------------------------------------------------------

# sets 
train_raw <- read_table("UCI_HAR_Dataset/train/X_train.txt", col_names = FALSE)
test_raw  <- read_table("UCI_HAR_Dataset/test/X_test.txt", col_names = FALSE)
# labels
labels_train <- read_csv("UCI_HAR_Dataset/train/y_train.txt", col_names = FALSE)
labels_test  <- read_csv("UCI_HAR_Dataset/test/y_test.txt", col_names = FALSE)
# subjets
subject_train <- read_csv("UCI_HAR_Dataset/train/subject_train.txt",  col_names = FALSE)
subject_test  <- read_csv("UCI_HAR_Dataset/test/subject_test.txt",  col_names = FALSE)
# features
features_raw  <- read_table2("UCI_HAR_Dataset/features.txt", col_names = FALSE)
# activity names
activity <- read_table("UCI_HAR_Dataset/activity_labels.txt", col_names = FALSE)


# preprocesing ------------------------------------------------------------

features <- select(features_raw, -X1)


# add names ---------------------------------------------------------------

names(train_raw) <- features$X2
names(test_raw)  <- features$X2


# add people --------------------------------------------------------------

train <- subject_train %>% rename(subject = X1) %>% bind_cols(train_raw)
test  <- subject_test  %>% rename(subject = X1) %>% bind_cols(test_raw)


# add activity ------------------------------------------------------------

activity_vector <- activity$X2
names(activity_vector) <- activity$X1

train_labeled <- labels_train %>% rename(activity = X1) %>% 
    mutate(activity = str_replace_all(activity, pattern = activity_vector)) %>%
    bind_cols(train)








