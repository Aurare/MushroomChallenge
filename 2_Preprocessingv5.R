##_______________________________________________________________________________________________________##
##
##
##
##  Project Name : Mushroom Challenge
##  Developer Name : Aurore Paligot
##  
##  Script Name : 2_PreProcessingv3
##  Description :
##  Current Status :in process
##  Date of 1st Release :29-01-2019
##  History versions : 
##  2_PreProcessingv1 : first RF
##  2_PreProcessingv2 : try the model without the stalk root
##  2_PreProcessingv3 : try to predict good/bad odor
##  2_Preprocessingv5 : Start from v3 odor, to build with veil
##
##  Outputs : 
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

MushData <- read.csv(file="Data/Odor2.csv", sep=";")

MushData <- MushData[,-1]

## (4) remove obvious features : odor and spore ------------------------------------------------------

MushData <- select (MushData, -spore.print.color, -stalk.root, -class)

MushData <- rename ( MushData, class = odor )


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




