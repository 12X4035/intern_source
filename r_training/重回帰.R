model<-lm(
  weight~height,
  data = body_data
)

answer<-body_data$weight
pred<-predict(model, body_data["height"])
mre<-mean(abs((pred -answer)/answer))

data.frame(answer =answer, pred =pred)%>%
  ggplot(aes(x=pred, y=answer))+
  geom_point()+
  geom_abline(slope=1, intercept=0, col="red")+
  ggtitle(sprintf("平均相対誤差:%s", percent(mre)))+
  xlab("予測した体重")+
  ylab("実際の体重")+
  theme_bw(base_family="Osaka")

model<-lm(
  weight~.,
  data = body_data[,-1]
)

answer<-body_data$weight
pred<-predict(model)
mre<-mean(abs((pred -answer)/answer))

data.frame(answer =answer, pred =pred)%>%
  ggplot(aes(x=pred, y=answer))+
  geom_point()+
  geom_abline(slope=1, intercept=0, col="red")+
  ggtitle(sprintf("平均相対誤差:%s", percent(mre)))+
  xlab("予測した体重")+
  ylab("実際の体重")+
  theme_bw(base_family="Osaka")

set.seed(71L)
idx<-sample(1:nrow(body_data),200)
body_data_train <- body_data[idx,]
body_data_test <- body_data[-idx,]


model<-lm(
  weight~.,
  data = body_data_train[,-1]
)

answer<-body_data_test$weight
pred<-predict(model, new_data=body_data_test[,c(-1,-4)])
mre<-mean(abs((pred -answer)/answer))

data.frame(answer =answer, pred =pred)%>%
  ggplot(aes(x=pred, y=answer))+
  geom_point()+
  geom_abline(slope=1, intercept=0, col="red")+
  ggtitle(sprintf("平均相対誤差:%s", percent(mre)))+
  xlab("予測した体重")+
  ylab("実際の体重")+
  theme_bw(base_family="Osaka")

