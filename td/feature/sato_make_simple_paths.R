library(igraph)
library(dplyr)
library(data.table)
library(rlist)

#linkid, drom_node_id, to_node_id が入ったデータ.
#ある程度の距離で区切らないとall_simple_pathは帰ってこない！！

#路線ごとにcsvを作成し、路線ごとのdata_frameを作る
node<-fread("sato_road_19.csv", header=F, skip=1)

nodes_from<-node[,2,drop=F]
colnames(nodes_from)<- c('name')
nodes_to<-node[,3,drop=F]
colnames(nodes_to)<- c('name')
nodes<-unique(rbind(nodes_from, nodes_to))

edges <- node[, c(2, 3)]
edges$V2<-as.character(edges$V2)
edges$V3<-as.character(edges$V3)

g<-graph.data.frame(edges, vertices = nodes, directed=F )

#whichでindexを返す
#始点が左側, 終点を右側に入れると
#上から始点〜の順番になる
path<-all_simple_paths(g, which(nodes=="744405"), which(nodes=="7272425"))

#結果
mat <- sapply(path, as_ids)

LENG=c()
for(i in 1:(length(mat))){
  LLL=length(mat[[i]])
  LENG=c(LENG,LLL)
}
maxLENG=max(LENG)
for(i in 1:(length(mat))){
  length(mat[[i]])=maxLENG
}
tmp<-list.cbind(mat)
df_simple<-as.data.table(tmp)

#得られた複数のパスのパターンを大きい順に並べ直す（列）
count_row<-function(x){sum(table(x))}
row<-apply(df_simple, 2, count_row)

node_id<-df_simple%>%
dplyr::mutate(id=rownames(.))

interchange<-t(df_simple)
interchange<-as.data.frame(interchange)

join_row<-interchange%>%
  dplyr::mutate(row_num=row)%>%
  dplyr::arrange(desc(row_num))

tbl<-t(join_row)
tbl<-as.data.table(tbl)

#最後の行にデータ数が入っているので
#ここで最後の行だけ落とす
n<-nrow(tbl)
tbl<-tbl[1:n-1,]

write.csv(tbl, "aichi_no19_paths.csv", quote=F, row.names=F)
