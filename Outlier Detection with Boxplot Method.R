install.packages("jsonlite")
install.packages("rstatix")

# Read the AirbnbNewyork.csv file
AirbnbNewyork <- read.csv("/home/yorgun/r_tube/Rcode/data_models/AirbnbNewyork.csv")

# View the data set
View(AirbnbNewyork)

# Load the packages
library(rstatix)
library(jsonlite)

# Check the documentation for the identify_outliers function
?identify_outliers

# Identify outliers
out <- identify_outliers(AirbnbNewyork["price"])

# Check the column names in the output
names(out)

# Find the minimum and maximum prices among the outliers
min(out$price)
max(out$price)

# Find the overall minimum and maximum prices in the data set
min(AirbnbNewyork[,"price"])
max(AirbnbNewyork[,"price"])

# Filter rows containing outliers
ids <- which(out$is.extreme == TRUE)
extreme <- out[ids, "price"]

# Find the minimum and maximum prices among the outliers
min(extreme)
max(extreme)

# Check the number of outliers and total number of observations
length(extreme)
nrow(out)
nrow(AirbnbNewyork)

