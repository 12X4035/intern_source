WITH nagoya_city_map AS(
SELECT
    meshid,
	objectid,
	mesh.shape AS m_shape,
	node.shape AS n_shape
FROM
	 map.yano_mesh_500m AS mesh,
	 map.road_node AS node
WHERE
	ST_Intersects(mesh.shape, node.shape)
)
SELECT
 *,
 /*これで円を描いて近傍のノード数をカウントする.*/
(SELECT count(*)
 FROM map.road_node
 WHERE ST_Dwithin(shape::geography, node.shape::geography, 500)) npoints
 FROM
 nagoya_city_map AS 
 LIMIT(10)
 ;
