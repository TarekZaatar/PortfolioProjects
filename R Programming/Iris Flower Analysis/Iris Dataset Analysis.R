confMatrixPlot <- function(confusion.Matrix) {
  # convert the confusion matrix to a data frame
  conf_df <- as.data.frame.matrix(confusion.Matrix$table)
  
  # add row and column names to the data frame
  conf_df$Species <- rownames(conf_df)
  conf_df <- gather(conf_df, "Predicted", "Count", -Species)
  conf_df$Predicted <- factor(conf_df$Predicted, levels = rownames(model.training.confusion$table))
  
  # plot the confusion matrix using ggplot2
  return(ggplot(conf_df, aes(x = Species, y = Predicted, fill = Count)) +
    geom_tile() +
    scale_fill_gradient(low = "lightgrey", high = "lightpink1") +
    theme_bw() +
    labs(x = "Actual Species", y = "Predicted Species", 
         title = "Confusion Matrix - Training Set")+
    geom_text(aes(label = Count), color = "black"))
  
}

confMatrixPlot2 <- function(confusion.Matrix) {
  
  
  # convert the confusion matrix to a data frame
  conf_df <- as.data.frame.matrix(confusion.Matrix$table)
  
  # add row and column names to the data frame
  conf_df$Species <- rownames(conf_df)
  conf_df <- gather(conf_df, "Predicted", "Count", -Species)
  conf_df$Predicted <- factor(conf_df$Predicted, levels = rownames(model.training.confusion$table))

# define a custom color scale based on the confusion matrix values
conf_colors <- c("#FFFFFF", "#FEE0D2", "#FCBBA1", "#FC9272", "#FB6A4A", "#EF3B2C", "#CB181D", "#99000D")
conf_breaks <- c(0, 5, 10, 15, 20, 25, 30, 35, 40)
conf_labels <- c("0", "5", "10", "15", "20", "25", "30", "35","40")
conf_palette <- colorRampPalette(conf_colors)(length(conf_colors)-1)

# plot the confusion matrix using ggplot2
return(ggplot(conf_df, aes(x = Species, y = Predicted, fill = Count)) +
  geom_tile() +
  scale_fill_gradientn(colors = conf_palette, breaks = conf_breaks, labels = conf_labels) +
  theme_bw() +
  labs(x = "Actual Species", y = "Predicted Species", 
       title = "Confusion Matrix - Training Set") +
  geom_text(aes(label = Count), color = "black"))
}




#Install required packages

install.packages("skimr")
install.packages("reshape2")                                 
install.packages("caret")
install.packages("kernlab")
install.packages("dplyr")

#Load required  library

library(reshape2) 
library(skimr)
library(datasets)
library(caret)
library(dplyr)

#Fixing seed 
set.seed(2000)

# Exploring the data

# Show the first 6 row
head(iris)

# Show the column names
colnames(iris)

# Display the structure of the data
str(iris)

# Display Data summary and statistics
glimpse(iris)
iris %>% summary()
skim(iris)


# Check for missing values
sum(is.na(iris))


# Checking the number of species
iris %>% count(Species)

# Display data statistics per flower species
iris %>% group_by(Species) %>% skim()


# Visualize species column using bar chart
ggplot(data=iris)+geom_bar(mapping=aes(x=Species,fill=Species))

# Visualize Sepal width column using histogram  to find distribution
ggplot(data=iris)+geom_histogram(bins= 20, mapping=aes(x=Sepal.Width))


# Boxplot for Sepal width column for each flower species
ggplot(data=iris)+geom_boxplot(mapping=aes(y=Sepal.Width,group=Species,fill= Species))

# Boxplot for all the columns
iris_long <- melt(iris, id = "Species")    
ggplot(data=iris_long) + geom_boxplot( aes(x = variable, y = value, fill = Species))


#splitting the data
trainingIndex <- createDataPartition(iris$Species, p=0.8,list = FALSE)
trainingSet <- iris[trainingIndex,]
testingSet <- iris[-trainingIndex,]


# Boxplot for all the columns for the training and testing datasets
iris1 <- melt(trainingSet, id = "Species")    

ggplot(data=iris1) + 
  geom_boxplot( aes(x = variable, y = value, fill = Species))


iris2 <- melt(testingSet, id = "Species")    

ggplot(data=iris2) + 
  geom_boxplot( aes(x = variable, y = value, fill = Species))


# Build Training model
model <- train(Species ~ ., data = trainingSet,
               method = "svmPoly",
               na.action = na.omit,
               preProcess=c("scale","center"),
               trControl= trainControl(method="none"),
               tuneGrid = data.frame(degree=1,scale=1,C=1)
)

# Build CV model
model.cv <- train(Species ~ ., data = trainingSet,
                  method = "svmPoly",
                  na.action = na.omit,
                  preProcess=c("scale","center"),
                  trControl= trainControl(method="cv", number=10),
                  tuneGrid = data.frame(degree=1,scale=1,C=1)
)


# Apply model for prediction

# Apply model to make prediction on Training set
model.training <-predict(model, trainingSet) 

# Apply model to make prediction on Testing set
model.testing <-predict(model, testingSet)

# Perform cross-validation
model.cv <-predict(model.cv, trainingSet) 

# Model performance (Confusion Matrix) 
model.training.confusion <-confusionMatrix(model.training, trainingSet$Species)
model.testing.confusion <-confusionMatrix(model.testing, testingSet$Species)
model.cv.confusion <-confusionMatrix(model.cv, trainingSet$Species)

# Display the confusion Matrix
print(model.training.confusion)
print(model.testing.confusion)
print(model.cv.confusion)

# Visualize the confusion matrix
confMatrixPlot2(model.training.confusion)
confMatrixPlot2(model.testing.confusion)
confMatrixPlot2(model.cv.confusion)


# Feature importance

importance <- varImp(model)
plot(importance)

