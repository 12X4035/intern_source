/*500mメッシュでの1メッシュあたりのノード数*/
CREATE TABLE map.sato_node_density_500m AS(
SELECT
    meshid,
	COUNT(objectid)	
FROM
	map.yano_mesh_500m AS mesh
LEFT JOIN
	map.road_node AS node
ON
	ST_Intersects(mesh.shape, node.shape)
GROUP BY
	meshid
ORDER BY
	meshid
)
;

/*5000mメッシュでの1メッシュあたりのノード数*/
CREATE TABLE map.sato_node_density_5000m AS(
SELECT
    meshid,
	COUNT(objectid)
FROM
	map.yano_mesh_5000m AS mesh
LEFT JOIN
	map.road_node AS node
ON
	ST_Intersects(mesh.shape, node.shape)
GROUP BY
	meshid
ORDER BY
	meshid
)
;

-- 500mメッシュでの1メッシュあたりのノード数
CREATE TABLE map.sato_node_density_jp_500m AS(
	SELECT
		meshid,
		COUNT(objectid)	
	FROM
		map.yano_jp_mesh_500m AS mesh
	LEFT JOIN
		map.road_node AS node
	ON
		ST_Intersects(mesh.shape, node.shape)
	GROUP BY
		meshid
)
;

-- 5000mメッシュでの1メッシュあたりのノード数
CREATE TABLE map.sato_node_density_jp_5000m AS(
	SELECT
    		meshid,
		COUNT(objectid)
	FROM
		map.yano_jp_mesh_5000m AS mesh
	LEFT JOIN
		map.road_node AS node
	ON
		ST_Intersects(mesh.shape, node.shape)
	GROUP BY
		meshid
)
;
