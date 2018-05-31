INSERT INTO sato_diff_height
select
  tmp.*
  , from_height.height
  , to_height.height
  , from_height.height - to_height.height as diff_height
from
  tmp_from_to as tmp
  INNER JOIN
    map.sato_height as from_height
  ON
    tmp.from_latitide BETWEEN from_height.lat_rightbottom AND from_height.lat_lefttop 
    AND tmp.from_longitude BETWEEN from_height.lon_lefttop AND from_height.lon_rightbottom
  INNER JOIN
    map.sato_height as to_height
  ON
    tmp.to_latitide BETWEEN to_height.lat_rightbottom AND to_height.lat_lefttop 
    AND tmp.to_longitude BETWEEN to_height.lon_lefttop AND to_height.lon_rightbottom
;
