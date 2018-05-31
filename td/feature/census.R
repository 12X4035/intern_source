library(dplyr)
library(data.table)

lf<-list.files(path = "census", full.names = T)
census<- do.call(rbind, lapply(lf,fread, header=F, skip=1))

road_name<-census%>%
  dplyr::mutate(V1=formatC(V1, width=11, flag=0))%>%
  dplyr::mutate(V8=formatC(V8, width=11, flag=0))%>%
  dplyr::mutate(V13=formatC(V13, width=11, flag=0))%>%
  dplyr::mutate(prefecture=substring(V1, 1, 2))%>%
  dplyr::mutate(from_prefecture=substring(V8, 1,2), from_class=substring(V8, 3,3), from_no=substring(V8, 4,7))%>%
  dplyr::mutate(to_prefecture=substring(V13, 1,2), to_class=substring(V13, 3,3), to_no=substring(V13, 4,7))%>%
  dplyr::select(V1, V8, V13, prefecture, from_prefecture, from_class, from_no, to_prefecture, to_class, to_no)

