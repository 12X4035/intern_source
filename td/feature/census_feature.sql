--mapfan
```
1	一般国道 → 3
2	主要地方道(都府県) → 4
3	主要地方道(指定市) → 5
4	一般都道府県道 → 6
5	指定市の一般市道 → 7
6	その他道路 → 8
7	その他道路(間引対象) → 8
8	細街路L1
9	細街路L2
11	高速自動車道路　→ 1
101	高速自動車道路(有料) → 1
102	都市高速道路(有料) → 2
103	一般国道(有料) → 103
104	主要地方道(都府県)(有料) → 104
105	主要地方道(指定市)(有料) → 105
106	一般都道府県道(有料) → 106
107	指定市の一般市道(有料) → 107
108	その他道路(有料) → 108
201	フェリー航路(非表示部)
202	フェリー航路(S2破線表示部)
203	フェリー航路(S3破線表示部)
204	フェリー航路(S4破線表示部)
302	庭園路
303	ブリッジリンク
304	施設出入口リンク
305	施設内リンク
```
--センサス
1 高速自動車国道
2 都市高速道路
3 一般国道
4 主要地方道(都道府県道)
5 主要地方道(指定市道)
6 一般都道府県道
7 指定市の一般市道
8 その他


CREATE TABLE map.link_pref_no AS(
WITH link_prefecture AS(
SELECT
    link.objectid,
	from_node_id,
	to_node_id,
	roadclass_c,
	road_no,
	road_code,
	prefecture_name,
	shape
FROM
	map.road_link AS link
INNER JOIN
	map.link_prefecture AS pref
ON
	link.objectid = pref.objectid
	)
SELECT
	*,
	CASE WHEN prefecture_name = '北海道' THEN 1
		 WHEN prefecture_name = '青森県' THEN 2
		 WHEN prefecture_name = '岩手県' THEN 3
		 WHEN prefecture_name = '宮城県' THEN 4
		 WHEN prefecture_name = '秋田県' THEN 5
		 WHEN prefecture_name = '山形県' THEN 6
		 WHEN prefecture_name = '福島県' THEN 7
		 WHEN prefecture_name = '茨城県' THEN 8
		 WHEN prefecture_name = '栃木県' THEN 9
		 WHEN prefecture_name = '群馬県' THEN 10
		 WHEN prefecture_name = '埼玉県' THEN 11
		 WHEN prefecture_name = '千葉県' THEN 12
		 WHEN prefecture_name = '東京都' THEN 13
		 WHEN prefecture_name = '神奈川県' THEN 14
		 WHEN prefecture_name = '新潟県' THEN 15
		 WHEN prefecture_name = '富山県' THEN 16
		 WHEN prefecture_name = '石川県' THEN 17
		 WHEN prefecture_name = '福井県' THEN 18
		 WHEN prefecture_name = '山梨県' THEN 19
		 WHEN prefecture_name = '長野県' THEN 20
		 WHEN prefecture_name = '岐阜県' THEN 21
		 WHEN prefecture_name = '静岡県' THEN 22
		 WHEN prefecture_name = '愛知県' THEN 23
		 WHEN prefecture_name = '三重県' THEN 24
		 WHEN prefecture_name = '滋賀県' THEN 25
		 WHEN prefecture_name = '京都府' THEN 26
		 WHEN prefecture_name = '大阪府' THEN 27
		 WHEN prefecture_name = '兵庫県' THEN 28
		 WHEN prefecture_name = '奈良県' THEN 29
		 WHEN prefecture_name = '和歌山県' THEN 30
		 WHEN prefecture_name = '鳥取県' THEN 31
		 WHEN prefecture_name = '島根県' THEN 32
		 WHEN prefecture_name = '岡山県' THEN 33
		 WHEN prefecture_name = '広島県' THEN 34
		 WHEN prefecture_name = '山口県' THEN 35
		 WHEN prefecture_name = '徳島県' THEN 36
		 WHEN prefecture_name = '香川県' THEN 37
		 WHEN prefecture_name = '愛媛県' THEN 38
		 WHEN prefecture_name = '高知県' THEN 39
		 WHEN prefecture_name = '福岡県' THEN 40
		 WHEN prefecture_name = '佐賀県' THEN 41
		 WHEN prefecture_name = '長崎県' THEN 42
		 WHEN prefecture_name = '熊本県' THEN 43
		 WHEN prefecture_name = '大分県' THEN 44
		 WHEN prefecture_name = '宮崎県' THEN 45
		 WHEN prefecture_name = '鹿児島県' THEN 46
		 WHEN prefecture_name = '沖縄県' THEN 47
		 END AS pref_no,
		 CASE WHEN roadclass_c = 11 OR roadclass_c = 101 THEN 1
			  WHEN roadclass_c = 102 THEN 2
		 	  WHEN roadclass_c = 1 THEN 3
		 	  WHEN roadclass_c = 2 THEN 4
			  WHEN roadclass_c = 3 THEN 5
			  WHEN roadclass_c = 4 THEN 6
		 	  WHEN roadclass_c = 5 THEN 7
			  WHEN roadclass_c = 6 OR roadclass_c = 7 THEN 8
			  WHEN roadclass_c = 103 THEN 103
		      WHEN roadclass_c = 104 THEN 104
			  WHEN roadclass_c = 105 THEN 105
			  WHEN roadclass_c = 106 THEN 106
			  WHEN roadclass_c = 107 THEN 107
			  WHEN roadclass_c = 108 THEN 108
			  END AS census_class
FROM
	link_prefecture
)

CREATE TABLE map.link_census_join AS(
WITH census AS (
SELECT
	small_vehicle_day,
	large_vehicle_day,
	sum_vehicle_day,
	small_vehicle_24h,
	large_vehicle_24h,
	sum_vehicle_24h,
	rate_day_night,
	rate_day_peek,
	rate_day_large,
	rate_sidewalk,
	rate_sidewalk_pedestrian,
	rate_sidewalk_bicycle,
	rate_sidewalk_bicycle_lane,
	rate_sidewalk_pedestrian_both,
	rate_sidewalk_bicycle_pedestrian_both,
	rate_sidewalk_bicycle_both,
	rate_sidewalk_bicycle_lane_both,
	rep_sidwalk_width,
	rep_bicycle_width,
	rate_extend_bus,
	density_xing_signal,
	density_xing_nosignal,
	prefecture,
	class,
	no,
	from_prefecture,
	from_class,
	from_no,
	to_prefecture,
	to_class,
	to_no
FROM
	map.traffic_census
GROUP BY
	prefecture, class, no
)
SELECT
	*
FROM
	census
INNER JOIN
	map.link_pref_no AS pref
ON
	census.prefecture  = pref.pref_no
AND
	census.class = pref.census_class
AND
	census.no = pref.road_no
);


