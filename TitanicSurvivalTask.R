#Setting working Directory 
setwd("~/Desktop/Titanic Dataset R Studio")
#set stringsasfactors as false for variable manipulation
titanic.train <- read.csv(file= "train.csv", stringsAsFactors = FALSE)
titanic.test <- read.csv(file= "test.csv", stringsAsFactors = FALSE)

 #Clearing the data, all the rows from titanic.full where istrainset=true to titanic.train and false to titanic.test.
titanic.train$IsTrainSet <- TRUE
titanic.test$IsTrainSet <- FALSE

#add a "Survived" column in test set to align data for merge. fill with N/A 
titanic.test$Survived <- NA

#Rbind or union merges the two datasets
titanic.full <- rbind(titanic.train, titanic.test)

#Clean data by building filter to query just the embarked variable
titanic.full[titanic.full$Embarked=='', "Embarked"] <- 'S'

#where age = n/a fill in median and assign to variable age.median 
#clean missing variables in age and fare
#age.median <- median(titanic.full$Age, na.rm = TRUE)
#titanic.full[is.na(titanic.full$Age), "Age"] <- age.median
#fare.median <- median(titanic.full$Fare, na.rm = TRUE)
#titanic.full[is.na(titanic.full$Fare), "Fare"] <- fare.median

upper.whisker <- boxplot.stats(titanic.full$Fare)$stats[5]
outlier.filter <- titanic.full$Fare < upper.whisker
titanic.full[outlier.filter]
fare.equation = "Fare ~ Pclass + Sex + Age + SibSp + Parch"
fare.model <- lm (
  formula = fare.equation,
  data = titanic.full[outlier.filter,]
)
#query data to isolate things I want to see
fare.row <- titanic.full[
is.na(titanic.full$Fare),
c("Pclass", "Sex", "Age", "SibSp", "Parch", "Embarked")
  ]

fare.predictions <- predict(fare.model, newdata = fare.row)
titanic.full[is.na(titanic.full$Fare), "Fare"] <- fare.predictions

upper.whisker <- boxplot.stats(titanic.full$Age)$stats[5]
outlier.filter <- titanic.full$Age < upper.whisker
titanic.full[outlier.filter]
Age.equation = "Age ~ Pclass + Sex + Fare + SibSp + Parch"
fare.model <- lm (
  formula = Age.equation,
  data = titanic.full[outlier.filter,]
)

#query data to isolate things I want to see
Age.row <- titanic.full[
  is.na(titanic.full$Age),
  c("Pclass", "Sex", "Fare", "SibSp", "Parch", "Embarked")
  ]

Age.predictions <- predict(Age.model, newdata = Age.row)
titanic.full[is.na(titanic.full$Age), "Age"] <- Age.predictions

#categorical casting, cast everything except survive 
titanic.full$Pclass <- as.factor(titanic.full$Pclass)
titanic.full$Sex <- as.factor(titanic.full$Sex)
titanic.full$Embarked <- as.factor(titanic.full$Embarked)
titanic.full$Parch <- as.factor(titanic.full$Parch)
titanic.full$SibSp <- as.factor(titanic.full$SibSp)

#split data set back into train and test, cleaned.
titanic.train<-titanic.full[titanic.full$IsTrainSet==TRUE,]
titanic.test<-titanic.full[titanic.full$IsTrainSet==FALSE,]

titanic.train$Survived <- as.factor(titanic.train$Survived)

#adding string to predict survival 
#survival formula marks which variables are predictors
survived.equation <- "Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked"
survived.formula <- as.formula(survived.equation)
randomForest(Survived~.)
install.packages("randomForest")
library(randomForest)

titanic.model <- randomForest(formula = survived.formula, data = titanic.train, ntree = 500, mtry = 3, nodesize = 0.01 * nrow(titanic.test))

features.equation <- "Pclass + Sex + Age + SibSp + Parch + Fare + Embarked"
Survived <- predict(titanic.model, newdata = titanic.test)

PassengerId <- titanic.test$PassengerId
output.df <- as.data.frame(PassengerId)
output.df$Survived <- Survived

#set row.names to FALSE to delete obs
write.csv(output.df, file="kaggle_submission.csv", row.names = FALSE)

