library(dplyr)
library(ranger)
library(ggplot2)
library(scales)
library(tidyr)

model<-ranger(
  Price~.,
  data = train.data,
  write.forest = TRUE,
  mtry = 12
)

result<-predict(model, data=test.data)

lim<-c(0, max(result$predictions, answer))
data.frame(Predict = result$predictions, Answer = answer)%>%
  ggplot(aes(x=Predict, y=Answer))+
  geom_point()+
  geom_abline(
    intercept = 0, slope = 1,
    colour = "red", lwd= 1.5
  )+
  xlab("予測価格")+ylab( "実価格")+
  scale_x_continuous(label = comma, limits = lim)+
  scale_y_continuous(label = comma, limits = lim)+
  theme_bw(base_family = "Osaka")+
  coord_fixed()

rmse<-mean((result$predictions-answer)^2)
  