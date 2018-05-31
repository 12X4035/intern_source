--全て含んでいるver.
CREATE TABLE map.sato_multiline_1 AS(

WITH dumppoints AS(
					SELECT
						objectid,
						from_node_id,
						to_node_id,
						(ST_DumpPoints(ST_GeometryN(shape, 1))).path AS path,
						(ST_DumpPoints(ST_GeometryN(shape, 1))).geom AS geom
					FROM
						map.sasai_aichi_test_link
),
d_reforme AS(

					SELECT
						objectid,
						from_node_id,
						to_node_id,
						path,
						geom,
						lead(path) OVER(partition by objectid order by objectid, path ) AS path_plus_1,
						lead(geom) OVER(partition by objectid order by objectid, path ) AS geom_plus_1
					FROM
						dumppoints
)
SELECT
	*
FROM
	d_reforme
WHERE
	geom_plus_1 is not null
ORDER BY
	objectid, path
);



--すでに求めた標高(from_node, to_node)は除いたver.
CREATE TABLE map.sato_multiline_2 AS(
WITH count_line AS(
					SELECT
    					objectid,
						from_node_id,
						to_node_id,
	    				COUNT(objectid) AS count
					FROM
		    			map.sato_multiline_1
					GROUP BY
			    		objectid,from_node_id,to_node_id
)
SELECT
	m.*,
	c.count
FROM
    count_line AS c
INNER JOIN
	map.sato_multiline_1 AS m
ON
	m.objectid = c.objectid
WHERE
	count<>1
);




--最初に書いたやつ（一応残しとく）
WITH dumppoints AS(
					SELECT
						objectid AS link_id,
						(ST_DumpPoints(ST_GeometryN(shape, 1))).path AS path,
						(ST_DumpPoints(ST_GeometryN(shape, 1))).geom AS geom
					FROM
						map.sasai_aichi_test_link
),
df AS (
					SELECT
						link_id,
						COUNT(link_id) AS count
					FROM
						dumppoints
					GROUP BY
						link_id
					HAVING
						COUNT(link_id) >2
					  ),
				min_max AS(
						SELECT
						dp.*,
						max(path) OVER (partition by dp.link_id) max_path,
						min(path) OVER (partition by dp.link_id) min_path
						FROM
						map.sato_multiline_1 AS dp
						INNER JOIN
						df
						ON
						dp.link_id = df.link_id

						)
SELECT
	link_id,
	path,
	geom
FROM
	min_max	
WHERE
	path<>max_path
AND
	path<>min_path
ORDER BY
	link_id, path
)
;



 
