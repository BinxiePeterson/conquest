
### Basic Statistics - R Ecology ###

## Statistics ##

# Statistics = science of extracting information from data; i.e. making sense of data
# Statistical inference = statistical methods used to make a conclusion about
# a population from sample data, i.e. we use sample data to calculate
# sample statistics to INFER the population parameter.

## Types of variables ##

# Categorical variables = frequencies, percentages
# Continuous variables = mean, median, mode, quartiles,
#                        interquartile range, standard deviation

## Parametric versus non-parametric methods
# Paremetric methods = for normally distributed data
# Non-parametric methods = for data that is not normally distributed


## Hypothesis testing ##

# Hypothesis = a claim/statement about a population parameter

# Null hypothesis = statement/value presently accepted to be correct and
# is such until proven to be false
# Example: average time to make a pie is 5 min. H0: u = 5 min

# Alternative hypothesis = contains a possible value or set of possible 
# values not specified by the null hypothesis
# Example: Ha: u != 5 min; Ha: u > 5 min; Ha: u < 5 min

## P value ##

# P value = probability of wrongly rejecting the null hypothesis,
# given that the null hypothesis is true.

# The p-value is always compared with the significance level (alpha) of the test
# For instances, at 95% level of confidence, the significant level is 5%
# and the p-value is reported as p < 0.05

# Small p value (less than alpha) -> reject null hypothesis
# The smaller the p-value, the more confident we can reject H0

# Significant result (p < 0.05) does not necessarily imply that the
# null hypothesis is false, or that the effect is important in practice

# Non-significant result (p > 0.05) does not imply that the
# null hyptohesis is true


## Install and load packages ##

install.packages(c("readr", "MASS", "car", "lmtest"))
library(readr)
library(MASS)
library(car)
library(lmtest)

## Data ##

# Open the "my_project" you previously created

# Make sure you load the correct data file with no missing values
surveys_complete <- read_csv("data_output/surveys_complete.csv")


## Basic functions ##

# What was the average weight of all the species?
mean(surveys_complete$weight)
# 41.833

# What was the average weight of all female species?
mean(surveys_complete$weight[surveys_complete$sex == "F"])
# 41.53125

# What is the standard deviation of the weights?
# Standard deviation tries to capture the average distance between observations
# and the mean of the data
sd(surveys_complete$weight)
# 35.71216
# Large standard deviation indicates that there were a lot of variation in the
# weights of the animals -> influenced by outliers

# What is the variance of the weights?
var(surveys_complete$weight)
# 1275.359

# What is the sample median weight for this data set?
median(surveys_complete$weight)
# 36

## Mean versus median
# Mean = influenced by outliers
# Median = not influenced by outliers

# What are the quartiles of the weight variable?
quantile(surveys_complete$weight)
# 4 (0%), 20 (25%), 36 (50%), 47 (75%), 280 (100%)

# Calculate the interquartile range (Q3 - Q1)
Q1 <- quantile(surveys_complete$weight, 0.25)
Q3 <- quantile(surveys_complete$weight, 0.75)
Q3-Q1
# 75% (27)

# How many species weighed more than 100 g?
sum(surveys_complete$weight > 100)
# 2619

# Which genus was observed the most?
# First calculate the frequencies of unique genera
table(surveys_complete$genus)
# Let's store this frequency table as an object
tbl <- table(surveys_complete$genus)
# What was the maximum number of observations made per genus?
max(tbl)
# Now determine which genus was observed the most:
which(tbl == max(tbl)) # OR
which.max(tbl)
# Dipodomys (small Kangaroo rats); 11th element in the tbl vector

# What proportion of species were female?
(sum(surveys_complete$sex == "F")) / (length(surveys_complete$sex)) * 100
# 47.40 % of species were female 

# Which male genus weighed the most
max(surveys_complete$weight)
tbl_male <- table(surveys_complete$genus[surveys_complete$weight == max(surveys_complete$weight)])
which(tbl_male == max(tbl_male))
# Neotoma (pack rats); 13th element in the tbl_male vector

# What is the sample correlation between the species weight and hindfoot_length?
cor(surveys_complete$weight, surveys_complete$hindfoot_length)
# 0.6840713, relatively strong positive relationship between these variables

# Let's calculate the mean for all the continuous variables of interest
lapply(surveys_complete, mean) # OR

surveys_complete %>% 
  dplyr::select(weight, hindfoot_length) %>% 
  lapply(mean)


## Graphical representation of data

# Box plot [1 variable]
boxplot(surveys_complete$weight)
# Multiple outliers

# Get the stats from the boxplot by adding []
boxplot(surveys_complete$weight)[]


# Box plot [2 variables]
boxplot(surveys_complete$weight, surveys_complete$hindfoot_length)
# One outlier for hindfoot_length
# Use locator() to identify the outlier by clicking on it and then press Esc
# -> the observation coordinates will be returned 
# -> go to dataset and use knowledge/judgement to determine
# whether this datapoint should be included/excluded from results
locator()
# x = ~2, Y = ~64 (i.e. max hindfoot_length is 64 mm)

# Let's see which record contains this max hindfoot_length
tbl_hfl <- table(surveys_complete$record_id[surveys_complete$hindfoot_length == max(surveys_complete$hindfoot_length)])
which(tbl_hfl == max(tbl_hfl))
# record_id = 30425

# Now use this record_id to extract that single observation
surveys_complete %>% 
  filter(record_id == "30425")

# Box plot [1 variable, 2 groups]
# Boxplot of weights for males versus female
boxplot(surveys_complete$weight~surveys_complete$sex)
      
####################################################################

# Box plot [1 variable, 2 groups according to criteria]
# Boxplot of sex where group 1 has low weight and long hindfeet;
# group 2 has low weight and short hindfeet
boxplot((surveys_complete$sex[surveys_complete$weight < 36 &&
           surveys_complete$hindfoot_length > 32]),
        (surveys_complete$sex[surveys_complete$weight < 36 &&
           surveys_complete$hindfoot_length < 32]))

####################################################################

## Pearson's chi-square test of independence
# Test to determine if there is an association between two categorical variables
# Chi-square test measures a type of "distance" between observed probability and
# expected probability
# Example: is there an association between genotype and coronary artery disease
# H0: there is no association betweeen two variables (p > 0.05)
# Ha: there is an association between two variables (p < 0.05)

# Let's determine whether there is an association between sex and weight
# First, we have to categorize hindfoot_length values
surveys_cat <- surveys_complete %>% 
  mutate(wgt_cat = case_when(weight %in% 0:20 ~ "small",
                             weight %in% 21:47 ~ "medium",
                             weight %in% 48:280 ~ "large"))

# Now do the Pearson's chi-square test
chisq.test(surveys_cat$sex, surveys_cat$wgt_cat)
# Chi-squared value (X) = 220;
# degrees of freedom (df) = 2;
# p < 0.05 -> reject H0 -> there is an association between sex and weight


# Pearson's chi-square test is used to determine if there is and association
# between two categorical variables

# However, some journals don't accept only p-values and require effect sizes as well
# Cramer's V value measures the effect sizes (i.e. strength of the association 
# between two categorical variables:
# * v = 0.1 -> small effect (no practical significant association)
# * v = 0.3 -> medium effect (practically visible association)
# * v = 0.5 -> large effect (practically significant association)

# Install and load "lsr" package
install.packages("lsr")
library(lsr)

# Calculate Cramer's V value to determine strength of association
# between sex and weight
cramersV(surveys_cat$sex, surveys_cat$wgt_cat)
# v = 0.085 -> less than 0.1, low strength of association between sex and weight
# i.e. no practical significant association

##################################################

## One sample t-test ##
# Assumptions:
# * Normally distributed population
# * Data are measured at least on interval scale

## Test for normality
# 1. Informal/graphical tests for normality:
#    * Histogram (should be symmetrical / bell-shaped)
#    * Q-Q (quantile-quantile) plot (should be a straight line)
# 2. Formal tests for normality:
#    * Shapiro-Wilk test
#      - H0: data is normally distributed (p > 0.05)
#      - Ha: data is not normally distributed (p < 0.05)

## Evaluate normality of weight variable:
# 1. Histogram
hist(surveys_complete$weight)
# Not symmetrical = not normally distributed

# 2. Q-Q plot
qqnorm(surveys_complete$weight)
qqline(surveys_complete$weight)
# Data not equal to theoretical observations (straight line), thus not normally
# distributed

# 3. Shapiro-Wilk test
shapiro.test(surveys_complete$weight)
# Error: sample size must be between 3 and 5000

# Solution:
# a. Use first 5000 observations (if they are randomly sorted)
shapiro.test(surveys_complete$weight[0:5000])
# p = 2.2e-16 -> p < 0.05 -> reject H0 -> data not normally distributed

# b. Use the Anderson-Darling normality test for larger sample sizes
install.packages("nortest")
library(nortest)
ad.test(surveys_complete$weight)
# p = 2.2e-16 -> p < 0.05 -> reject H0 -> data not normally distributed

## Since this data set doesn't contain normally distributed data, let's create some:
x <- rnorm(30463, mean = 50, sd = 10)

## Evaluate normality
hist(x)
# Symmetrical / bell-shaped = normally distributed

qqnorm(x)
qqline(x)
# Data equal to theoretical observations (straight line) -> normally distributed
# It's not uncommon for some observations at the tail-ends to deviate from line

ad.test(x)
# p > 0.05 -> do not reject H0 -> data normally distributed

## Perform indepentdent one sample t-test (if normality was confirmed)

# H0: population mean is equal to 50

# Alternative Hypothesis 1: Ha1 != 50
t.test(x, mu = 50, alternative = "two.sided")
# p > 0.05 -> do not reject Ho
# Conclusion: at a 5% significance level, the sample contradicts the claim
# that the population mean is not 50
# thus the population mean is 50 (as stated in Ho)

# Alternative Hypothesis 2: Ha2 > 50
t.test(x, mu = 50, alternative = "greater")
# p > 0.05 -> do not reject Ho
# Conclusion: at a 5% significance level, the sample contradicts the claim
# that the population mean is greater than 50
# thus the population mean is 50 (as stated in Ho)

# Alternative Hypothesis 3: Ha3 < 50
t.test(x, mu = 50, alternative = "less")
# p > 0.05 -> do not reject Ho
# Conclusion: at a 5% significance level, the sample contradicts the claim
# that the population mean is less than 50
# thus the population mean is 50 (as stated in Ho)

# Note: to change confidence level (alpha), add "conf.level = x" argument


## Perform indepentdent two sample t-test (if normality was confirmed)

# Two populations are said to be independent if there are no explicable
# relationship between the elements of the one population and the elements
# of the other population

# H0: u1 = u2 (two populations have the same mean)
# Ha: u1 != u2 (two population means differ)

# Draw samples from both populations and compute the sample mean for each group

##################################################

## Independent 2 sample t-test assumptions ##

# 1. Normally distributed populations (Shapiro-Wilk/informal tests)
# 2. Variances in the two populations are equal/homogenous (Bartlett's test
#    for homogeneity of variances)
# 3. Variances in the two populations are not equal (Bartlett's test for
#    equality of variances)
# 4. Scores from different participants are independent
# 5. Data are measured at least on an interval scale (continous data)

## Import data
# The file Lung_capacity.csv contains lung capacity scores of 24 people
# People in Group 0 are smokers
# People in Group 1 are non-smokers
lungCap <- read.csv("data/Lung_capacity.csv", header = TRUE)

# 1. Assess whether the populations are normally distributed or not
# Ho: data is normally distributed
# Ha: data is not normally distributed
shapiro.test(lungCap$capacity[lungCap$group==0]) #p=0.8523
shapiro.test(lungCap$capacity[lungCap$group==1]) #p=0.6206
# not significant -> do not reject Ho -> data normally distributed
# Note: if data was NOT normally distributed, do nonparametric test


# 2. Assess if variances in two populations are equal or not
# Ho: variances are equal (homogenenous)
# Ha: variances are not equal (heterogeneous)
bartlett.test(lungCap$capacity~lungCap$group) #p=0.5795
# p = not significant -> do not reject Ho -> variances are equal -> 
# use var.equal = TRUE in t-test
# note: if variances are not equal (i.e. Ho rejected) -> 
# use var.equal = FALSE in t-test

# 3. Perform hypothesis test
# Ho: u1 = u2
# Ha: u1 != u2
t.test(lungCap$capacity~lungCap$group,
       mu = 0,
       var.equal = TRUE,
       alternative = "two.sided")
# p = not significant -> do not reject Ho -> population means are the same
# 95% confidence in difference in the mean values
# hypothesis not easily rejected with small sample sizes such as this one
# Conclusion: At a 5% significance level, there is not a statistical
# significant difference between the mean lung capacity of the two groups

# 4. Assess the effect sizes
# CohensD value:
# d=0.2 -> no practically significant difference
# d=0.5 -> practically visible difference
# d=0.8 -> practically significant difference

cohensD(lungCap$capacity~lungCap$group) #0.686
# Conclusion: there is a medium or practically visible difference

##################################################

## Dependent 2 sample t-test ##

# Populations are dependent on each other if observations in one population
# can be associated with observations in another population
# Example: baseline and follow-up study

# Using a 5% level of significance, evaluate the effectiveness of an
# exercise program for weight loss

# Import data
exercise <- read.csv("data/Exercise.csv", header = TRUE)
# Note: normally your data set would not already have the "difference" variable

# Create new variable
difference <- exercise$Weight_Before - exercise$Weight_After
# Now you have a single sample variable

# Test for normality
shapiro.test(difference) #p=0.5699
# large p value -> not significant -> do not reject Ho -> data normally distributed

# Single sample t-test
t.test(difference, mu = 0, alternative = "two.sided")
# small p-value -> reject Ho -> there is a statistically significant
# difference in mean weight before and after exercise program

# Calculate effect size
Bmean <- mean(exercise$Weight_Before)
Amean <- mean(exercise$Weight_After)
Bsd <- sd(exercise$Weight_Before)
Asd <- sd(exercise$Weight_After)

effect <- abs(Bmean-Amean)/max(Asd,Bsd) #0.183
# no practical significant difference


##################################################

## Comparing several means (One-way ANOVA) ##

# ANOVA = used to compare means for several independent groups
# Post-hoc tests = determine which ones are the same and which ones not
# Non-parametric test (Kruskal-Wallis) = if assumptions are violated ( p < 0.05)

# Assumptions
# 1. Populations are normally distributed (shapiro.wilk / normal probability plot)
# 2. Populations have equal variance (Levene's test / residual plots)
# 3. Independent observations
# 4. Interval-scaled (continuous) measurements (dependent variable)

# H0: u1 = u2 = u3 = u4
# Ha: u1, u2, u3 and u4 not equal


# Import data
# Energy levels of people who have each been given either placebo, low dose, or
# high dose of a new drug
Energy <- read.csv("data/Energy.csv", header = TRUE)

## Summary of steps for one-way ANOVA:
# 1. Fit the ANOVA model to get residuals (aov function)
# 2. Test assumptions (normality and equal variance)
# 3. Test the main hypothesis
# 4. Post hoc test (if H0 is rejected, check which specific means differ)

# STEP 1 - fit ANOVA model #
# Create an aov object (incorrect)
energy.mod.wrong <- aov(Energy$energy~Energy$dose) #not using factor()
energy.mod.wrong[]

# Run anova to get output
anova(energy.mod.wrong)
# Incorrect degrees of freedom (df = 1) -> should be 2 (number of groups (3) - 1)

# Create an aov object (correct)
energy.mod <- aov(Energy$energy~factor(Energy$dose))
energy.mod[]

# STEP 3 - test main hypothesis #
# Run anova to get output
anova(energy.mod) #Df = 2 (correct), p = 0.025
# p is less than alpha -> reject Ho
# Not all 3 dosage groups produce the same population mean energy levels
# At least one dosage group produces population mean energy level that is
# different from the other two
# BUT, we have to be cautious, because we didn't check that all assumptions were met!

# STEP 2 - test assumptions #
# Levene test - check for equal variances
install.packages("car")
library(car)

leveneTest(Energy$energy~factor(Energy$dose), center = median) 
# robust against outliers and preferred approach
# Df = 2 (correct), p = 0.89 -> do not reject Ho, i.e. variances are equal

leveneTest(Energy$energy~factor(Energy$dose), center = mean) 
# alternative, but not robust against outliers

# Testing for variance equality with graphical test
# First extract residuals from aov object
res <- energy.mod$residuals
res
# Plot the group levels (dose) against residuals
plot(energy$dose, res, pch = 16, cex = 2, col="red")
# distribution looks roughly the same, i.e. variances are equal

# Test for normality (using residuals)
hist(res)

qqnorm(res)
qqline(res)
# doesn't look very normally distributed

shapiro.test(res) #test whether residuals come from a normally distributed population
# p = 0.1715 -> not significant -> do not reject Ho -> errors normally distributed
# residuals are normally distributed according to shapiro test!

# STEP 4 #
# Post hoc tests
# Since Ho were rejected (i.e. not all means are equal), additional tests are needed
TukeyHSD(energy.mod)
# 95% family-wise confidence level
# different pairs (hypotheses) are tested (2-1, etc.)
# 2-1: p = 0.516 -> do not reject Ho -> 
# low dose group (2) and placebo group (1) are not significantly different

# 3-1: p = 0.021 -> reject Ho -> 
# high dose (3) and placebo (1) are significantly different

# 3-2: p = 0.147 -> do not reject Ho ->
# high dose (3) and low dose (2) are not significantly different


## Kruskal-Wallis test ##
# Non-parametric test when data is not normally distributed or
# variances are not equal
kruskal.test(Energy$energy~factor(Energy$dose))
# p = 0.045 -> reject Ho -> significantly different
# In this case, Ho was rejected -> next step is post hoc tests ->
# R doesn't have built-in function to perform these ->
# Use Bonferonni Confidence Intervals Script

## Effect sizes for post hoc tests ##

# An effect size tells us about the practical impact of the difference

# Calculate group means individually - be cautious of unsorted data!
grpMean1 <- mean(Energy$energy[1:5])
grpMean2 <- mean(Energy$energy[6:10])
grpMean3 <- mean(Energy$energy[11:15])
# OR
# Use tapply to apply mean function to all groups - recommended!
grpMeans <- tapply(Energy$energy, Energy$dose, mean)

# Calculate MSE by first getting ANOVA table
anova(energy.mod)

# Extract value in Mean Sq (3rd column) and Residuals (2nd) row
MSE <- anova(energy.mod)[2,3]

# Calculate effect sizes
abs(grpMean1-grpMean2)/sqrt(MSE) #0.713
abs(grpMean1-grpMean3)/sqrt(MSE) #1.997
abs(grpMean2-grpMean3)/sqrt(MSE) #1.284
# All effect sizes indicate practically
# significant difference between all groups tested

##################################################

## Pearson's correlation coefficient ##

# Measures the strength of a linear relationship between two continuous variables
# -1 <= r >= 1
# However, it is sensitive to outlying values


# Correlation (r) coefficient can be interpreted as an effect size measure
# 0 -> no linear relationship
# +- 0.1 -> weak +/- relationship (0.1 = practically significant relationship)
# +- 0.3 -> moderate +/- relationship (0.3 = practically visible relationship)
# +- 0.6 -> strong +/- relationship (0.5 = practically significant relationship)
# +- 1 -> perfect +/- relationship

## Assumptions of correlation analysis:
# The 2 continuous variables follow a bivariate normal distribution
# i.e. both variables have normal distribution

# Import data
violin <- read.csv("data/Violin.csv", header = TRUE)

# Scatter plot of revision vs anxiety
plot(violin$practice, violin$anxiety, pch=16)

# Calculate correlation coefficient
cor(violin$practice, violin$anxiety) #-0.709 
# strong negative linear relationsip
# this needs to be calculated for each pair of variables OR

# Calculate correlation coefficient for all pairs simultaneously
cor(violin[c("practice", "performance", "anxiety")])

# Interpret Pearson's correlation coefficient as an effect size
# practice/performance -> 0.397 -> medium effect -> practically visible relationship
# practice/anxiety -> -0.709 -> large effect -> practically significant relationship
# anxiety/performance -> -0.441 -> medium effect -> practically visible relationship

# Correlation test for hypothesis testing
# H0: population correlation is zero
cor.test(violin$practice, violin$anxiety) #r=-0.709, p=2.2e-16
# strong negative relationship, p is very small -> reject Ho -> 
# linear relationship


## Spearman's correlation coefficient ##

# Describes how well the relationship between 2 variables can be described
# using a monotonic function, i.e. if X increases, Y increases, and vice versa

# Calculate correlation coefficient
cor(violin$practice, violin$anxiety, method = "spearman") #-0.622
# strong monotonic relationship
# calculate this for each pair of variables separately OR

# Calculate correlation coefficient for all pairs simultaneously
cor(violin[c("practice", "performance", "anxiety")], method = "spearman")

## Combine plots into matrix ##
plot(violin[c("practice", "performance", "anxiety")], pch=16)

##################################################

## SIMPLE LINEAR REGRESSION ##

# Regression analysis is used to:
# 1. Predict the value of a dependent variable (Y) based on the value of
#    at least one independent variable (X)
# 2. Explain the impact of changes in an independent variable (X) on the
#    dependent variable

# Dependent variable = variable we wish to predict or explain
# Independent variable = variable used to predict or explain dependent variable


# Import data set
# We work for Verimark, selling fitness products. Our boss is interested
# in predicting product sales from advertising.
veri <- read.csv("data/Verimark.csv", header = TRUE)

# Plot data
plot(veri$adverts, veri$sales, col="red", pch=16, xlab="Advertising costs",
     ylab="Sales")

# Fit linear regression model
veri_lm <- lm(veri$sales ~ veri$adverts) #dependent variable ~ independent variable
# An "lm" type model object is created

veri_lm 
# intercept = 134.14, slope = 0.096, thus Y = 134.14 + 0.096X

abline(veri_lm) # add straight line to scatter plot

# Extract tables of test statistics and parameter estimates from model object
summary(veri_lm)
# Hypothesis testing
#Ho: B1 (slope)=0 (i.e. no linear relationship)
#Ha: B1 !=0 (i.e. linear relationship)

# p < 0.05 -> reject H0 -> significant linear relationship between X and Y
# Rsquared (coefficient of determination) = 0.3346 -> 
# only 33% of variation in Y is explained by variation in X

## MAKING PREDICTIONS ##
# Extract values of estimated coefficients from "lm" object
veri_coeff <- veri_lm$coefficients

# If you spend R5,000 on advertising, what will estimated product sales be?
veri_coeff[1]+veri_coeff[2]*5000 # veri_coeff[1] = intercept, veri_coeff[2] = slope,
# i.e. y = c + mx -> #substitute x with 5000, and m and c with respective values
# ~614 fitness products will be sold if R5,000 is spent on advertising

# Search "predict.lm" in help files to use predict function for linear model fits

# After fitting the model, make use of residuals to test assumptions, because
# error values cannot be observed
# Residual = difference between observed and predicted values

## Assumptions:
# 1. Linearity (relationship between X and Y is linear)
# 2. Independence of errors (error values are statistically independent)
# 3. Normality of errors (error values are normally distributed for any X value)
# 4. Equal variance (probability distribution of errors has constant variance)


## Extract residuals from lm object
veri_res <- veri_lm$residuals

## Test for normality of errors
# H0: data are from a normal distribution

hist(veri_res)
# bell-curved shape = normal distribution

qqnorm(veri_res)
qqline(veri_res)
# data close to straight line = normal distribution

shapiro.test(veri_res)
# p > 0.05 -> do not reject H0 -> errors are from a normal distribution


## Test for constant variance

# Load package
library(lmtest)

# Hypothesis
# H0: errors are homoscedastic (constant variance)
# Ha: errors are heteroscedastic (non-constant variance)

# Test for constant variance
# 1. Graphical (informal) test: residuals vs X
plot(veri$adverts, veri_res, col = "blue", pch = 16, 
     xlab = "Advertising costs",
     ylab = "Residuals")

abline(h=0) # adds horizontal y=0 line to the plot
# does not demonstrate constant variance

# 2. Breusch-Pagan (formal) test
bptest(veri_lm)
# p < 0.05 -> reject H0 -> errors have non-constant variance

##################################################

## MULTIPLE LINEAR REGRESSION ##

# Use verimark data set
# Y = sales, X1 = adverts, X2 = radio, X3 = rating

# Import data
veri <- read.csv("data/Verimark.csv", header = TRUE)

# Create object with all X variables
# lm(Y ~ X1+X2+X3)
veri_lm2 <- lm(sales ~ adverts + radio + rating, data = veri)

# Calculate statistics to get equation
summary(veri_lm2)
#Equation: Y = -26.6 + 0.085X1 + 3.367X2 + 11.086X3
# If all X variables are 0, then Y is negative -> can't explain, just happens

# Radj = 0.6595 (a little less than R-squared because it was penalised) ->
# Rsquared = reports the proportion of total variation in Y explained by all
# X variables taken together
# Radj =  Rsquared adjusted for the number of X variables used - > thus Radj
# penalize excessive use of unimportant independent variables

# 66% of variation in product sales could be explained by using advertising,
# amount of airplay and rating of the products

## Hypothesis testing:
# H0: no linear relationship between all of the X variables and Y
# Ha: at least one independent variable affects Y

# F-statistic p-value < 0.05 -> reject Ho -> at least one of the X variables
# are significant -> use t-test to determine which one is significant
# However, if F-statistic p-value was larger than alpha (0.05), then Ho is not
# rejected, and it means none of the variables have an influence on Y (sales)

# Look at "Coefficients" output:
# "Estimate": if adverts and airplay is fixed, then for each one unit change
# in rating, product sales will on average increase with 11.
# All 3 p values < 0.05 -> reject H0 -> all 3 independent variables are
# significant predictors of the dependent variable

## Test multiple regression model assumptions
# Assumptions are the same as in simple linear regression model
# 1. Linearity
# 2. Independence of errors
# 3. Normality of error
# 4. Equal variance

# Extract residuals
veri_lm2_res <- veri_lm2$residuals

# Test for normality: histogram (informal test)
hist(veri_lm2_res) 
#looks normally distributed

# Testing for normality: qqplot (informal test)
qqnorm(veri_lm2_res)
qqline(veri_lm2_res) 
#looks normally distributed

# Testing for normality: Shapiro-Wilk test (formal test)
shapiro.test(veri_lm2_res) 
# p > 0.05 -> do not reject Ho -> errors are normally distributed

# Test for equal variance: plot residuals vs X1, X2, X3 (informal test)
# Residuals vs X1
plot(veri$adverts, veri_lm2_res, pch=16) 
abline(h=0) #pattern of dots -> variation not constant -> assumption not met
# Residuals vs X2
plot(veri$radio, veri_lm2_res, pch=16) 
abline(h=0) #no pattern of dots -> constant variance -> assumption is met
# Residuals vs X3
plot(veri$rating, veri_lm2_res, pch=16) 
abline(h=0) #possible pattern of dots -> variation not constant -> assumption not met

# Plot fitted values (most important graphical test of constant variance)
fitted <- veri_lm2$fitted.values #extract fitted values from object
plot(fitted, veri_lm2_res, pch=16) #no pattern of dots -> constant variance -> assumption is met
abline(h=0)

# Test for equal variance: Breusch-Pagan test (formal test)
#install.packages("lmtest")
library(lmtest)
bptest(veri_lm2) 
# p > 0.05 -> do not reject Ho -> variance constant

## Assessing influential observations
# Determine which observation(s) in the data set heavily influence the
# regression equation
influence.measures(veri_lm2)
# influencial observations are indicated with * in "inf" column
# Inspect the source data to make sure these observations were correctly captured

## Detecting multicollinearity
# When 2 independent variables are very similar (e.g. Pearson's coefficient = 0.98),
# you might as well only use one variable
# These 2 (or more) independent variables are correlated (i.e. dependent on each other)

# Value of variance inflation factor > 10 indicate possible multicollinearity

# Assess multicollinearity
vif(veri_lm2) # vif = variance inflation factors
# no multicollinearity present


## Regression with categorical variables
# The rating variable is actually categorical, not continuous
# Fit the model differently to take this into account
veri_lm3 <- lm(sales ~ adverts + radio + factor(rating), data = veri)
summary(veri_lm3)
# Radj = 0.67 (versus previous 0.66)
# p value is the same



#############
## THE END ##
#############