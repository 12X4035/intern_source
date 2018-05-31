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
#
#Python pandas では空白もnullと判別する.
#Rでは読み込みの際に空白のところはNAとして扱うようにしないと
#正確な欠損値の数を捉えられない.
#
df_train<-read.csv("train.csv", na.strings = (c("NA", "")))
df_test<-read.csv("test.csv", na.strings = (c("NA", "")))

na_count_train<-sapply(df_train, function(y) sum(is.na(y)))
#

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
##
a<-df_train%>%
  dplyr::group_by(Title)%>%
  dplyr::summarise(age=median(Age, na.rm=TRUE))%>%
  tidyr::spread(Title, age)

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

#######################
name_sep_train<-str_split_fixed(df_train$Name, "[,.]", 3)
name_sep_train<-as.data.frame(name_sep_train)

colnames(name_sep_train)<-c("Surname","Honorific","Givenname")

df_train$Name<-name_sep_train[,1:2]
#name(test)
name_sep_test<-str_split_fixed(df_test$Name, "[,.]", 3)
name_sep_test<-as.data.frame(name_sep_test)
colnames(name_sep_test)<-c("Surname","Honorific","Givenname")

df_test$Name<-name_sep_test[,1:2]
#####################


#make dummy variables
df_train_sub<-makedummies(df_trai_age,basal_level=TRUE, as.is=c("Name", "Ticket", "Cabin"))
df_train_sub$age<-as.integer(df_train_sub$age)

df_test_sub<-makedummies(df_test_age,basal_level=TRUE, as.is=c("Name", "Ticket", "Cabin"))
df_test_sub$age<-as.integer(df_test_sub$age)

#remove Cabin
df_train_mod<-df_train%>%
  dplyr::select(-PassengerId,-Ticket, -Cabin)

df_test_mod<-df_test%>%
  dplyr::select(-PassengerId,-Ticket, -Cabin)

#remove Age`s NA
df_train_mod$Age<-ifelse(is.na(df_train_mod$Age), mean(df_train_mod$Age,na.rm=TRUE), df_train_mod$Age)
df_test_mod$Age<-ifelse(is.na(df_test_mod$Age), mean(df_test_mod$Age,na.rm=TRUE), df_test_mod$Age)

#insert Embarked`s NA
df_train_mod$Embarked<-as.factor(df_train_mod$Embarked)
df_test_mod$Embarked<-as.factor(df_test_mod$Embarked)
df_train_mod$Embarked<-ifelse(is.na(df_train_mod$Embarked), 3, df_train_mod$Embarked)
df_test_mod$Embarked<-ifelse(is.na(df_test_mod$Embarked), 3, df_test_mod$Embarked)
#test of  Fare`s NA
df_test_mod$Fare<-ifelse(is.na(df_test_mod$Fare), median(df_test_mod$Fare,na.rm=TRUE), df_test_mod$Fare)

#SVM
fit<-ksvm(
  as.factor(Survived)~.,
  data = df_train_mod
)

pred <- predict(fit, df_test_mod)

x<-data.frame(PassengerId=df_test$PassengerId, Survived=pred)

write.csv(x,"Random_Forest.csv", quote=FALSE, row.names=FALSE)



#Random Forest
random_f<-ranger(
  Survived~.,
  data = df_train_mod,
  write.forest = TRUE
)

#predict
result<-predict(random_f, data = df_test_mod)
result<-ifelse(result$predictions>=0.5, 1, 0)
x<-data.frame(PassengerId=df_test$PassengerId, Survived=result)


train <- df_train %>% 
  separate("Name", into=c("Last_Name", "Title"), sep=",") %>% 
  mutate(Title = gsub("\\..+$", "", Title)) %>% 
  mutate(Title = gsub(" ", "", Title))


