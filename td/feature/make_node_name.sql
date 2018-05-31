--愛知の交差点に絞る
CREATE VIEW map.sato_tmp AS (
    SELECT
         objectid,
         name_kanji,
         name_yomi,
         linkid1,
         linkid2,
         linkid3,
         linkid4,
         linkid5,
         linkid6,
         linkid7,
         linkid8,
         shape
    FROM
        map.road_node AS a1
    INNER JOIN
        map.sato_node_links AS a2
    ON
     a1.objectid = a2.nodeid
);


CREATE TABLE map.sato_node_name AS(
WITH road_name AS (
SELECT
	link.objectid,
	link.census_class,
	link.road_no,
	link.pref_no,
	link.shape,
	list.road_code,
	list.display_kanji,
	list.lineclass_c,
	list.linedirtype_c
FROM
	map.link_pref_no AS link
LEFT OUTER JOIN
	map.road_code_list AS list
ON
	link.objectid =list.objectid
),
 link1 AS (
SELECT
    c.objectid,
    c.name_kanji,
    c.name_yomi,
    c.linkid1,
    c.linkid2,
    c.linkid3,
    c.linkid4,
    c.linkid5,
    c.linkid6,
    c.linkid7,
    c.linkid8,  
    c1.census_class AS class1,
    c1.road_no AS no1,
    c1.road_code AS code1,
    c1.pref_no AS pref1,
    c1.display_kanji AS name1,
    c.shape
FROM
    map.sato_tmp AS c    
LEFT OUTER JOIN
    road_name AS c1
ON
    c.linkid1 = c1.objectid
),
    link2 AS (
SELECT
    link1.objectid,
    name_kanji,
    name_yomi,
    linkid1,
    linkid2,
    linkid3,
    linkid4,
    linkid5,
    linkid6,
    linkid7,
    linkid8,
    class1,
    no1,
    code1,
    pref1,
    name1,
    c2.census_class AS class2,
    c2.road_no AS no2,
    c2.road_code AS code2,
    c2.pref_no AS pref2,
    c2.display_kanji AS name2,
    link1.shape
FROM
    link1 
LEFT OUTER JOIN
    road_name AS c2
ON
    link1.linkid2 = c2.objectid
),
    link3 AS (
SELECT
    link2.objectid,
    name_kanji,
    name_yomi,
    linkid1,
    linkid2,
    linkid3,
    linkid4,
    linkid5,
    linkid6,
    linkid7,
    linkid8,
    class1,
    no1,
    code1,
    pref1,
    name1,
    class2,
    no2,
    code2,
    pref2,
    name2,
    c3.census_class AS class3,
    c3.road_no AS no3,
    c3.road_code AS code3,
    c3.pref_no AS pref3,
    c3.display_kanji AS name3,
    link2.shape
FROM
    link2
LEFT OUTER JOIN
    road_name AS c3
ON
    link2.linkid3 = c3.objectid
),
    link4 AS (
SELECT
    link3.objectid,
    name_kanji,
    name_yomi,
    linkid1,
    linkid2,
    linkid3,
    linkid4,
    linkid5,
    linkid6,
    linkid7,
    linkid8,
    class1,
    no1,
    code1,
    pref1,
    name1,
    class2,
    no2,
    code2,
    pref2,
    name2,
    class3,
    no3,
    code3,
    pref3,
    name3,
    c4.census_class AS class4,
    c4.road_no AS no4,
    c4.road_code AS code4,
    c4.pref_no AS pref4,
    c4.display_kanji AS name4,
    link3.shape
FROM
    link3
LEFT OUTER JOIN
    road_name AS c4
ON
    link3.linkid4 = c4.objectid
),
    link5 AS (
SELECT
    link4.objectid,
    name_kanji,
    name_yomi,
    linkid1,
    linkid2,
    linkid3,
    linkid4,
    linkid5,
    linkid6,
    linkid7,
    linkid8,
    class1,
    no1,
    code1,
    pref1,
    name1,
    class2,
    no2,
    code2,
    pref2,
    name2,
    class3,
    no3,
    code3,
    pref3,
    name3,
    class4,
    no4,
    code4,
    pref4,
    name4,
    c5.census_class AS class5,
    c5.road_no AS no5,
    c5.road_code AS code5,
    c5.pref_no AS pref5,
    c5.display_kanji AS name5,
    link4.shape
FROM
    link4
LEFT OUTER JOIN
    road_name AS c5
ON
    link4.linkid5 = c5.objectid
),
    link6 AS (
SELECT
    link5.objectid,
    name_kanji,
    name_yomi,
    linkid1,
    linkid2,
    linkid3,
    linkid4,
    linkid5,
    linkid6,
    linkid7,
    linkid8,
    class1,
    no1,
    code1,
    pref1,
    name1,
    class2,
    no2,
    code2,
    pref2,
    name2,
    class3,
    no3,
    code3,
    pref3,
    name3,
    class4,
    no4,
    code4,
    pref4,
    name4,
    class5,
    no5,
    code5,
    pref5,
    name5,
    c6.census_class AS class6,
    c6.road_no AS no6,
    c6.road_code AS code6,
    c6.pref_no AS pref6,
    c6.display_kanji AS name6,
    link5.shape
FROM
    link5
LEFT OUTER JOIN
    road_name AS c6
ON
    link5.linkid6 = c6.objectid
),
    link7 AS (
SELECT
    link6.objectid,
    name_kanji,
    name_yomi,
    linkid1,
    linkid2,
    linkid3,
    linkid4,
    linkid5,
    linkid6,
    linkid7,
    linkid8,
    class1,
    no1,
    code1,
    pref1,
    name1,
    class2,
    no2,
    code2,
    pref2,
    name2,
    class3,
    no3,
    code3,
    pref3,
    name3,
    class4,
    no4,
    code4,
    pref4,
    name4,
    class5,
    no5,
    code5,
    pref5,
    name5,
    class6,
    no6,
    code6,
    pref6,
    name6,
    c7.census_class AS class7,
    c7.road_no AS no7,
    c7.road_code AS code7,
    c7.pref_no AS pref7,
    c7.display_kanji AS name7,
    link6.shape
FROM
    link6
LEFT OUTER JOIN
    road_name AS c7
ON
    link6.linkid7 = c7.objectid
),
    link8 AS (
SELECT
    link7.objectid,
    name_kanji,
    name_yomi,
    linkid1,
    linkid2,
    linkid3,
    linkid4,
    linkid5,
    linkid6,
    linkid7,
    linkid8,
    class1,
    no1,
    code1,
    pref1,
    name1,
    class2,
    no2,
    code2,
    pref2,
    name2,
    class3,
    no3,
    code3,
    pref3,
    name3,
    class4,
    no4,
    code4,
    pref4,
    name4,
    class5,
    no5,
    code5,
    pref5,
    name5,
    class6,
    no6,
    code6,
    pref6,
    name6,
    class7,
    no7,
    code7,
    pref7,
    name7,
    c8.census_class AS class8,
    c8.road_no AS no8,
    c8.road_code AS code8,
    c8.pref_no AS pref8,
    c8.display_kanji AS name8,
    link7.shape
FROM
    link7
LEFT OUTER JOIN
    road_name AS c8
ON
    link7.linkid8 = c8.objectid
)
SELECT
*
FROM
link8
);
    
--pref,  class, road_no でfillterをかける 
CREATE TABLE map.sato_node_info AS(
SELECT
    *
FROM
    map.sato_node_name
WHERE
    class
    road_no
    pref
;
