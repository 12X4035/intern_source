# -*- coding: utf-8 -*-
import re
import numpy as np
# import gdal
from os.path import join,relpath
from glob import glob
import pandas as pd

# 参考にした
# http://sanvarie.hatenablog.com/entry/2016/01/10/163027

# TODO:
# いろいろごしゃごしゃやっているが, ほしいものは
# (緯度, 経度, 高度) のタプルが得られれば十分満足.


def main():
    #XMLを格納するフォルダ
    # path = "D:\python\DEM"
    path = 
    #GeoTiffを出力するフォルダ
    # geopath = "D:\python\GeoTiff"
    #ファイル名取得
    files = [relpath(x,path) for x in glob(join(path,'*'))]

    # 緯度, 経度, 高度を順に保持する
    lons = []
    lats = []
    heights = []

    for fl in files:
        xmlFile = join(path, fl)
        # XML から設定ファイルを取得する
        with open(xmlFile, "r", encoding="utf-8") as f:
            # 地図の左下の緯度経度
            r = re.compile("<gml:lowerCorner>(.+) (.+)</gml:lowerCorner>")
            for ln in f:
                m = r.search(ln)
                if m != None:
                    lry = float2(m.group(1))
                    ulx = float2(m.group(2))
                    # print(lry, ulx)
                    break

            # 地図の右上の緯度経度
            r = re.compile("<gml:upperCorner>(.+) (.+)</gml:upperCorner>")
            for ln in f:
                m = r.search(ln)
                if m != None:
                    uly = float2(m.group(1))
                    lrx = float2(m.group(2))
                    # print(uly, lrx)
                    break

            # 縦横の配列数
            r = re.compile("<gml:high>(.+) (.+)</gml:high>")
            for ln in f:
                m = r.search(ln)
                if m != None:
                    xlen = int(m.group(1)) + 1
                    ylen = int(m.group(2)) + 1
                    # print(xlen, ylen)
                    break

            startx = starty = 0

            # 開始配列インデックス
            r = re.compile("<gml:startPoint>(.+) (.+)</gml:startPoint>")
            for ln in f:
                m = r.search(ln)
                if m != None:
                    startx = int(m.group(1))
                    starty = int(m.group(2))
                    # print(startx, starty)
                    break

        # numpy 用にデータを格納
        with open(xmlFile, "r", encoding="utf-8") as f:
            src_document = f.read()
            lines = src_document.split("\n")
            num_lines = len(lines)
            l1 = None
            l2 = None
            for i in range(num_lines):
                if lines[i].find("<gml:tupleList>") != -1:
                    l1 = i + 1
                    break
            for i in range(num_lines - 1, -1, -1):
                if lines[i].find("</gml:tupleList>") != -1:
                    l2 = i - 1
                    break
            # print(l1, l2)

        #セルのサイズを算出
        psize_x = (lrx - ulx) / xlen
        psize_y = (lry - uly) / ylen
        # print(psize_x, psize_y)


        num_tuples = l2 - l1 + 1

        #スタートポジションを算出
        start_pos = starty * xlen + startx

        i = 0
        sx = startx

        # TODO: 緯度経度と組にして標高を格納したい
        # 標高を格納
        lat = uly
        for y in range(starty, ylen):
            lon = ulx
            for x in range(sx, xlen):
                if i < num_tuples:
                    vals = lines[i + l1].split(",")
                    if len(vals) == 2 and vals[1].find("-99") == -1:
                        # print(lon, lat, vals[1])
                        lons.append(lon)
                        lats.append(lat)
                        heights.append(float(vals[1]))
                    i += 1
                else:
                    break
                lon += psize_x
            if i == num_tuples:
                break
            sx = 0
            lat += psize_y
        print(fl)

    df = pd.DataFrame({"longitude": lons, "latitude": lats, "height": heights})
    df.to_csv("out.csv")
    return df

def float2(str):
    """
    文字列を浮動小数点数化する
    """
    lc = ""
    for i in range(len(str)):
        c = str[i]
        if c == lc:
            renzoku += 1
            if renzoku == 6:
                return float(str[:i+1] + c * 10)
        else:
            lc = c
            renzoku = 1
        return float(str)

if __name__ == "__main__":
    main()
