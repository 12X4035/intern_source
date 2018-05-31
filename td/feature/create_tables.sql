CREATE TABLE IF NOT EXISTS sato_height (
  id INTEGER,
  height DOUBLE PRECISION,
  lat_lefttop DOUBLE PRECISION,
  lon_lefttop DOUBLE PRECISION,
  lat_rightbottom DOUBLE PRECISION,
  lon_rightbotttom DOUBLE PRECISION
);
CREATE TABLE IF NOT EXISTS tmp_from_to (
  objectid INTEGER,
  from_node_id INTEGER,
  to_node_id INTEGER,
  from_latitide DOUBLE PRECISION,
  from_longitude DOUBLE PRECISION,
  to_latitide DOUBLE PRECISION,
  to_longitude DOUBLE PRECISION
);
CREATE TABLE IF NOT EXISTS sato_diff_height (
  objectid INTEGER,
  from_node_id INTEGER,
  to_node_id INTEGER,
  from_latitide DOUBLE PRECISION,
  from_longitude DOUBLE PRECISION,
  to_latitide DOUBLE PRECISION,
  to_longitude DOUBLE PRECISION,
  from_height DOUBLE PRECISION,
  to_height DOUBLE PRECISION,
  diff_height DOUBLE PRECISION
);
CREATE TABLE IF NOT EXISTS yano_mesh_5000m (
  meshid INTEGER,
  lat_lefttop DOUBLE PRECISION,
  lon_lefttop DOUBLE PRECISION,
  lat_rightbottom DOUBLE PRECISION,
  lon_rightbottom DOUBLE PRECISION,
  shape GEOMETRY
);
CREATE TABLE IF NOT EXISTS yano_mesh_500m (
  meshid INTEGER,
  lat_lefttop DOUBLE PRECISION,
  lon_lefttop DOUBLE PRECISION,
  lat_rightbottom DOUBLE PRECISION,
  lon_rightbottom DOUBLE PRECISION,
  shape GEOMETRY
);
