#Package Require----
library(tidyverse)
library(readxl)
library(dplyr)
library(ggplot2)
library(psych)
library(summarytools)
library(pscl)
library(performance)

# Import the data----
df <- read_xlsx('~/R/Individual/bankloan.xlsx') 

# Methodology----
## 1.Sample----
### Using the slice_sample function to randomly select the sample from the population
set.seed(158)
sample_df<-slice_sample(df,n = 500)


## 2.Explore----
###Provide an overview of the data structure
glimpse(df)


### 2.1 Statistic Summary----
####Exclude categorical value within the dataset
summary(sample_df)
stat_df <- sample_df %>%
  select(-ID,
         -ZIP.Code,
         -Education,
         -Personal.Loan,
         -Securities.Account,
         -CD.Account,
         -Online,
         -CreditCard)

describe(stat_df)


### 2.2 Uni-variate Analysis ----
theme_set(theme_bw())

#### 2.2.1 Count plot for Personal Loan----
sample_df %>%
  ggplot(aes(x = factor(Personal.Loan), fill = factor(Personal.Loan)))+
  geom_bar()+
  geom_text(stat = 'count', aes(label = scales::percent(..prop..),
                                 group = 1),
             position = position_stack(vjust = 0.5)) +
  labs(title='Bar Graph (Personal Loan Approval)',
       x='Loan Status',
       y='Count',
       caption = 'Image 2')+
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))


#### 2.2.2 Box plot for Income----
summary(sample_df$Income)

sample_df %>%
  ggplot(aes(y=Income))+
  geom_boxplot()+
  theme_update()+
  theme(aspect.ratio = 1.5)+
  labs(caption = 'Image 3',
       title = 'Boxplot (Income)')+
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))
  

#### 2.2.3 Box Plot for Age----
summary(sample_df$Age)

sample_df %>%
  ggplot(aes(y=Age))+
  geom_boxplot()+
  theme_update()+
  theme(aspect.ratio = 1.5)+
  labs(caption = 'Image 4',
       title = 'Boxplot (Age)')+
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))


#### 2.2.3 Box Plot for Credit Card Avg Score----
summary(sample_df$CCAvg)

sample_df %>%
  ggplot(aes(y = CCAvg))+
  geom_boxplot()+
  theme_update()+
  theme(aspect.ratio = 1.5)+
  labs(caption = 'Image 5',
       title = 'Boxplot (Credit Card Average Score)')+
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))


boxplot(sample_df$CCAvg)
summary(sample_df$CCAvg)


boxplot_values <- boxplot(sample_df$CCAvg)$stats


print(boxplot_values)


### 2.3 Bi-variate Analysis (Box Plot in Group)----
#### Age Range created
sample_df$Age_range <- cut(sample_df$Age, 
                           breaks =c(20,30,40,50,60,70),
                           labels = c('21-30','31-40','41-50','51-60','61-70'))




#### 2.3.1 Box plot for Income in relation to Approve Loan----
sample_df %>%
  ggplot(aes(Personal.Loan,Income, color=as.factor(Personal.Loan)))+
  geom_boxplot()+
  labs(title = 'Box Plot',
       caption = 'Image 6',
       x = 'Approval of Personal Loan',
       y = '$')+
  theme_update()+
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))


sample_df %>%
  ggplot(aes(Personal.Loan,CCAvg, color=as.factor(Personal.Loan)))+
  geom_boxplot()+
  labs(title = 'Box Plot',
       caption = 'Image 5',
       x = 'Approval of Personal Loan',
       y = '$')+
  theme_update()+
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))


##### Assuming 'sample_df' is your data frame with 'Income' and 'Personal.Loan' variables
by_group_stats <- with(sample_df, by(Income, Personal.Loan, FUN = quantile))


##### View the quartiles for each group
print(by_group_stats)


##### 2.3.2 Bar Chart for Age in relation to Approve Loan----
sample_df %>%
  group_by(Age_range, Personal.Loan) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  group_by(Age_range) %>%
  mutate(percentage = count / sum(count) * 100) %>%
  ggplot(aes(x = Age_range,
             y = count, fill = as.factor(Personal.Loan))) +
  geom_bar(stat = 'identity',
           position = 'dodge',
           alpha = 0.7) +
  geom_text(aes(label = sprintf("%.1f%%", percentage)), 
            position = position_dodge(width = 0.9),
            vjust = -0.5, size = 3) + 
  labs(title = 'Count and Percentage of Approval Loans by Age Range',
       caption = 'Image 6',
       x = 'Age Range',
       y = 'Count') +
  theme_update() +
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))


#### 2.3.3 Scatter plot for Credit card Avg Score and Income Relation ----
sample_df %>%
  ggplot(aes(CCAvg,Income))+
  geom_point()+
  theme_update()+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title= 'Scatter Plot for Credit Card Avg Score & Income',
       caption = 'Image 7',
       x = 'Average Score')+
  theme_update()+
  theme(plot.title = element_text(hjust = 0),
        plot.caption = element_text(hjust = 0))



## 3.Modify ----
### 3.1 Converting variables into categorical characteristics----
sample_df$Family <- as.factor(sample_df$Family)
sample_df$Education <- as.factor(sample_df$Education)
sample_df$Personal.Loan <- as.factor(sample_df$Personal.Loan)
sample_df$Securities.Account <- as.factor(sample_df$Securities.Account)
sample_df$CD.Account <- as.factor(sample_df$CD.Account)
sample_df$Online <- as.factor(sample_df$Online)
sample_df$CreditCard <- as.factor(sample_df$CreditCard)



### 3.2 Rename Variables ----
sample_df <- sample_df %>% 
  rename(Online.Banking = Online,
         Credit.Card = CreditCard,
         Credit.Card.Avg = CCAvg)



### 3.3 Search & Removal of NA value---- 
which(is.na(sample_df)) 


### 3.4 Search & Removal of duplicate value ----
which(duplicated(sample_df)) 


### 3.5 Removal of variables ----
sample_df$ID = NULL


sample_df$ZIP.Code = NULL


sample_df$Experience = NULL


sample_df$Credit.Card = NULL


sample_df$Age_range = NULL

## 4. Statistical Analysis ----


#### 4.1 Statistical Modeling ----
##### Model 1----
model1 <- glm(Personal.Loan~., data = sample_df, family = binomial)
summary(model1)


##### Model 2 ----
model2 <- update(model1, . ~ . - Credit.Card.Avg)
summary(model2)

###### Anova Test
anova(model1, model2, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model2)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model2, n_bins=10)

##### Model 3 ----
model3 <- update(model2, . ~ . - Mortgage)
summary(model3)

###### Anova Test
anova(model1, model3, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model3)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model3, n_bins=10)

##### Model 4 ----
model4 <- update(model3, . ~ .- Securities.Account)
summary(model4)

###### Anova Test
anova(model1, model4, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model4)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model4, n_bins=10)

###### Model 5 ----
model5 <- update(model4, . ~ .- Online.Banking)
summary(model5)

###### Anova Test
anova(model1, model5, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model5)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model5, n_bins=10)

###### Model 6 the highest score ---- 
model6 <- update(model5, . ~ .- Age)
summary(model6)

###### Anova Test
anova(model1, model6, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model6)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model6, n_bins=10)

 #the highest
###### Model 7 ----
model7 <- update(model6, . ~ .- Family)
summary(model7)

###### Anova Test
anova(model1, model7, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model7)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model7, n_bins=10)

###### Model 8 ----
model8 <- update(model7, . ~ .- CD.Account)
summary(model8)

###### Anova Test
anova(model1, model8, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model8)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model8, n_bins=10)

###### Model 9 ----
model9 <- glm(Personal.Loan~ Age + Income + Education, data = sample_df, family = binomial)
summary(model9)

model10 <- glm(Personal.Loan~ Income + Education, data = sample_df, family = binomial)
summary(model10)

###### Anova Test
anova(model9, model10, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model8)['McFadden'], Model2=pR2(model9)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model9, n_bins=10)

###### Model 10 ----
model10 <- update(model1, . ~ . - Age)
summary(model10)

###### Anova Test
anova(model1, model10, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model10)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model10, n_bins=10)

##### Model 11 ----
model11 <- update(model10, . ~ . - Online.Banking)
summary(model11)

###### Anova Test
anova(model1, model11, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model11)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model11, n_bins=10)


##### Model 12 ----
model12 <- update(model11, . ~ . - Mortgage)
summary(model12)

###### Anova Test
anova(model1, model12, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model12)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model12, n_bins=10)


##### Model 13 ----
model13 <- update(model12, . ~ . - Mortgage)
summary(model13)

###### Anova Test
anova(model1, model13, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model13)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model13, n_bins=10)


##### Model 14 ----
model14 <- update(model13, . ~ . - Securities.Account)
summary(model14)

###### Anova Test
anova(model1, model14, test = 'Chisq')


###### Pseudo R2
list(Model1=pR2(model1)['McFadden'], Model2=pR2(model14)['McFadden'])


###### The hosmer-Lemeshow Goodness-of-fit Test
performance_hosmer(model14, n_bins=10)
