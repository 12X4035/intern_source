library(dplyr)
library(GGally) 
library(ggplot2)
library(makedummies)
library(ranger)
library(scales)
library(stringr)
library(tidyr)
library(kernlab)
library(caret)

df_train<-read.csv("train.csv", na.strings = (c("NA", "")))
df_test<-read.csv("test.csv", na.strings = (c("NA", "")))


##separate Name
#(train)
df_train <- df_train %>% 
  separate("Name", into=c("Last_Name", "Title"), sep=",") %>% 
  mutate(Title = gsub("\\..+$", "", Title)) %>% 
  mutate(Title = gsub(" ", "", Title))
#(test)
df_test <- df_test %>% 
  separate("Name", into=c("Last_Name", "Title"), sep=",") %>% 
  mutate(Title = gsub("\\..+$", "", Title)) %>% 
  mutate(Title = gsub(" ", "", Title))

#中央値で補完（Age）
#(train)
df_train_age<-df_train%>%
  dplyr::mutate(age=ifelse(Title=="Mr"&is.na(Age), 30,
                           ifelse(Title=="Mrs"&is.na(Age), 35,
                                  ifelse(Title=="Dr"&is.na(Age), 46.5,
                                         ifelse(Title=="Master"&is.na(Age), 3.5,
                                                ifelse(Title=="Miss"&is.na(Age), 21, Age))))))%>%
  dplyr::select(-Age)
#(test)
df_test_age<-df_test%>%
  dplyr::mutate(age=ifelse(Title=="Mr"&is.na(Age), 28.5,
                           ifelse(Title=="Mrs"&is.na(Age), 36.5,
                                  ifelse(Title=="Ms"&is.na(Age), 28,
                                         ifelse(Title=="Master"&is.na(Age), 7,
                                                ifelse(Title=="Miss"&is.na(Age), 22, Age))))))%>%
  dplyr::select(-Age)

#敬称のダミー化
df_train_dummy<-df_train_age%>%
  dplyr::mutate(title=ifelse(Title=="Mr", 1,
                      ifelse(Title=="Mrs", 2,
                      ifelse(Title=="Miss", 3,4))))

df_test_dummy<-df_test_age%>%
  dplyr::mutate(title=ifelse(Title=="Mr", 1,
                             ifelse(Title=="Mrs", 2,
                                    ifelse(Title=="Miss", 3,4))))

#データの整形
df_train_mod<-df_train_dummy%>%
  dplyr::select(-Cabin, -Title, -Last_Name, -Ticket, -PassengerId)

df_test_mod<-df_test_dummy%>%
  dplyr::select(-Cabin, -Title, -Last_Name, -Ticket, -PassengerId)

df_train_mod$Embarked<-ifelse(is.na(df_train_mod$Embarked), 3, df_train_mod$Embarked)
df_test_mod$Embarked<-ifelse(is.na(df_test_mod$Embarked), 3, df_test_mod$Embarked)

df_test_mod$Fare<-ifelse(is.na(df_test_mod$Fare), median(df_test_mod$Fare,na.rm=TRUE), df_test_mod$Fare)

fit<-ksvm(
  as.factor(Survived)~.,
  data = df_train_mod
)

pred <- predict(fit, df_test_mod)

x<-data.frame(PassengerId=df_test$PassengerId, Survived=pred)

write.csv(y,"RF.csv", quote=FALSE, row.names=FALSE)

#RF
random_f<-ranger(
  Survived~.,
  data = df_train_mod,
  write.forest = TRUE
)
result<-predict(random_f, data = df_test_mod)
result<-ifelse(result$predictions>=0.5, 1, 0)
y<-data.frame(PassengerId=df_test$PassengerId, Survived=result)
