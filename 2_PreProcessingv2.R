##_______________________________________________________________________________________________________##
##
##
##
##  Project Name : Mushroom Challenge
##  Developer Name : Aurore Paligot
##  
##  Script Name : 2_PreProcessingv2
##  Description :try the model without the stalk root. I got some false etable attribution.
##  Current Status :complete
##  Date of 1st Release :29-01-2019
##  History versions : 
##  2_PreProcessingv1 : first Rnadom Forest
##  2_PreProcessingv2 : try the model without the stalk root /source v1
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

MushData <- read.csv ("Data/data_train4.csv")

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

saveRDS(RF, file= "Data/XXX.rds")

plot(varImp(RF))






