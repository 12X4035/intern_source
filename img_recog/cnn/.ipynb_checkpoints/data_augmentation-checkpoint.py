from keras.preprocessing import image
def data_augmentation(img_arr, label, datagen):
    arg = []
    datagen = datagen
    for i in range(len(img_arr)):
        img_arr = img_arr
        label = label
        x = img_arr[i]
        x = x.reshape((1,) + x.shape)
        y = label[i]
        j=0
        for batch in datagen.flow(x, batch_size=1):
            arg.append((batch[0], y))
            j += 1
            if j % 4 == 0:
                break   
    return arg
