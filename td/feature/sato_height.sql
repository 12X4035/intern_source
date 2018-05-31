/*
CREATE TABLE sato_height(
	height float,
	lat_lefttop float,
	lon_lefttop float,
	lat_rightbottom float,
	lon_rightbottom float
	);

\copy sato_height(col_f1 filler int, height, lat_lefttop, lon_lefttop, lat_right_bottom, lon_right_bottom) from 'out.csv' with csv;
*/
/**/


SELECT
  link.objectid,
	from_node_id,
	to_node_id,
	ST_Y(node2.shape) AS from_latitude,
	ST_X(node2.shape) AS from_longitude,
	ST_Y(node1.shape) AS to_latitude,
	ST_X(node1.shape) AS to_lngitude,
	from_height.height AS from_height,
	to_height.height AS to_height,
	from_height.height-to_height.height AS diff_height

FROM
	((map.sasai_aichi_test_link AS link

INNER JOIN
	map.sasai_aichi_test_node AS node2
ON
	from_node_id = node2.objectid)

INNER JOIN
	map.sasai_aichi_test_node As node1
ON
	to_node_id = node1.objectid)
														    
INNER JOIN
	map.sato_height AS from_height
ON
	from_latitude  BETWEEN lat_rightbottom AND lat_lefttop
AND
	from_longitude  BETWEEN lon_rightbottom AND lon_lefttop
INNER JOIN
    map.sato_height_tmp AS to_height
ON
	 to_latitude  BETWEEN lat_rightbottom AND lat_lefttop
AND
	 to_longitude  BETWEEN lon_rightbottom AND lon_lefttop
;
