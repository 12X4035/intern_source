import cv2
from cut_window import cut_window_by_coordinate
from keras.preprocessing.image import img_to_array

def patch (pic_info, width, height, slide):
    j = 0
    X = []
    
    pic_info = pic_info
    patch = []
    p_id = []
    label = []
    x_y_label = []

    sample_size = len(pic_info)  # 2以上である必要あり

    # パッチのサイズの情報
    window_width = width
    window_height = height
    slide_width = slide

    for j in range(0, sample_size, 1):

        patient_id = pic_info['patient_id'][j]
        tumor_left_x = pic_info['tumor_left_x'][j]
        tumor_upper_y = pic_info['tumor_upper_y'][j]
        tumor_width = pic_info['tumor_width'][j]
        tumor_height = pic_info['tumor_height'][j]
        default_left_x = pic_info['default_left_x'][j]
        default_upper_y = pic_info['default_upper_y'][j]
        max_left_x = pic_info['max_left_x'][j]
        max_upper_y = pic_info['max_upper_y'][j]
        file_path = pic_info['file_path'][j]
    
        img = cv2.imread(file_path)       

        # 写真の中の(100, 100) から (440, 440)までの間でパッチを作る
        # パッチの大きさは100 * 100にする
        # スライド幅は20ずつにする
        # sliding windowにより作られるパッチの数は (340 - 100) / 20 * (340 - 100) / 20 = 144個
        # それが5つぶんで 144 * 5 = 720個
            
        i = 0

        for left_x in range(default_left_x, max_left_x, slide_width):
            for upper_y in range(default_upper_y, max_upper_y, slide_width):
                img_patch = cut_window_by_coordinate(img, left_x, upper_y, window_width, window_height)
            
                X.append(img_to_array(img_patch/255.0))
            
                # 癌が含まれているかの判定 完全に領域を含んでいる場合のみ検出する
                if tumor_left_x >= left_x and tumor_left_x + tumor_width <= left_x + window_width and tumor_upper_y >= upper_y and tumor_upper_y + tumor_height <= upper_y + window_height:
                    contains_tumor = 1 
                else: contains_tumor = 0
            
                # 角フラグを立てる
                if left_x == default_left_x or left_x == max_left_x - slide_width:
                    corner_flag = 1
                else: corner_flag = 0
            
                # patch_idの付与 一応
                patch_id = patient_id + str(left_x) + str(upper_y)      
            
                #画像とlabelの対応を確実に行う
                x_y_set = (img_to_array(img_patch/255.0), contains_tumor, patient_id, patch_id)
            
                p_id.append(patient_id)
                patch.append(patch_id)
                label.append(contains_tumor)
                x_y_label.append(x_y_set)
            
                i += 1
    return x_y_label
