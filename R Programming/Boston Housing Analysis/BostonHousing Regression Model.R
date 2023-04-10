# Installing packages
install.packages("mlbench")


# Importing libraries

# Contains multiple datasets we are interested in Boston Housing 
library(mlbench) 
# Contains regression model
library(caret)

# Importing the Boston Housing data set
data(BostonHousing)

# Show the first 5 row
head(BostonHousing, 5)

# Show the column names
colnames(BostonHousing)

# Display the structure of the data
str(BostonHousing)

# Display Data summary
skim_without_charts(BostonHousing)
glimpse(BostonHousing)


# check missing data
sum(is.na(BostonHousing))

# To achieve reproducible model; set the random seed number
set.seed(1500)

# Performs stratified random split of the data set
trainingIndex <- createDataPartition(BostonHousing$medv, p=0.8, list = FALSE)
trainingSet <- BostonHousing[trainingIndex,] # training Set
testingSet <- BostonHousing[-trainingIndex,] # test Set


# Build training model
regModel <- train(medv ~ ., data = trainingSet,
               method = "lm",
               na.action = na.omit,
               preProcess=c("scale","center"),
               trControl= trainControl(method="none")
)

# Apply model for prediction
regModel.training <-predict(regModel, trainingSet) # Apply model to make prediction on training set
regModel.testing <-predict(regModel, testingSet) # Apply model to make prediction on testing set

# regModel performance (Displays scatter plot and performance metrics)
# Scatter plot of training and testing set
plot(trainingSet$medv,regModel.training, col = "blue" )
plot(testingSet$medv,regModel.testing, col = "blue" )

# Model performance
summary(regModel)


# Correlation R
cor(trainingSet$medv,regModel.training)
cor(testingSet$medv,regModel.testing)

# Correlation R^2
cor(trainingSet$medv,regModel.training)^2
cor(testingSet$medv,regModel.testing)^2

