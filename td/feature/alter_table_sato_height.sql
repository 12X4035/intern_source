ALTER TABLE sato_height RENAME COLUMN lon_lefttop TO lat_upleft;
ALTER TABLE sato_height RENAME COLUMN lat_rightbottom TO lon_upleft;
ALTER TABLE sato_height RENAME COLUMN lat_lefttop TO lat_downright;
ALTER TABLE sato_height RENAME COLUMN lon_rightbottom TO lon_downright;

ALTER TABLE sato_height RENAME COLUMN lat_upleft TO lat_lefttop;
ALTER TABLE sato_height RENAME COLUMN lon_upleft TO lon_lefttop;
ALTER TABLE sato_height RENAME COLUMN lat_downright TO lat_rightbottom;
ALTER TABLE sato_height RENAME COLUMN lon_downright TO lon_rightbottom;
