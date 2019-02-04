
##
##
##
##  Project Name : Mushroom Challenge
##  Developer Name : Aurore Paligot
##  
##  Script Name : 2_PreProcessingv6
##  Description : End model
##  Current Status complete
##  Date of 1st Release :29-01-2019
##  History versions : 
##  2_PreProcessingv1 : first RF
##  2_PreProcessingv2 : try the model without the stalk root
##  2_PreProcessingv2 : try to predict good/bad odor
##
##  Outputs : 
##
##  Related Scripts : 
##
##                                                                                                       
##_______________________________________________________________________________________________________## 

## (1) libraries ------------------------------------------------------------------------------

library(caret)
library(tidyverse)
library(readr)
library(randomForest)

## (2) Preprocess: remove the following features ------------------------------------------------------

Validation <- select (Validation, -spore.print.color, -veil.type, -stalk.root, -odor)



## (6) Random Forest ----------------------------------------------------------------------------



RF <- train ( class ~ .,
              data = MushTrain,
              method = "rf",
              trControl = train.control )

## my model -------

readRDS(file = "Data/ModelAurore_corrected.rds")

