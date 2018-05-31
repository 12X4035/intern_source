g<-ggplot(data, aes(x = Date,y = Sale, group = Item))+
  geom_line(aes(color = Item))+
  geom_point(aes(color = Item))+
  xlab("日付")+ylab("売上")+
  ggtitle("2016年4月売上推移")+
  labs(colour = "商品")+
  scale_colour_discrete(labels = c("りんご","バナナ"))+
  scale_color_brewer(palette = "Accent")+
  scale_x_date(date_labels = "%m/%d")+
  scale_y_continuous(labels = comma)+
  theme(legend.position = "top")
print(g)


theme_set(theme_bw(base_family = "Osaka"))

display.brewer.all()

g<-ggplot(data, aes(x = Date,y = Sale, group = Item))+
  geom_bar(stat = "Identity", aes(fill = Item), position = "fill")
  
g<-ggplot(data, aes(x = Sale, group = Item))+
  geom_histogram(aes(fill = Item), bins = 4)
plot(g)

g<-ggplot(data, aes(x = Sale, group = Item))+
  geom_density(aes(fill = Item), alpha = 0.75)

set.seed(20160510)
runif(5)
runif(5)
set.seed(12345)
runif(3)
runif(3)

set.seed(20160510)
x<-rnorm(20, mean = 10, sd=2)
y<-rnorm(15, mean = 12, sd=3)
group<- c(rep("x", 20), rep("y", 15))
value<- c(x,y)
df<-data.frame(Group = group, Value = value)


g<- ggplot(df, aes(x = Value, group = Group))+
  geom_density(aes(fill = Group), alpha=0.75)
print(g)

lm(Value~Group,df)
tt.test(Value~Group,df)
aov(Value~Group,df)

summary(lm(Value~Group,df))
t.test(Value~Group,df)
aov(Value~Group,df)

Start(UKgas)

x<-ts(
  data = electric.train$consumption,
  start = c(2008, 1),
  frequency = 12
)

model<-auto.arima(
  x = x
)

forecast.data<-forecast(model, level=c(50, 95), h = 12)
plot(forecast.data)

forecasted <- as.data.frame(forecast.data)
test<-electric.test %>%

forecasted$month <- electric.test$month
forecasted$consumption <- electric.test$consumption


names(forecasted)[1]<-"forecast"
names(forecasted)[2]<-"Lo50"
names(forecasted)[3]<-"Hi50"
names(forecasted)[4]<-"Lo95"
names(forecasted)[5]<-"Hi95"

g<-ggplot(forecasted,aes(x = month, y = consumption))+
   geom_line()+
   geom_point()+
   geom_line(aes(y = forecast), col = "blue", lwd = 1)+
   geom_ribbon(aes(ymin = Lo50, ymax = Hi50), alpha = 0.3, fill = "blue")+
  geom_ribbon(aes(ymin = Lo95, ymax = Hi95), alpha = 0.2)
   scale_y_continuous(label = comma)
 plot(g)
 
 