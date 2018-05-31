fit<-glm(
  Survived~.,
  data = titanic,
  family = binomial
)

pred<-predict(fit, type = "response")
pred<-ifelse(pred>=0.5,1,0)
tbl<-table(titanic$Survived, pred)

sum(diag(tbl))/sum(tbl)

set.seed(71L)
idx<-sample(1:nrow(titanic),1000)
titanic_train<-titanic[idx,]
titanic_test<-titanic[-idx,]

fit<-glm(
  Survived~.,
  data = titanic,
  family = binomial
)
pred<-predict(fit, type="response", newdata=titanic_test)
pred<-ifelse(pred>=0.5,1,0)
tbl<-table(titanic_test$Survived, pred)
