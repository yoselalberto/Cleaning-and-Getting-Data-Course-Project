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
labels_test <- read_csv("UCI_HAR_Dataset/test/y_test.txt", col_names = FALSE)
# subjets
subject_train <- read_csv("UCI_HAR_Dataset/train/subject_train.txt",  col_names = FALSE)
subject_test  <- read_csv("UCI_HAR_Dataset/test/subject_test.txt",  col_names = FALSE)
# features
features_raw  <- read_delim("UCI_HAR_Dataset/features.txt", col_names = FALSE, delim = " ")


# preprocesing ------------------------------------------------------------

features <- select(features_raw, -X1)

# joining -----------------------------------------------------------------














