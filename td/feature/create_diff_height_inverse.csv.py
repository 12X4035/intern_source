import sys
import csv
import psycopg2
import psycopg2.extras

DB_INFO = {
    "dbname": "gisdb",
    "user": "map",
    "password": "",
    "host": "localhost",
    "port": 5432,
}


def main(argv):
    try:
        param_str = """
            dbname='{0}' user='{1}' password='{2}' host='{3}' port ={4}"
        """.format(DB_INFO["dbname"],
                   DB_INFO['user'],
                   DB_INFO['password'],
                   DB_INFO['host'],
                   DB_INFO['port'],)
        con = psycopg2.connect(param_str)
    except Exception as e:
        print("connection error[{}]".format(e))
        sys.exit(1)

    mesh_id = argv[1]
    if int(mesh_id) < 0:
        idx = [x for x in range(76, 79) if x not in [36, 76, 216]]
    else:
        idx = [mesh_id]
    idx.reverse()
    for i in idx:
        diff_sql = """
          with ft as (
            select
              *
              , ST_SetSRID(ST_Point(from_longitude, from_latitide), 4612)
                as from_p
              , ST_SetSRID(ST_Point(to_longitude, to_latitide), 4612)
                as to_p
            from
              tmp_from_to
            where
              objectid in (
                select
                  objectid
                from
                  map.road_link as l
                  , (select * from map.yano_mesh_5000m where meshid = {0}) as m
                where
                  ST_Intersects(l.shape, m.shape)
              )
           )
           , heights as (
              select
                h.*
              from
                (select id, height, ST_SetSRID(ST_MakeBox2D(ST_SetSRID(ST_Point(lon_lefttop, lat_lefttop), 4612), ST_SetSRID(ST_Point(lon_rightbottom, lat_rightbottom), 4612)),4612) as height_shape from map.sato_height) as h
                , (select * from map.yano_mesh_5000m where meshid = {0}) as m
              where
                ST_Intersects(h.height_shape, m.shape)
           )
           select
             ft.objectid
             , ft.from_node_id
             , ft.to_node_id
             , f_h.height as from_height
             , t_h.height as to_height
           from
             ft
             , heights as f_h
             , heights as t_h
           where
             ST_Intersects(ft.from_p, f_h.height_shape)
             and ST_Intersects(ft.to_p, t_h.height_shape)
           ;
           """.format(i)

        with con.cursor() as curs:
            curs.execute(diff_sql)
            diff_rows = curs.fetchall()

        with open("diff_height_{}.csv".format(i), 'w') as f:
            writer = csv.writer(f)
            writer.writerows(diff_rows)

        print("END meshid [{}]".format(i))


if __name__ == "__main__":
    main(sys.argv)
