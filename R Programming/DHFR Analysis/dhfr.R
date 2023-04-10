
# Importing libraries
library(datasets) # Contains several data sets
library(caret) # Package for machine learning algorithms / CARET stands for Classification And REgression training

# Importing the dhfr data set
data(dhfr)

# Checking missing data
sum(is.na(dhfr))

# fixing seed
set.seed(200)

# Performs stratified random split of the data set
trainingIndex <- createDataPartition(dhfr$Y, p=0.75, list = FALSE)
trainingSet <- dhfr[trainingIndex,] # training Set
testingSet <- dhfr[-trainingIndex,] # test Set


# Build training model
model <- train(Y ~ ., data = trainingSet,
               method = "svmPoly",
               na.action = na.omit,
               preProcess=c("scale","center"),
               trControl= trainControl(method="none"),
               tuneGrid = data.frame(degree=1,scale=1,C=1)
)

# Build CV model
model.cv <- train(Y ~ ., data = trainingSet,
                  method = "svmPoly",
                  na.action = na.omit,
                  preProcess=c("scale","center"),
                  trControl= trainControl(method="cv", number=10),
                  tuneGrid = data.frame(degree=1,scale=1,C=1)
)


# Apply model for prediction
model.training <-predict(model, trainingSet) # Apply model to make prediction on training set
model.testing <-predict(model, testingSet) # Apply model to make prediction on testing set
model.cv <-predict(model.cv, trainingSet) # Perform cross-validation

# model performance (Displays confusion matrix and statistics)
model.training.confusion <-confusionMatrix(model.training, trainingSet$Y)
model.testing.confusion <-confusionMatrix(model.testing, testingSet$Y)
model.cv.confusion <-confusionMatrix(model.cv, trainingSet$Y)

print(model.training.confusion)
print(model.testing.confusion)
print(model.cv.confusion)

# Feature importance
Importance <- varImp(model)
plot(Importance, top = 20)

