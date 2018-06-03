--リンクが途切れている場合にすぐに気づけるようにする

-- 1, 県ごとにデータを区切る
		--pref, class, no で区切る

CREATE VIEW map.filter_road AS(
SELECT
	*
FROM
	map.node_name
WHERE
	pref1 =23 OR pref2 =23 OR pref3 =23 OR pref4 =23 OR pref5 =23 OR pref6 =23 OR pref7 =23 OR pref8 =23
AND
	class1 = 3 OR class2 = 3 OR class3 = 3 OR class4 = 3 OR
	class5 = 3 OR class6 = 3 OR class7 = 3 OR class8 = 3
AND
	no1 = 248 OR no2 = 248 OR no3 = 248 OR no4 = 248 OR
	no5 = 248 OR no6 = 248 OR no7 = 248 OR no8 = 248
);



-- 2, 区切ったデータの中で端点となっているものを探し出す

CREATE TABLE map.link_end_point AS (
WITH for_count_end AS ( 
SELECT
	objectid,
	CASE WHEN (pref1 = 23 AND class1 = 3 AND no1 = 248) THEN 1 ELSE 0 END AS cnt1,
 	CASE WHEN (pref2 = 23 AND class2 = 3 AND no2 = 248) THEN 1 ELSE 0 END AS cnt2,
	CASE WHEN (pref3 = 23 AND class3 = 3 AND no3 = 248) THEN 1 ELSE 0 END AS cnt3,
	CASE WHEN (pref4 = 23 AND class4 = 3 AND no4 = 248) THEN 1 ELSE 0 END AS cnt4,
	CASE WHEN (pref5 = 23 AND class5 = 3 AND no5 = 248) THEN 1 ELSE 0 END AS cnt5,
	CASE WHEN (pref6 = 23 AND class6 = 3 AND no6 = 248) THEN 1 ELSE 0 END AS cnt6,
	CASE WHEN (pref7 = 23 AND class7 = 3 AND no7 = 248) THEN 1 ELSE 0 END AS cnt7,
	CASE WHEN (pref8 = 23 AND class8 = 3 AND no8 = 248) THEN 1 ELSE 0 END AS cnt8,
	shape
FROM
	map.filter_road
),
count_end AS(
SELECT
	objectid,
	(cnt1+cnt2+cnt3+cnt4+cnt5+cnt6+cnt7+cnt8) AS count,
	shape
FROM
	for_count_end
)
SELECT
	*
FROM
	count_end
WHERE
	count = 1
);
