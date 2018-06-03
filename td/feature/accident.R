library(data.table)
library(dplyr)

d<-fread("itmd_accidents_production.csv")

aichi<-d%>%
  dplyr::filter(pref_name=="愛知県")%>%
  dplyr::filter(y==26)

%link（単路）%
link<-aichi%>%
  dplyr::filter(exchange_division_name=="単路")%>%
  dplyr::select(objectid, accident_pattern_name)%>%
  dplyr::group_by(objectid, accident_pattern_name)%>%
  dplyr::summarise(count=n())%>%
  tidyr::spread(key=accident_pattern_name, value=count)%>%
  dplyr::arrange(objectid)%>%
  dplyr::select(objectid, 車両相互, 車両単独,　人対車両, その他)

link[is.na(link)]<-0
link<-as.data.frame(link)

%node（交差点）%
node<-aichi%>%
  dplyr::filter(exchange_division_name=="交差点")%>%
  dplyr::select(node_objectid, traffic_volume_24h, accident_pattern_name)%>%
  dplyr::group_by(node_objectid, traffic_volume_24h, accident_pattern_name)%>%
  dplyr::summarise(count=n())%>%
  tidyr::spread(key=accident_pattern_name, value=count)%>%
  dplyr::arrange(node_objectid)%>%
%今回は交差点がなかったので無理やり作成%
  dplyr::mutate(その他=0)%>%
  dplyr::select(node_objectid,traffic_volume_24h, 車両相互, 車両単独,　人対車両, その他)


%謎の重複行がある可能性があるので処理する%
tmp<-node%>%
dplyr::group_by(node_objectid)%>%
dplyr::mutate(tv=mean(traffic_volume_24h), 相互=sum(車両相互), 単独=sum(車両単独), 人対=sum（人対車両), 他=sum(その他))%>%
dplyr::rename(traffic_volume_24h=tv, 車両相互=相互 , 車両単独=単独, 人対車両=車両, その他=他)

perfect<-tmp%>%
dplyr::distinct(node_objectid, traffic_volume_24h,車両相互,車両単独,人対車両,その他)

node[is.na(node)]<-0
node<-as.data.frame(node)


%postgresへダイレクトに%
library(DBI)
library(RPostgreSQL)
%postgres接続（スキーマ指定できないのかな？）%
con <- dbConnect(PostgreSQL(), host="", port=, dbname="", user="", password="")
%table確認%
dbExistsTable(con, "node_accident")
 %ppostgresに書き込み%
dbWriteTable(con, "node_accident", value = node, append = TRUE, row.names = FALSE)
dbDisconnect(con)

write.csv(link,"link_accident.csv",quote=FALSE,row.names= FALSE)
write.csv(node,"node_accident.csv",quote=FALSE,row.names= FALSE)
