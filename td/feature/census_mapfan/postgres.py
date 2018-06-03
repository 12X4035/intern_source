import pandas as pd
import pandas.io.sql as psql
import psycopg2 as pg
"""
データについて:
* census_class.csv: map.traffic_census
* aichi_no1_paths.csv: R で導出する
* node_info.csv: map.sato_node_name
"""
def fetch_traffic_census():
    """
    traffic_census テーブルを取得し, csv ファイルで保存する.
    """
    with pg.connect(database='',
                    user='',
                    password="",
                    host='',
                    port=) as conn:
        sql = 'SELECT * FROM map.traffic_census WHERE prefecture =23 AND class = 3 AND no =19'
        df = psql.read_sql(sql, conn)
       	df.to_csv("traffic_census.csv", index=False)
# TODO: 使用する際, 絞り込みが必要かも.
def fetch_node_info():
    """
    traffic_census テーブルを取得し, csv ファイルで保存する.
    """
    with pg.connect(database='',
                    user='',
                    password="",
                    host='',
                    port=) as conn:
        sql = 'SELECT * FROM map.sato_node_name WHERE pref1=23 AND class1=3 AND no1=19 OR pref2=23 AND class2=3 AND no2=19 OR pref3=23 AND class3=3 AND no3=19 OR pref4=23 AND class4=3 AND no4=19 OR pref5=23 AND class5=3 AND no5=19 OR pref6=23 AND class6=3 AND no6=19 OR pref7=23 AND class7=3 AND no7=19 OR pref8=23 AND class8=3 AND no8=19'
        df = psql.read_sql(sql, conn)
        df.to_csv("node_info.csv", index=False)