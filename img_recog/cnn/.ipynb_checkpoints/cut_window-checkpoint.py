def cut_window_by_coordinate(img, left_x, upper_y, window_width, window_height):
    """ 
    座標を指定することで、画像から矩形領域をカットする関数
    left_x : 左上のx座標
    upper_y : 左上のy座標
    window_width : 矩形の幅a
    window_height : 矩形の高さ
    """
    # 窓画像の左上座標
    x, y = left_x, upper_y
    # 窓画像の幅・高さ
    w, h = window_width, window_height
    # 入力画像から窓画像を切り取り
    roi = img[y:y+h, x:x+w]    
    return roi
