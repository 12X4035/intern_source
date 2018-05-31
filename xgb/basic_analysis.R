library(dplyr)
library(tidyr)
library(xgboost)
library(Matrix)
library(data.table)
library(rBayesianOptimization)
library(MlBayesOpt)
library(imputeMissings)
library(simputation)
library(caret)
library(GGally)
library(ggplot2)

cpy <- function(a){
  if(is.data.frame(a) | is.matrix(a)){ write.table(a, pipe("pbcopy"), sep="\t", row.names=FALSE, quote=FALSE)
  }else write.table(t(a), pipe("pbcopy"), sep="\t", row.names=FALSE, quote=FALSE)
}

set.seed(12345)

setwd("")
setwd("~/Documents/")


data <- readRDS("table2_v6.rds")


#<欠損値の処理>

## subscriberごとの平均値を求める
subscriber_mean_a<-table2_v6%>%
  group_by(subscriber)%>%
  summarise_each(funs(mean(.)), BMI_a, systolic_bp_a, diastolic_bp_a, neutral_fat_a, HDL_a, LDL_a, GOT_a, HbA1c_a,
                 urine_sugar_a, urine_protein_a, systolic_bp_a_cat, LDL_a_cat, HbA1c_a_cat, severity_a,n_hospital_interval,n_treatment_month_interval,
                 visit_interval,max_tazai_cnt)%>%
  rename(
    BMI_a_sub_mean = BMI_a,
    systolic_bp_a_sub_mean = systolic_bp_a,
    diastolic_bp_a_sub_mean = diastolic_bp_a,
    neutral_fat_a_sub_mean = neutral_fat_a,
    HDL_a_sub_mean = HDL_a,
    LDL_a_sub_mean = LDL_a,
    GOT_a_sub_mean = GOT_a,
    HbA1c_a_sub_mean = HbA1c_a,
    urine_sugar_a_sub_mean = urine_sugar_a,
    urine_protein_a_sub_mean = urine_protein_a,
    systolic_bp_a_cat_sub_mean = systolic_bp_a_cat,
    LDL_a_cat_sub_mean = LDL_a_cat,
    HbA1c_a_cat_sub_mean = HbA1c_a_cat,
    severity_a_sub_mean = severity_a,
    n_hospital_interval_sub_mean = n_hospital_interval,
    n_treatment_month_interval_sub_mean = n_treatment_month_interval,
    visit_interval_sub_mean = visit_interval,
    max_tazai_cnt_sub_mean = max_tazai_cnt
  )

##subscriberの平均値で欠損を埋める
fil_mean_sub<-table2_v6%>%
  left_join(., subscriber_mean_a, by="subscriber")%>%
  mutate(
    BMI_a = ifelse(is.na(BMI_a), BMI_a_sub_mean, BMI_a), BMI_b = ifelse(is.na(BMI_b), BMI_a_sub_mean, BMI_b),
    systolic_bp_a = ifelse(is.na(systolic_bp_a), systolic_bp_a_sub_mean, systolic_bp_a),
    systolic_bp_b = ifelse(is.na(systolic_bp_b), systolic_bp_a_sub_mean, systolic_bp_b),
    diastolic_bp_a = ifelse(is.na(diastolic_bp_a), diastolic_bp_a_sub_mean, diastolic_bp_a),
    diastolic_bp_b = ifelse(is.na(diastolic_bp_b), diastolic_bp_a_sub_mean, diastolic_bp_b),
    neutral_fat_a = ifelse(is.na(neutral_fat_a), neutral_fat_a_sub_mean, neutral_fat_a),
    neutral_fat_b = ifelse(is.na(neutral_fat_b), neutral_fat_a_sub_mean, neutral_fat_b),
    HDL_a = ifelse(is.na(HDL_a), HDL_a_sub_mean, HDL_a), HDL_b = ifelse(is.na(HDL_b), HDL_a_sub_mean, HDL_b),
    LDL_a = ifelse(is.na(LDL_a), LDL_a_sub_mean, LDL_a), LDL_b = ifelse(is.na(LDL_b), LDL_a_sub_mean, LDL_b),
    GOT_a = ifelse(is.na(GOT_a), GOT_a_sub_mean, GOT_a), GOT_b = ifelse(is.na(GOT_b), GOT_a_sub_mean, GOT_b),
    HbA1c_a = ifelse(is.na(HbA1c_a), HbA1c_a_sub_mean, HbA1c_a),
    HbA1c_b = ifelse(is.na(HbA1c_b), HbA1c_a_sub_mean, HbA1c_b),
    urine_sugar_a = ifelse(is.na(urine_sugar_a), urine_sugar_a_sub_mean, urine_sugar_a),
    urine_sugar_b = ifelse(is.na(urine_sugar_b), urine_sugar_a_sub_mean, urine_sugar_b),
    urine_protein_a = ifelse(is.na(urine_protein_a), urine_protein_a_sub_mean, urine_protein_a),
    urine_protein_b = ifelse(is.na(urine_protein_b), urine_protein_a_sub_mean, urine_protein_b),
    systolic_bp_a_cat = ifelse(is.na(systolic_bp_a_cat), systolic_bp_a_cat_sub_mean, systolic_bp_a_cat),
    systolic_bp_b_cat = ifelse(is.na(systolic_bp_b_cat), systolic_bp_a_cat_sub_mean, systolic_bp_b_cat),
    LDL_a_cat = ifelse(is.na(LDL_a_cat), LDL_a_cat_sub_mean, LDL_a_cat),
    LDL_b_cat = ifelse(is.na(LDL_b_cat), LDL_a_cat_sub_mean, LDL_b_cat),
    HbA1c_a_cat = ifelse(is.na(HbA1c_a_cat), HbA1c_a_cat_sub_mean, HbA1c_a_cat),
    HbA1c_b_cat = ifelse(is.na(HbA1c_b_cat), HbA1c_a_cat_sub_mean, HbA1c_b_cat),
    severity_a = ifelse(is.na(severity_a), severity_a_sub_mean, severity_a),
    severity_b = ifelse(is.na(severity_b), severity_a_sub_mean, severity_b),
    n_hospital_interval = ifelse(is.na(n_hospital_interval), n_hospital_interval_sub_mean, n_hospital_interval),
    n_treatment_month_interval = ifelse(is.na(n_treatment_month_interval), n_treatment_month_interval_sub_mean, n_treatment_month_interval),
    visit_interval = ifelse(is.na(visit_interval), visit_interval_sub_mean, visit_interval),
    max_tazai_cnt = ifelse(is.na(max_tazai_cnt), max_tazai_cnt_sub_mean, max_tazai_cnt)
  )


##それでも埋まらないところは、性別・年齢ごとの平均値で欠損を埋める
mk_diff_rate_gender_age<-table2_v6%>%
  group_by(gender, age)%>%
  summarise_each(funs(median(., na.rm = TRUE)), BMI_a, systolic_bp_a, diastolic_bp_a, neutral_fat_a, HDL_a, LDL_a, GOT_a, HbA1c_a,
                 urine_sugar_a, urine_protein_a, systolic_bp_a_cat, LDL_a_cat, HbA1c_a_cat, severity_a,n_hospital_interval,n_treatment_month_interval,
                 visit_interval,max_tazai_cnt)%>%
  rename(
    BMI_a_sub = BMI_a,
    systolic_bp_a_sub = systolic_bp_a,
    diastolic_bp_a_sub = diastolic_bp_a,
    neutral_fat_a_sub = neutral_fat_a,
    HDL_a_sub = HDL_a,
    LDL_a_sub = LDL_a,
    GOT_a_sub = GOT_a,
    HbA1c_a_sub = HbA1c_a,
    urine_sugar_a_sub = urine_sugar_a,
    urine_protein_a_sub = urine_protein_a,
    systolic_bp_a_cat_sub = systolic_bp_a_cat,
    LDL_a_cat_sub = LDL_a_cat,
    HbA1c_a_cat_sub = HbA1c_a_cat,
    severity_a_sub = severity_a,
    n_hospital_interval_sub = n_hospital_interval,
    n_treatment_month_interval_sub = n_treatment_month_interval,
    visit_interval_sub = visit_interval,
    max_tazai_cnt_sub = max_tazai_cnt
  )
  
  
fil_mean_gender_age<-fil_mean_sub%>%
  left_join(., mk_diff_rate_gender_age, by=c("gender", "age"))%>%
  mutate(
    BMI_a = ifelse(is.na(BMI_a), BMI_a_sub, BMI_a), BMI_b = ifelse(is.na(BMI_b), BMI_a_sub, BMI_b),
    systolic_bp_a = ifelse(is.na(systolic_bp_a), systolic_bp_a_sub, systolic_bp_a),
    systolic_bp_b = ifelse(is.na(systolic_bp_b), systolic_bp_a_sub, systolic_bp_b),
    diastolic_bp_a = ifelse(is.na(diastolic_bp_a), diastolic_bp_a_sub, diastolic_bp_a),
    diastolic_bp_b = ifelse(is.na(diastolic_bp_b), diastolic_bp_a_sub, diastolic_bp_b),
    neutral_fat_a = ifelse(is.na(neutral_fat_a), neutral_fat_a_sub, neutral_fat_a),
    neutral_fat_b = ifelse(is.na(neutral_fat_b), neutral_fat_a_sub, neutral_fat_b),
    HDL_a = ifelse(is.na(HDL_a), HDL_a_sub, HDL_a), HDL_b = ifelse(is.na(HDL_b), HDL_a_sub, HDL_b),
    LDL_a = ifelse(is.na(LDL_a), LDL_a_sub, LDL_a), LDL_b = ifelse(is.na(LDL_b), LDL_a_sub, LDL_b),
    GOT_a = ifelse(is.na(GOT_a), GOT_a_sub, GOT_a), GOT_b = ifelse(is.na(GOT_b), GOT_a_sub, GOT_b),
    HbA1c_a = ifelse(is.na(HbA1c_a), HbA1c_a_sub, HbA1c_a),
    HbA1c_b = ifelse(is.na(HbA1c_b), HbA1c_a_sub, HbA1c_b),
    urine_sugar_a = ifelse(is.na(urine_sugar_a), urine_sugar_a_sub, urine_sugar_a),
    urine_sugar_b = ifelse(is.na(urine_sugar_b), urine_sugar_a_sub, urine_sugar_b),
    urine_protein_a = ifelse(is.na(urine_protein_a), urine_protein_a_sub, urine_protein_a),
    urine_protein_b = ifelse(is.na(urine_protein_b), urine_protein_a_sub, urine_protein_b),
    systolic_bp_a_cat = ifelse(is.na(systolic_bp_a_cat), systolic_bp_a_cat_sub, systolic_bp_a_cat),
    systolic_bp_b_cat = ifelse(is.na(systolic_bp_b_cat), systolic_bp_a_cat_sub, systolic_bp_b_cat),
    LDL_a_cat = ifelse(is.na(LDL_a_cat), LDL_a_cat_sub, LDL_a_cat),
    LDL_b_cat = ifelse(is.na(LDL_b_cat), LDL_a_cat_sub, LDL_b_cat),
    HbA1c_a_cat = ifelse(is.na(HbA1c_a_cat), HbA1c_a_cat_sub, HbA1c_a_cat),
    HbA1c_b_cat = ifelse(is.na(HbA1c_b_cat), HbA1c_a_cat_sub, HbA1c_b_cat),
    severity_a = ifelse(is.na(severity_a), severity_a_sub, severity_a),
    severity_b = ifelse(is.na(severity_b), severity_a_sub, severity_b),
    n_hospital_interval = ifelse(is.na(n_hospital_interval), n_hospital_interval_sub, n_hospital_interval),
    n_treatment_month_interval = ifelse(is.na(n_treatment_month_interval), n_treatment_month_interval_sub, n_treatment_month_interval),
    visit_interval = ifelse(is.na(visit_interval), visit_interval_sub, visit_interval),
    max_tazai_cnt = ifelse(is.na(max_tazai_cnt), max_tazai_cnt_sub, max_tazai_cnt)
  )



###　他に考えた欠損値の処理方法
#　平均値でなく、中央値で補完
#　ランダムフォレストで補完
#　性別・年齢ごとの平均変化率で補完

