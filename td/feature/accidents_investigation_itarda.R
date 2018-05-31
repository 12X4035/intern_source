library(dplyr)
library(data.table)

d<-fread("itmd_accidents_production.csv")

#リンク
filter_link<-d%>%
  dplyr::mutate(date=as.POSIXct(d$date, format="%Y-%m-%d "))%>%
  dplyr::mutate(weekday=weekdays(date))%>%
  dplyr::mutate(weekday=ifelse(weekday=="土曜日"|weekday=="日曜日", "土日", "平日"))%>%
  dplyr::mutate(time=as.integer(substr(hour, 1,2)))%>%
  dplyr::mutate(time_section=ifelse(time>=0&time<=3, "深夜",
                             ifelse(time>=4&time<=5, "明朝",
                             ifelse(time>=6&time<=7, "早朝",
                             ifelse(time>=8&time<=9, "朝",
                             ifelse(time>=10&time<=11, "午前中",
                             ifelse(time>=12&time<=13, "正午",
                          　 ifelse(time>=14&time<=15, "午後",
                            ifelse(time>=16&time<=17, "夕方",
                            ifelse(time>=18&time<=20, "夜",
                            ifelse(time>=21&time<=23, "夜中",
                            "NA")))))))))))%>%
  dplyr::filter(exchange_division_name=="単路")%>%
  dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
  dplyr::filter(!is.na(objectid))%>%
  dplyr::group_by(weather_name, weekday, time, exchange_division_name, accident_pattern, objectid)%>%
  dplyr::mutate(accidents_count=n())%>%
  dplyr::select(weather_name, weekday, time, time_section, exchange_division_name, accident_pattern, objectid , accidents_count)%>%
  dplyr::group_by(weather_name, weekday, time, exchange_division_name, accident_pattern)%>%
  dplyr::summarise(count_place=n())






#交差点
filter_node<-d%>%
  dplyr::mutate(date=as.POSIXct(d$date, format="%Y-%m-%d "))%>%
  dplyr::mutate(weekday=weekdays(date))%>%
  dplyr::mutate(weekday=ifelse(weekday=="土曜日"|weekday=="日曜日", "土日", "平日"))%>%
  dplyr::mutate(time=as.integer(substr(hour, 1,2)))%>%
  dplyr::mutate(time_section=ifelse(time>=0&time<=3, "深夜",
                            ifelse(time>=4&time<=5, "明朝",
                            ifelse(time>=6&time<=7, "早朝",
                            ifelse(time>=8&time<=9, "朝",
                            ifelse(time>=10&time<=11, "午前中",
                            ifelse(time>=12&time<=13, "正午",
                            ifelse(time>=14&time<=15, "午後",
                            ifelse(time>=16&time<=17, "夕方",
                            ifelse(time>=18&time<=20, "夜",
                            ifelse(time>=21&time<=23, "夜中",
                            "NA")))))))))))%>%
  dplyr::filter(exchange_division_name=="交差点")%>%
  dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
  dplyr::filter(!is.na(objectid))%>%
  dplyr::group_by(weather_name, weekday, time, exchange_division_name, accident_pattern, objectid)%>%
  dplyr::mutate(accidents_count=n())%>%
  dplyr::select(weather_name, weekday, time, time_section, exchange_division_name, accident_pattern, objectid , accidents_count)%>%
  dplyr::group_by(weather_name, weekday, time, exchange_division_name, accident_pattern)%>%
  dplyr::summarise(count_place=n())


accidents_place_summary<-dplyr::bind_rows(filter_link, filter_node)

write.csv(accidents_place_summary, "accidents_place_prefecture.csv", quote=F, row.names=F, fileEncoding="CP932")

###県ごとでの事故地点数(詳細ver.)
#リンク
filter_link<-d%>%
  dplyr::filter(exchange_division_name=="単路")%>%
  dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
  dplyr::filter(!is.na(objectid))%>%
  dplyr::group_by(pref_name, exchange_division_name, accident_pattern, objectid)%>%
  dplyr::mutate(accidents_count=n())%>%
  dplyr::select(objectid, pref_name, exchange_division_name, accident_pattern, accidents_count)%>%
  dplyr::group_by(pref_name, exchange_division_name, accident_pattern)%>%
  dplyr::summarise(count_place=n())



#交差点
filter_node<-d%>%
  dplyr::filter(exchange_division_name=="交差点")%>%
  dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
  dplyr::filter(!is.na(objectid))%>%
  dplyr::group_by(pref_name, exchange_division_name, accident_pattern, objectid)%>%
  dplyr::mutate(accidents_count=n())%>%
  dplyr::select(pref_name, exchange_division_name, accident_pattern, objectid , accidents_count)%>%
  dplyr::group_by(pref_name, exchange_division_name, accident_pattern)%>%
  dplyr::summarise(count_place=n())

accidents_place_summary<-dplyr::bind_rows(filter_link, filter_node)

write.csv(accidents_investigation_prefecture, "accidents_investigation_prefecture.csv", quote=F, row.names=F, fileEncoding="CP932")


###県ごとでの事故地点ごとの事故件数・Randomforestで使用するもの
#リンク
filter_link<-d%>%
  dplyr::filter(exchange_division_name=="単路")%>%
  dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
  dplyr::filter(!is.na(objectid))%>%
  dplyr::group_by(pref_name, exchange_division_name, accident_pattern_name, objectid)%>%
  dplyr::summarise(accidents_count=n(),  tv=mean(traffic_volume, na.rm=T), tv_12h=mean(traffic_volume_12h, na.rm=T), tv_24h=mean(traffic_volume_24h, na.rm=T))%>%
  dplyr::mutate(accidents_rate=accidents_count/tv, accidents_rate_12h=accidents_count/tv_12h, accidents_rate_24h=accidents_count/tv_24h)%>%
  dplyr::select(objectid, pref_name, exchange_division_name, accident_pattern_name, accidents_count, accidents_rate, accidents_rate_12h, accidents_rate_24h)


#交差点
filter_node<-d%>%
  dplyr::filter(exchange_division_name=="交差点")%>%
  dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
  dplyr::filter(!is.na(node_objectid))%>%
  dplyr::group_by(pref_name, exchange_division_name, accident_pattern_name, node_objectid)%>%
  dplyr::summarise(accidents_count=n(), tv=mean(traffic_volume, na.rm=T), tv_12h=mean(traffic_volume_12h, na.rm=T), tv_24h=mean(traffic_volume_24h, na.rm=T))%>%
  dplyr::mutate(accidents_rate=accidents_count/tv, accidents_rate_12h=accidents_count/tv_12h, accidents_rate_24h=accidents_count/tv_24h)%>%
  dplyr::select(node_objectid, pref_name, exchange_division_name, accident_pattern_name, accidents_count,  accidents_rate, accidents_rate_12h, accidents_rate_24h)%>%
  dplyr::rename("objectid"=node_objectid)

  accidents_rf<-dplyr::bind_rows(filter_link, filter_node)
  
  write.csv(accidents_rf, "accidents_rf.csv", quote=F, row.names=F, fileEncoding="CP932")
  
###県ごとでの事故地点ごとの事故件数・Randomforestで使用するもの（詳細ver.）
  filter_link<-d%>%
    dplyr::filter(exchange_division_name=="単路")%>%
    dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
    dplyr::filter(!is.na(objectid))%>%
    dplyr::group_by(pref_name, exchange_division_name, accident_pattern, objectid)%>%
    dplyr::summarise(accidents_count=n(), tv=mean(traffic_volume, na.rm=T), tv_12h=mean(traffic_volume_12h, na.rm=T), tv_24h=mean(traffic_volume_24h, na.rm=T))%>%
    dplyr::mutate(accidents_rate=accidents_count/tv, accidents_rate_12h=accidents_count/tv_12h, accidents_rate_24h=accidents_count/tv_24h)%>%
    dplyr::select(objectid, pref_name, exchange_division_name, accident_pattern, accidents_count, accidents_rate, accidents_rate_12h, accidents_rate_24h)
  
  
  
  #交差点
  filter_node<-d%>%
    dplyr::filter(exchange_division_name=="交差点")%>%
    dplyr::mutate(accident_pattern=paste(accident_pattern_name, accident_pattern_sub_name, sep=""))%>%
    dplyr::filter(!is.na(node_objectid))%>%
    dplyr::group_by(pref_name, exchange_division_name, accident_pattern, node_objectid)%>%
    dplyr::summarise(accidents_count=n(), tv=mean(traffic_volume, na.rm=T), tv_12h=mean(traffic_volume_12h, na.rm=T), tv_24h=mean(traffic_volume_24h, na.rm=T))%>%
    dplyr::mutate(accidents_rate=accidents_count/tv, accidents_rate_12h=accidents_count/tv_12h, accidents_rate_24h=accidents_count/tv_24h)%>%
    dplyr::select(node_objectid, pref_name, exchange_division_name, accident_pattern, accidents_count, accidents_rate, accidents_rate_12h, accidents_rate_24h)
  
  
accidents_rf_sub<-dplyr::bind_rows(filter_link, filter_node)

write.csv(accidents_rf_sub, "accidents_rf_sub.csv", quote=F, row.names=F, fileEncoding="CP932")
