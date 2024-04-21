# Read the CSV file and view the data frame
df <- read.csv("D:\\r_tube\\Rcode\\data_models\\Spanish\\PTK_Spanish_Speech_data.csv")
View(df)

# Define a function for min-max normalization
minMaxNorm <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# Min-max normalize 'cdur' column
min(minMaxNorm(df$cdur))
max(minMaxNorm(df$cdur))

df$cdur <- minMaxNorm(df$cdur) * 100
df$vdur <- minMaxNorm(df$vdur) * 100
df$wordfreq <- minMaxNorm(df$wordfreq) * 100

## Scaling Operation
?scale

# Use scale function to standardize 'vdur' column
scaled_vdur <- scale(df$vdur)

# Calculate mean and standard deviation of standardized 'vdur' column
mean(scaled_vdur)
sd(scaled_vdur)

## Manual scaling with custom mean and standard deviation
manual_scaled_vdur <- scale(df$vdur, center = 50, scale = 5)

# Plot histograms before and after scaling
par(mfrow = c(2,1))
hist(df$vdur)
hist(scaled_vdur)

# Plot histograms for manual scaling
hist(df$vdur)
hist(manual_scaled_vdur)
