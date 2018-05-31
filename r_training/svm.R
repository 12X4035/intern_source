library(kernlab)
library(caret)

load("titanic-2.RData")

set.seed(71L)
idx<-sample(1:nrow(titanic2), 1000)
titanic_train<-titanic2[idx,]
titanic_test<-titanic2[-idx,]

fit<-ksvm(
  Survived~.,
  data =titanic_train
)

pred<-predict(fit, titanic_test)
tbl<-table(titanic_test$Survived, pred)

fit<-train(
  Survived~.,
  data =titanic_train,
  method="svmRadial"
)

