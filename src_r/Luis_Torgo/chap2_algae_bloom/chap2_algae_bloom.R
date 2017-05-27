
## ---------------------------------------- ##
## Chapter 2: Predicting Algae Blooms       ##
## Book Title: Data Mining with R: ...      ##
## By Luis Torgo (2011)                     ##
## -----------------------------------------##
## Programmer: hack4Mintilo                 ##
## Email: hack4Mintilo@gmail.com            ##
## -----------------------------------------##
## Date: 23-May-2017 (Initial version)      ##
## -----------------------------------------##

## set working directory
#setwd("<user>/Desktop/Data Science/Data Mining with R/src_r/Luis_Torgo/chap2_algae_bloom")

## ------------------------------------------------------------ ##
## <!-- Step-1: load algae bloom dataset from UCI page.     --> ##
## -------------------------------------------------------------##

## <!-- option 1: accessing algae dataset from UCI ML webpage  -->
#install.packages("RCurl")
#install.packages("XML")
library(RCurl)
# library(XML)

# url_data_analysis <- "https://archive.ics.uci.edu/ml/machine-learning-databases/coil-mld/analysis.data"
# algae_url <- getURL(url = url_data_analysis, ssl.verifypeer=FALSE)
# algae_connection <- textConnection(algae_url)
# algae <- read.csv(algae_connection, header = FALSE)

## <!-- option 2: accessing algae dataset from DMwR package (see pp. 41, Luis Torgo)  -->
install.packages("DMwR")
library(DMwR)
head(algae)
?algae


## ------------------------------------------------------ ##
## <!-- step-2: data visualization and summarization  --> ##
## ------------------------------------------------------ ##
## FINDINGS:
## -- [pp 44]. There are more water samples collected in winter (n_win=62) than in other seasons (n_aut=40; n_spr=53; n_summ=45)
summary(algae)

hist(algae$mxPH, probability = F)

boxplot(algae$oPO4, ylab="Orthophosphate (oPo4)")
abline(h = mean(algae$oPO4, na.rm = T), lty=2)

## -- [falcon_mission 1, pp 49]. understanding the distribution of the values of, say, algal a1.
library(lattice)

## FINDINGS:
## -- [pp 49]. Higher frequencies of algae A1 in smaller rivers 
bwplot(size ~ a1, data = algae, ylab = "River size", xlab = "Algae A1")

## -- [pp 50]. Box-percentile plots
## FINDINGS:
## -- we can confirm our previous observation that smaller rivers have 
##    higher frequencies of this alga, but we can also observe that the 
##    value of the observed frequencies for these small rivers is much 
##    more widespread across the domain of frequencies than for other types of rivers.
library(Hmisc)
bwplot(size ~ a1, data = algae, 
       panel = panel.bpplot, probs=seq(0.01,0.49,by=0.01), datadensity=TRUE,
       ylab = "River size", xlab = "Algae A1")


## -- condition plot for contineous variables
min02 <- equal.count(na.omit(algae$mnO2),
                     number=4, overlap=1/5)


###########################################
## <!-- section 2.5: Missing values  --> ##
###########################################
nrow(algae[!complete.cases(algae), ])

## -- number of missing values in each row
apply(algae, 1, function(x) {
  sum(is.na(x))
})

## -- 2.5.3: Filling missing values by Exploring correlations
cor(algae[, 4:18], use = "complete.obs")

## visual representation of corr()
symnum(cor(algae[, 4:18], use = "complete.obs"))

## -- conditional Histogram
library(lattice)
histogram(~ mxPH | season, data = algae)

## adjust ordering of season
## -- FINDINGS:
##    - The values of mxPH are not seriously influenced by the season of the year when the samples were collected.
algae$season <- factor(algae$season, levels = c("spring", "summer", "autumn", "winter"))
histogram(~ mxPH | season, data = algae)

## by size of river
## -- FINDINGS:
##    - we can observe a tendency for smaller rivers to show lower values of mxPH.
algae$size <- factor(algae$size, levels = c("small", "medium", "large"))
histogram(~ mxPH | size, data = algae)

## adding more nominal variables
## -- FINDINGS: 
##    - It is curious to note that there is no information regarding small rivers with low speed.
algae$speed <- factor(algae$speed, levels = c("low", "medium", "high"))
histogram(~ mxPH | size * speed, data = algae)

## scatter plot between contineous and nominal variables
## -- NOTE:
##    - The jitter=T parameter setting is used to perform 
##      a small random permutation of the values in the Y-direction 
##      to avoid plotting observations with the same values over each other, 
##      thus losing some information on the concentration of observations with 
##      some particular value.
stripplot(size ~ mxPH | speed, data = algae, jitter=T)


## --------------------------------------------------- ##
## <!-- section 2.6: Obtaining Prediction Models.  --> ##
## --------------------------------------------------- ##

## --------------------------------------------------- ##
## -- section 2.6.1: Multiple Linear Regression        ##
## --------------------------------------------------- ##

## -- preprocessing data for MLR
data("algae")
algae <- algae[-manyNAs(algae), ]
## -- NOTE:
##    - After executing this code we have a data frame, clean.algae, that has no missing variable values.
clean.algae <- knnImputation(algae, k = 10)

## -- predicting algae type A1
lm.a1 <- lm(a1 ~ ., data = clean.algae[, 1:12])
summary(lm.a1)

## -- simplifying the linear model using the anova() function
## -- NOTE:
##    - When applied to a single linear model, this function will give us a 
##     sequential analysis of variance of the model fit. That is, the reductions 
##     in the residual sum of squares (the total error of the model) as each term 
##     of the formula is added in turn.
anova(object = lm.a1)

## -- CONCLUSIONS: 
##    - These results indicate that the variable season is the variable 
##      that least contributes to the reduction of the fitting error of the model.

## Let us remove season from the model
lm2.a1 <- update(object = lm.a1, formula. = . ~ . - season)
summary(lm2.a1)

anova(lm.a1, lm2.a1)

## -- backward elimination
## -- NOTE:
##    - The function step() uses the Akaike Information Criterion to perform model 
##      search. The search uses backward elimination by default, but with the 
##      parameter direction you may use other algorithms (check the help of this 
##      function for further details).
#final.lm <- step(object = lm.a1)
final.lm <- step(object = lm.a1, direction = "backward")
summary(final.lm)


## ------------------------------------------------------------- ##
## -- section 2.6.2: Regression Trees (Breiman et al., 1984)     ##
## ------------------------------------------------------------- ##

## -- NOTE:
##    - As these models handle datasets with missing values, we only need to 
##      remove samples 62 and 199 for the reasons mentioned before.
library(rpart)

data(algae)
algae <- algae[-manyNAs(algae), ]

## -- fit regression trees
## -- NOTE:
##    - rpart (Therneau and Atkinson, 2010)
rt.a1 <- rpart(a1 ~ ., data = algae[, 1:12])
rt.a1

## -- graphical representation of the tree
prettyTree(rt.a1)


## ----------------------------------- ##
## <!-- To BE CONTINUED (rpart)  -->   ##
## ----------------------------------- ##



## -------------------------------------------------- ##
## -- section 2.7: Model Evaluation and Selection     ##
## -------------------------------------------------- ##
lm.pred.a1 <- predict(final.lm, newdata = algae)
rt.pred.a1 <- predict(rt.a1, newdata = algae)

## -- mean absolute error (MAE)
(mae.lm.a1 <- mean(abs(lm.pred.a1 - algae[, "a1"])))
(mae.rt.a1 <- mean(abs(rt.pred.a1 - algae[, "a1"])))

## -- mean squared error (MSE)
## -- NOTE:
##    - MSE statistic has the disadvantage of not being measured in the same units 
##      as the target variable, and thus being less interpretable from the user 
##      perspective. Even if we use the MAE statistic, we can ask ourselves the 
##      question whether the scores obtained by the models are good or bad.
(mse.lm.a1 <- mean((lm.pred.a1 - algae[, "a1"])^2))
(mse.rt.a1 <- mean((rt.pred.a1 - algae[, "a1"])^2))

## -- normalized mean squared error (NMSE)
## -- NOTE:
##    - The NMSE is a unit-less error measure with values usually ranging 
##      from 0 to 1. If your model is performing better than this very simple 
##      baseline predictor, then the NMSE should be clearly less than 1. 
##      The smaller the NMSE, the better. Values grater than 1 mean that your model 
##      is performing worse than simply predicting always the average for all cases!
(nmse.lm.a1 <- mean((lm.pred.a1 - algae[, "a1"])^2) / 
               mean((mean(algae[, "a1"]) - algae[, "a1"])^2) )

(nmse.rt.a1 <- mean((rt.pred.a1 - algae[, "a1"])^2) / 
               mean((mean(algae[, "a1"]) - algae[, "a1"])^2) )

## -- books package (regr.eval)
regr.eval(trues = algae[, "a1"], preds = lm.pred.a1, train.y = algae[, "a1"])
regr.eval(trues = algae[, "a1"], preds = rt.pred.a1, train.y = algae[, "a1"])

## -- PLOT: errors scatter plot
## -- FINDINGS:
##    - Looking at Figure 2.10 (left) with the predictions of the linear model, 
##      we can see that this model predicts negative algae frequencies for some 
##      cases. In this application domain, it makes no sense to say that the 
##      occurrence of an alga in a water sample is negative (at most, it can be zero).
old.par <- par(mfrow = c(1, 2))
plot(lm.pred.a1, algae[, "a1"], main = "Linear Model", 
     xlab = "Predictions", ylab = "True values", 
     abline(0, 1, lty = 2))
plot(rt.pred.a1, algae[, "a1"], main = "Regression Tree", 
     xlab = "Predictions", ylab = "True values",
     abline(0, 1, lty = 2))
par(old.par)




