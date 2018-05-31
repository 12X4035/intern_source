library(dplyr)
library(ykmeans)
library(partykit)
library(rpart)
library(tidyr)

km1<-read.csv("user_list.csv", sep=",", header=T)
km2<-read.csv("payment_log_201506.csv", sep=",", header=T)

km2_2<-km2%>%
  select(user_id)%>%
  unique()

km3<-inner_join(km1, km2_2, "user_id")
km4<-mutate(km3, av_price=(total_price/count))

km4_2<-km4
km4_2[,c("count", "av_price")]<-scale(km4_2[,c("count", "av_price")])

km5<-ykmeans(km4_2, c("count", "av_price"), "count", 3)

km4$cluster<-km5$cluster

plot(km4[,c("count", "av_price")], col=km4$cluster)
user_cluster<-select(km4, user_id, cluster)

km4%>%
  group_by(cluster)%>%
  summarise(total_price_avg = mean(total_price))

table(km4$cluster)

tr1<-read.csv("payment_log_201506.csv", sep=",", header=T)
tr2<-tr1%>%
  group_by(user_id, item_name)%>%
  summarise(n=sum(price))%>%
  spread(item_name, n)%>%
  as.data.frame()

tr2[is.na(tr2)]<-0

tr3<-inner_join(user_cluster, tr2, c("user_id"))
tr4<-filter(tr3, cluster %in% c(2,3))
tr4$cluster<-as.factor(tr4$cluster)

tr5<-rpart(cluster~., data=tr4[,2:length(tr4)])

plot(as.party(tr5))
