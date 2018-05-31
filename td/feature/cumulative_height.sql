WITH DumpPoints AS(
SELECT
	objectid AS link_id,
	ST_DumpPoints(ST_GeometryN(shape, 1)) AS dump
FROM
	map.sasai_aichi_test_link
)
SELECT 
	link_id,
	(dump).path,
	ST_Y((dump).geom) AS latitude,
	ST_X((dump).geom) AS longitude
FROM
	DumpPoints 
LIMIT
50
;

