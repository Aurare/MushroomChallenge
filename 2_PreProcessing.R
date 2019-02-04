##_______________________________________________________________________________________________________##
##
##
##
##  Project Name : Mushroom Challenge
##  Developer Name : Aurore Paligot
##  
##  Script Name : 2_PreProcessing
##  Description : Random forest from scratch
##  Current Status :in process
##  Date of 1st Release :29-01-2019
##  History versions : 
##
##  Outputs : FirstRF.rds
##
##  Related Scripts : 
##
##                                                                                                       
##_______________________________________________________________________________________________________## 

## (1) source libraries ------------------------------------------------------------------------------

source ("Scripts/Exploratory Scripts/1_Libraries.R")

## (2) Do Parallel -----------------------------------------------------------------------------------

#create cluster
cl<-makeCluster(2)

#register cluster
registerDoParallel(cl)

## (3) load data -------------------------------------------------------------------------------------

MushData <- read.csv ("Data/data_train4.csv")

MushData <- MushData[,-1]

str(MushData)

summary(MushData)

#imputing missing values
MushData$


#corrplot(MushData)

## (4) remove obvious features : odor and spore ------------------------------------------------------

MushData <- select (MushData, -odor, -spore.print.color, -veil.type, -X, -stalk.root)



## (5) Data Partition ---------------------------------------------------------------------------------

set.seed(543)

trainIndex <- createDataPartition(MushData$class, 
                                  p = .70, 
                                  list = FALSE, 
                                  times = 1)

MushTrain <- MushData[ trainIndex,]

MushTest  <- MushData[-trainIndex,]

##train control: cross validation
train.control <- trainControl( method = "repeatedcv",
                               number = 10,
                               repeats = 3 )

## (6) Random Forest ----------------------------------------------------------------------------

RF <- train ( class ~ .,
              data = MushTrain,
              method = "rf",
              trControl = train.control )

#Test Set
Predict <- predict ( RF, MushTest )

#postresample
postResample ( Predict, MushTest$class )

#create colum predicat
Predictions_df <- MushTest %>% mutate ( PREDICTIONS = Predict )

#confusion matrix
confusionMatrix ( Predictions_df$class, Predictions_df$PREDICTIONS ) 

#varImp = Variance, by oder of importance
plot(varImp(RF))

saveRDS(RF, file= "Data/FirstRF.rds")






