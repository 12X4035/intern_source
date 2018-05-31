INSERT INTO tmp_from_to
SELECT
  link.objectid,
  from_node_id,
  to_node_id,
  ST_Y(node2.shape) AS from_latitude,
  ST_X(node2.shape) AS from_longitude,
  ST_Y(node1.shape) AS to_latitude,
  ST_X(node1.shape) AS to_lngitude
FROM
  (SELECT objectid, from_node_id, to_node_id from map.sasai_aichi_test_link) AS link
  INNER JOIN
    (SELECT objectid, shape FROM map.sasai_aichi_test_node) AS node2
  ON
    link.from_node_id = node2.objectid
  INNER JOIN
    (SELECT objectid, shape FROM map.sasai_aichi_test_node) As node1
  ON
    link.to_node_id = node1.objectid
;
