library(dplyr)
library(tidyr)
library(xgboost)
library(Matrix)
library(data.table)

cpy <- function(a){
  if(is.data.frame(a) | is.matrix(a)){ write.table(a, pipe("pbcopy"), sep="\t", row.names=FALSE, quote=FALSE)
  }else write.table(t(a), pipe("pbcopy"), sep="\t", row.names=FALSE, quote=FALSE)
}

set.seed(12345)

setwd("~/Documents/data/")

data <- readRDS("table2_v6.rds")

# XGBoostを使う際は、データにfactor, 文字列を含めない
data <- data %>% 
  mutate(gender = as.integer(as.factor(gender)) - 1) 

# xgboostだと、カラム名に-とかが入っているとエラーになるバグがあるため、
# カラム名の-を_に置換する
names(data) <- gsub("-", "_", names(data))

# 9.5以上の重症度の高い人に絞ってモデルを作る
data_filtered <- data %>% 
  filter(HbA1c_a >= 9.5) %>% 
  mutate(HbA1c_kubun = as.integer(cut(HbA1c_b, 
                           breaks = c(-1, 7, 9.5, 99), right = FALSE,
                           labels = c("-7", "7-9.5", "9.5-"))) - 1)

train_rate <- 0.7

data_filtered <- as.data.frame(data_filtered)

training_row <- sample(nrow(data_filtered), nrow(data_filtered) * train_rate)

train_data <- data_filtered[training_row ,]
test_data <- data_filtered[-training_row ,]

cutoff_columns <- c("subscriber", "severity_b", "HbA1c_b", "year_b", "BMI_b", 
                    "systolic_bp_b", "diastolic_bp_b", "neutral_fat_b", "HDL_b",
                    "LDL_b", "GOT_b", "HbA1c_b", "urine_sugar_b", "urine_protein_b", "smoking_b", "year_a",
                    "HbA1c_kubun", "systolic_bp_b_cat", "LDL_b_cat", "HbA1c_b_cat")

model_data <- train_data %>% select(-one_of(cutoff_columns))

# データをmatrixに変換
dtrain<-xgb.DMatrix(data.matrix(train_data %>% select(-one_of(cutoff_columns))), label=train_data$HbA1c_kubun)
dtest<-xgb.DMatrix(data.matrix(test_data %>% select(-one_of(cutoff_columns))), label=test_data$HbA1c_kubun)

# モデルの学習
train.gdbt<-xgb.train(params=list(objective="multi:softprob", 
                                  num_class = 3,
                                  eval_metric="mlogloss",
                                  #scale_pos_weight = sumwneg / sumwpos,
                                  eta=0.2, 
                                  max_depth=5, 
                                  subsample=1, 
                                  olsample_bytree=0.5), 
                      watchlist=list(eval=dtest, train=dtrain),
                      data=dtrain, 
                      nrounds=20, 
                      early_stopping_rounds = 3)

# 予測結果を結合
pred <- predict(train.gdbt, dtest)

# softmax関数d関数で各ラベルへの所属確率を表しているため、
# もっとも確率の高いクラスを取ってくる
pred_mat <- t(matrix(pred, 3, length(pred)/3)) # 今回は3クラスあるので
colnames(pred_mat)<-c("class_-7", "class_7-9.5", "class_9.5-")
                                
data_with_pred <- 
  cbind(test_data, pred_mat) %>% 
  mutate(id = row_number())

data_with_pred <- as.data.frame(data_with_pred)

user_true_rank <- 
  data_with_pred %>% 
  select(id, `class_-7`, `class_7-9.5`, `class_9.5-`) %>% 
  tidyr::gather(key = "class", value = "prob", `class_-7`, `class_7-9.5`, `class_9.5-`) %>% 
  group_by(id) %>% 
  arrange(desc(prob)) %>% 
  top_n(1)

# クロス集計表を作る
data_with_pred2 <- data_with_pred %>% 
  inner_join(user_true_rank, by="id") %>% 
  mutate(class_pred = ifelse(class == "class_-7", 0, 
         ifelse(class == "class_7-9.5", 1, 2))) %>% 
  select(id, class_pred, HbA1c_kubun)

cross_table <- table(data_with_pred2$HbA1c_kubun, data_with_pred2$class_pred)

# 精度
cross_table
(cross_table[1,1] + cross_table[2,2] + cross_table[3,3]) / sum(cross_table)

importance_matrix <- xgb.importance(colnames(model_data), model = train.gdbt)
xgb.plot.importance(importance_matrix, rel_to_first = FALSE, xlab = "変数重要度", top_n = 20)
