Code Book
--------
The variables names are mostly pulled directly from the features.txt of the dataset whose url can be found in the README

The only variables I've explicitly added names to not present in that original feature list are "Subject" and "Activity"

Each activity was automatically assigned a name from the activity_labels.txt file, again in the dataset.

To make the tidy dataset, I column-bound the relevant files and assigned column names to the test and training data, merged them into one dataset, applied the relevant character vectors to the feature/activity names, subsetted by regular expressions to the mean and standard deviation measurements for each category, then finally used dplyr to group by the Subject then, Activity variables, then got the mean of the rest of the measurement variables (so that's the mean of each standard dev. and mean over the timeseries for each accelerometer/gyro measurement)

