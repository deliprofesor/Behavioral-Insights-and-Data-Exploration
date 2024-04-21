# Load necessary packages
install.packages("ggplot2")
install.packages("car")
library(ggplot2)
library(car)

# View the airquality dataset
View(airquality)

# Create a scatter plot using ggplot
fig <- ggplot(airquality, aes(x = Ozone, y = Temp)) + 
  geom_point(size = 2) + 
  xlab("Ozone Values") + ylab("Temp Values")

# Plot the scatter plot
fig

# Remove rows with missing values from the dataset
X <- na.omit(airquality[c("Ozone", "Temp")])
View(X)

# Calculate center points and covariance matrix
air.center <- colMeans(X)
air.cov <- cov(X)

# Calculate the radius for the ellipse
rad <- sqrt(qchisq(0.80, df = 2))

# Generate the ellipse
ellipse <- ellipse(center = air.center, shape = air.cov, rad = rad, 
                   segments = 100, draw = FALSE)
ellipse <- as.data.frame(ellipse)
colnames(ellipse) <- colnames(X)

# Add the ellipse and center point to the plot
fig <- fig + geom_polygon(data = ellipse, color = "orange", fill = "orange", 
                          alpha = 0.3) + 
  geom_point(aes(x = air.center[1], y = air.center[2]), 
             size = 5, color = "blue")

# Plot the updated figure with the ellipse and center point
fig

# Calculate Mahalanobis distance
dist <- mahalanobis(X, center = air.center, cov = air.cov)

# Set the cutoff value for Mahalanobis distance
cutoff <- qchisq(p = 0.95, df = 2)

# Identify outliers based on Mahalanobis distance
ids <- which(dist > cutoff)
outliers <- X[ids, ]

# View the outliers
View(outliers)
