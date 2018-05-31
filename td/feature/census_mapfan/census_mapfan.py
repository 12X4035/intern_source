"""
match_census_mfnode.py - 道路交通センサス区間終点と MapFan Node を対応付ける
"""
import pandas as pd
import pandas.io.sql as psql
import psycopg2 as pg
"""
データについて:
* sato_census_class.csv: map.traffic_census
* aichi_no1_paths.csv: R で導出する
* sato_node_info.csv: map.sato_node_name
"""
#def fetch_traffic_census():
#traffic_census テーブルを取得し, csv ファイルで保存する.
with pg.connect(database='road',
			user='futono',
			password="futono",
			host='mapfandb-0614-0716.cybcmdcfdbpm.us-east-1.rds.amazonaws.com',
			port=5432) as conn:
			sql = 'SELECT * FROM map.traffic_census WHERE prefecture =23 AND class = 3 AND no =19'
			census_d= psql.read_sql(sql, conn)

# TODO: 使用する際, 絞り込みが必要かも.
#def fetch_node_info():
#traffic_census テーブルを取得し, csv ファイルで保存する.
with pg.connect(database='road',
                    	user='futono',
                    	password="futono",
                    	host='mapfandb-0614-0716.cybcmdcfdbpm.us-east-1.rds.amazonaws.com',
                    	port=5432) as conn:
        		sql = 'SELECT * FROM map.sato_node_name WHERE pref1=23 AND class1=3 AND no1=19 OR pref2=23 AND class2=3 AND no2=19 OR pref3=23 AND class3=3 AND no3=19 OR pref4=23 AND class4=3 AND no4=19 OR pref5=23 AND class5=3 AND no5=19 OR pref6=23 AND class6=3 AND no6=19 OR pref7=23 AND class7=3 AND no7=19 OR pref8=23 AND class8=3 AND no8=19'
        		node_info = psql.read_sql(sql, conn)

# TODO: paths を R スクリプトで導出する
# TODO: 別の都道府県に対して
# - 別の都道府県のセンサスデータの用意: "sato_census_class.csv"
# TODO: 別の道路(例: 国道23号)に対して
# - "aichi_no1_paths.csv" のようにノードの辿りを用意する
# - センサスデータの抽出条件
# TODO: 県内の端点がある路線
#
def match_census_mf(tmp_census_roads, tmp_mapfan_nodes, mf_census):
    """
    指定されたセンサス区間について, 対応付けできたセンサス区間と,
    対応付けできなかったセンサス区間と直前に確定したノードIDの値を取得する.
    tmp_census_roads: センサス区間ID, 始点流入道路, 終点流入道路 のタプル
    tmp_mapfan_nodes: ノードID, 流入道路情報(8本) のタプル
    mf_census: マップファンの区間 (ノードタプル) -> センサス区間ID 辞書
    """
    # 対応付けができたもの, できなかったもの
    census_mf = []
    census_mf_not_matched = []
    # TODO: mapfan 区間タプルをキー, センサス区間IDを値とする辞書を受け渡したい
    mapfan_node_ids = [mapfan_node[0] for mapfan_node in tmp_mapfan_nodes]
    mapfan_section = list(zip(mapfan_node_ids[0:len(
        mapfan_node_ids) - 1], mapfan_node_ids[1:len(mapfan_node_ids)]))
    # センサス区間終点とノードが対応付けられた場合に限り, カウントアップする
    base_mapfan_node_ix = 0
    for census_road in tmp_census_roads:
        mapfan_node_ix = base_mapfan_node_ix
        for mapfan_node in tmp_mapfan_nodes[mapfan_node_ix:]:
            mapfan_node_ix += 1
            # マップファンノードに流入する道に現在のセンサス区間終点があったら一致とみなす
            if census_road[2] in mapfan_node[1:]:
                # センサス区間終点とノードに対応付けができたもの
                census_mf.extend([[census_road[0], mapfan_node[0]]])
                # TODO: 未確定のノードペアにセンサスセクションID値を登録する
                uncommitted_sections = mapfan_section[base_mapfan_node_ix:mapfan_node_ix]
                for section in uncommitted_sections:
                    if not section in mf_census:
                        mf_census[section] = census_road[0]
                base_mapfan_node_ix = mapfan_node_ix
                break
        else:
            # センサス区間とノードがマッチできなかったもの
            census_mf_not_matched.extend(
                [[census_road[0], tmp_mapfan_nodes[base_mapfan_node_ix][0]]])
    return (census_mf, census_mf_not_matched, mf_census)
def create_census_roads(road_name):
    """
    交通センサス区間情報を構築する.
    """
    # データ準備. ここでは国道1号線に限って考える
    census = census_d.fillna(0)
    # TODO: road_name ではなく, class, no カラムで絞るようにする
    census_road1 = census[census.v6 == road_name]
    census_tmp = census_road1[["v1", "v6",
                               "from_class", "from_no", "to_class", "to_no"]]
    census_tmp = census_tmp.astype(
        {"from_class": int, "from_no": int, "to_class": int, "to_no": int})
    census_list = census_tmp.values.tolist()
    # 道路交通センサスのレコードから, センサス区間ID, 始点流入, 終点流入情報を取得する.
    census_section = [(row[0], row[2:4], row[4:6]) for row in census_list]
    return census_section
def create_mapfan_nodes(paths, nodes, column_name):
    """
    MapFan ノード情報を構築する.
    """
    path = paths[[column_name]]
    path = path.dropna()
    path = path.astype({column_name: int})
    path_info = pd.merge(path, nodes, how="left",
                         left_on=column_name, right_on="objectid")
    path_info = path_info.fillna(0)
    path_info = path_info.astype({
        "class1": int, "no1": int,
        "class2": int, "no2": int,
        "class3": int, "no3": int,
        "class4": int, "no4": int,
        "class5": int, "no5": int,
        "class6": int, "no6": int,
        "class7": int, "no7": int,
        "class8": int, "no8": int})
    path_list = path_info.values.tolist()
    # mapfandb のノードの流入情報を取得する
    # TODO: 列番号を変える必要があるか確認
    mapfan_nodes = [
        (row[1], row[12:14], row[15:17], row[18:20], row[21:23],
         row[24:26], row[27:29], row[30:32], row[33:35])
        for row in path_list]
    return mapfan_nodes
# 砂田さんのアプローチを実装する
# TODO: 1. 県内の端点がある国道ごとにすべて処理を行う
# TODO: match_census_mf を路線ごとに実行する
# TODO: 2. 1. で登場しなかった路線が1.の辿りの中にあった場合, その路線をたどる.
def main():
    """
    道路交通センサスの区間と MapFan リンクを対応付けます.
    """
    # 対応付けに必要なデータ準備
    road_name = "一般国道１９号"
    census_roads = create_census_roads(road_name)
    # 愛知県の国道一号線のノードのつながり (all_simple_paths で導出したたどりのひとつ)
    paths = pd.read_csv("aichi_no19_paths.csv")
    # 全国の国道一号線が流入するノード
    nodes = node_info
    # センサス区間との対応付け
    # path 毎に処理を繰り返す
    mapfan_section_census_dict = {}  # mapfan 区間とセンサス区間の対応表
    census_mf = []                 # 交通センサス区間とノードの対応
    census_mf_not_matched = None   # 対応付けできなかった交通センサス区間
    for column_name in paths.columns:
        print("path: {}".format(column_name))
        # MapFan の経路の辿りを取得する
        tmp_mapfan_nodes = create_mapfan_nodes(paths, nodes, column_name)
        # センサス区間を構築する
        if census_mf_not_matched is None:
            # 初回実行時はセンサス区間は全区間
            tmp_census_roads = census_roads[:]
        else:
            # 未確定のセンサス区間データを構築する
            tmp_census_roads = [
                census_road for census_road in census_roads
                if census_road[0] in [cm[0] for cm in census_mf_not_matched]]
        tmp_census_mf, census_mf_not_matched, mapfan_section_census_dict = \
            match_census_mf(tmp_census_roads, tmp_mapfan_nodes,
                            mapfan_section_census_dict)
        # 対応付けできた組を併合する
        census_mf.extend(tmp_census_mf)
        print("path: {} matched, {} matched, {} unmatched".format(
            column_name, len(census_mf), len(census_mf_not_matched)))
        # センサス区間の結びつけが完了した場合はループを抜ける
        if not census_mf_not_matched:
            print("matching done")
            break
    # TODO: ここまでにたどったノードにない道路種別をたどる
    # 結果の出力
    #print(mapfan_section_census_dict)
    with open("match_census_result.csv", "w") as f:
    	for nodes, census_id in mapfan_section_census_dict.items():
    		f.write("{0[0]},{0[1]},{1}\n".format(nodes, census_id))
if __name__ == "__main__":
    main()