import numpy as np
import matplotlib.pyplot as plt
import cv2
from keras import models
from keras import backend as K

def layer_heatmap(model, select_img, last_conv, channel_num):
    
    last_conv = last_conv
    channel_num = channel_num
    select_img = select_img
    
    img = np.expand_dims(select_img, axis=0)
    
    preds = model.predict(img)
    np.argmax(preds[0])

    image_output = model.output[:, 1]

    last_conv_layer = model.get_layer(last_conv)

    grads = K.gradients(image_output, last_conv_layer.output)[0]

    pooled_grads = K.mean(grads, axis=(0, 1, 2))

    iterate = K.function([model.input], [pooled_grads, last_conv_layer.output[0]])
    
    pooled_grads_value, conv_layer_output_value = iterate([img])


    for i in range(channel_num):
        conv_layer_output_value[:, :, i] *= pooled_grads_value[i]

    heatmap = np.mean(conv_layer_output_value, axis=-1)
    heatmap = np.maximum(heatmap, 0)
    heatmap /= np.max(heatmap)


    heatmap_re = cv2.resize(heatmap, (select_img.shape[1], select_img.shape[0]))

    # We convert the heatmap to RGB
    heatmap_re = np.uint8(255 * heatmap_re)

    # We apply the heatmap to the original image
    heatmap_re = cv2.applyColorMap(heatmap_re, cv2.COLORMAP_JET)

    # 0.4 here is a heatmap intensity factor
    superimposed_img = heatmap_re * 0.4 + select_img
    

    plt.matshow(heatmap)
    plt.show()
    
    plt.imshow(select_img)
    plt.show()
    
    plt.imshow(superimposed_img)
    plt.show()
