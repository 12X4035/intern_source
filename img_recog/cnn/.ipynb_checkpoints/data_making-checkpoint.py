import numpy as np
import random
random.seed(12345)

from keras import backend as K
from sklearn.model_selection import train_test_split

def mk_data(x_y_label, patient):
    train_cancer=[]
    train_not_cancer=[]
    test_cancer=[]
    test_not_cancer=[]

    img_rows, img_cols = 100, 100

    for i in range(len(x_y_label)):
        if x_y_label[i][1] == 0 and x_y_label[i][2] != patient :
            train_not_cancer.append(x_y_label[i])
        elif x_y_label[i][1] == 1 and x_y_label[i][2] != patient :
            train_cancer.append(x_y_label[i])
        elif x_y_label[i][1] == 0 and x_y_label[i][2] == patient :
            test_not_cancer.append(x_y_label[i])
        elif x_y_label[i][1] == 1 and x_y_label[i][2] == patient :
            test_cancer.append(x_y_label[i])

#ラベルの比率合わせ
    train_length_min = min([len(train_cancer), len(train_not_cancer)])
    test_length_min = min([len(test_cancer), len(test_not_cancer)])

    train_cancer = random.sample(train_cancer, train_length_min)
    train_not_cancer = random.sample(train_not_cancer, train_length_min)
    test_cancer = random.sample(test_cancer, test_length_min)
    test_not_cancer = random.sample(test_not_cancer, test_length_min) 

    train_cancer.extend(train_not_cancer)
    test_cancer.extend(test_not_cancer)

    X_train, Y_train, _, _, = list(zip(*train_cancer))
    X_test, Y_test, _, _, = list(zip(*test_cancer))

    X_train = np.asarray(X_train)
    X_test = np.asarray(X_test)
                                                          
    Y_train = np.asarray(Y_train)
    Y_test = np.asarray(Y_test)

    from keras.utils.np_utils import to_categorical
    x_train = np.array(X_train).astype('float32')
    y_train = to_categorical(Y_train, 2)

    x_test = np.array(X_test).astype('float32')
    y_test = to_categorical(Y_test, 2)

# shapeの調整
    if K.image_data_format() == 'channels_first':
        X_train = X_train.reshape(X_train.shape[0], 3, img_rows, img_cols)
        X_test = X_test.reshape(X_test.shape[0], 3, img_rows, img_cols)
        input_shape = (1, img_rows, img_cols)
    else:
        X_train = X_train.reshape(X_train.shape[0], img_rows, img_cols, 3)
        X_test = X_test.reshape(X_test.shape[0], img_rows, img_cols, 3)
        input_shape = (img_rows, img_cols, 1)
    
    val_x_train, val_x_test, val_y_train, val_y_test = train_test_split(x_train, y_train, test_size=0.5, random_state=123)
    
    return Y_test, X_train, x_test, y_test, val_x_train, val_y_train, val_x_test, val_y_test

