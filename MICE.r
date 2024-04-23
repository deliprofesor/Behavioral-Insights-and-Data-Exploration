#The MICE (Multiple Imputation by Chained Equations) library is a tool used for analyzing and completing missing data. 
#It is commonly used in statistical analysis and data mining. The MICE method works with chained equations to predict missing data. 
#This method makes predictions to replace missing data while preserving the distribution and relationships of the missing data.

#The VIM (Virtual Impact Method) library is a tool used for analyzing collisions and the resulting impacts. 
#The VIM method is utilized to evaluate the transfer of kinetic energy and the effects resulting from collisions.
#This library is used to perform collision simulations, examine deformations resulting from collisions, and analyze factors such as force and energy generated from collisions. 

?mice


#mice(
  #data,
  #m = 5,
  #method = NULL,
 # predictorMatrix,
  #ignore = NULL,
  #where = NULL,
 # blocks,
  #visitSequence = NULL,
  #formulas,
  #blots = NULL,
  #post = NULL,
  #defaultMethod = c("pmm", "logreg", "polyreg", "polr"),
  #maxit = 5,
 # printFlag = TRUE,
 # seed = NA,
#  data.init = NULL,
  #...
#)

# Install and load necessary packages
install.packages("mice")
library(mice)
library(VIM) 
library(ggplot2) 

# Read the CSV file
df <- read.csv("/home/yorgun/r_tube/Rcode/data_models/student_placement_data_with_NA.csv")
View(df) 
names(df) 

# Select variables of interest
new_df <- df[c("Acedamic.percentage.in.Operating.Systems",
               "percentage.in.Algorithms",
               "Percentage.in.Programming.Concepts",
               "certifications",
               "workshops",
               "reading.and.writing.skills")]

View(new_df) 
names(new_df) <- c("Operating", "Algorithms", "Concepts", "Cert", "Works", "ReadingWriting") # Rename columns

# Visualize missing data patterns
fig <- aggr(new_df, col = c("orange", "red"), labels = names(new_df), numbers = TRUE, sortVars = TRUE, cex.axis = 0.6, ylab = c("Histogram of Missing Values", "Pattern"))

new_df$ReadingWriting <- factor(new_df$ReadingWriting, levels = c("poor", "medium", "excellent"), ordered = TRUE)

imputed <- mice(data = new_df , m = 3 , maxit = 3 , method = NULL , defaultMethod = c("pmm" ,"logreg" , "lda" , "polr"))
summary(imputed)

imputedData <- complete(imputed, 3)
View(imputedData)
names(imputed)
imputed$m

imputed$imp
imputed$imp$Operating
imputed$imp$ReadingWriting

imputedData <- complete(imputed , 3)
View(imputedData)

imputed2 <- mice(data = new_df , m = 3 , maxit = 3 , method = c("rf" ,"cart" , "rf" , "sample" , "sample" ,"polr"))
