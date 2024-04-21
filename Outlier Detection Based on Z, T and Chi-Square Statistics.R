# Install and load the outliers package
install.packages("outliers")
library(outliers)

# Check the documentation for the scores function
?scores

## Outliers based on Z Distribution (Normal Distribution)
View(airquality)
out <- scores(na.omit(airquality$Ozone), type = "z", prob = 0.95)
ids <- which(out == TRUE)
na.omit(airquality$Ozone)[ids]
hist(airquality$Ozone)
par(mfrow=c(2,1))
hist(airquality$Ozone)
hist(na.omit(airquality$Ozone)[-ids])

## Outliers based on T Distribution
View(airquality)
out <- scores(na.omit(airquality$Ozone), type = "t", prob = 0.95)
ids <- which(out == TRUE)
na.omit(airquality$Ozone)[ids]
hist(airquality$Ozone)
par(mfrow=c(2,1))
hist(airquality$Ozone)
hist(na.omit(airquality$Ozone)[-ids])

## Outliers based on Chi-square Distribution
out <- scores(na.omit(airquality$Ozone), type = "chisq", prob = 0.95)
ids <- which(out == TRUE)
na.omit(airquality$Ozone)[ids]
hist(airquality$Ozone)
par(mfrow=c(2,1))
hist(airquality$Ozone)
hist(na.omit(airquality$Ozone)[-ids])

## Outliers based on IQR Range
out <- scores(na.omit(airquality$Ozone), type = "iqr", prob = 0.95)
ids <- which(out == TRUE)
na.omit(airquality$Ozone)[ids]
hist(airquality$Ozone)
par(mfrow=c(2,1))
hist(airquality$Ozone)
hist(na.omit(airquality$Ozone)[-ids])

## Outliers based on Median Absolute Deviation (MAD)
out <- scores(na.omit(airquality$Ozone), type = "mad", prob = 0.95)
ids <- which(out == TRUE)
na.omit(airquality$Ozone)[ids]
hist(airquality$Ozone)
par(mfrow=c(2,1))
hist(airquality$Ozone)
hist(na.omit(airquality$Ozone)[-ids])
