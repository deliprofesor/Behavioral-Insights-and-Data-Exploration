# Load the dataset and view it
df <- read.csv("/home/yorgun/r_tube/Rcode/data_models/student_placement_data_with_NA.csv")
View(df)

# Identify NA values
ids <- which(is.na(df$Acedamic.percentage.in.Operating.Systems))
length(ids)

# Mean Imputation
mean_value <- mean(df$Acedamic.percentage.in.Operating.Systems, na.rm = TRUE)
df$Acedamic.percentage.in.Operating.Systems[ids] <- mean_value

# Random Imputation
set.seed(123)  # Set a seed for reproducibility
index <- which(is.na(df$Acedamic.percentage.in.Operating.Systems))
random_values <- sample(df$Acedamic.percentage.in.Operating.Systems[!is.na(df$Acedamic.percentage.in.Operating.Systems)], size = length(index), replace = TRUE)
df$Acedamic.percentage.in.Operating.Systems[index] <- random_values

# Check if there are any remaining NA values
which(is.na(df$Acedamic.percentage.in.Operating.Systems))

# Check the mean before and after imputation
mean_before_imputation <- mean(df$Acedamic.percentage.in.Operating.Systems, na.rm = TRUE)
mean_before_imputation
mean_after_imputation <- mean(df$Acedamic.percentage.in.Operating.Systems)
mean_after_imputation
