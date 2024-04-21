
# Install and load the VIM package
install.packages("VIM")
library(VIM)

# Read the CSV file and view the data frame
df <- read.csv("/home/yorgun/r_tube/Rcode/data_models/student_placement_data_with_NA.csv")
View(df)
names(df)

# Subset the data frame to include specific columns
new_df <- df[c("Acedamic.percentage.in.Operating.Systems",
               "percentage.in.Algorithms",
               "Percentage.in.Programming.Concepts",
               "certifications",
               "workshops")]
View(new_df)

# Rename the columns for easier reference
names(new_df) <- c("Operating", "Algorithms", "Concepts", "Cert", "Works")

# Load the ggplot2 package
library(ggplot2)

# Create an aggregated plot to visualize missing values
fig <- aggr(new_df, col = c("orange", "red"), labels = names(new_df),
            numbers = TRUE, sortVars = TRUE, cex.axis = 0.6, 
            ylab = c("Histogram of Missing Values", "Pattern"))

# Plot a margin plot for numeric values only
marginplot(cbind(new_df$Operating, new_df$Algorithms))
