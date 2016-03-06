
Included in this repository is `run_analysis.R`, a [Codebook](CodeBook.md), and this README.

`run_analysis.R` 
  1. Loads libraries (dplyr, reshape2, data.table)
  2. Retrives the UCI HAR Dataset
  3. Loads the test and training data
  4. Assigns labels and names to the data
  5. Extracts mean and standard deviation features
  6. Merges the test and training data
  7. Additionally, a new dataset is created consisting of the average of each variable for each activity and each subject.

Codebook - Gives description to the data used