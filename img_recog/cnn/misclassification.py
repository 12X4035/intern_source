import numpy as np
import matplotlib.pyplot as plt

def check_misclassification_image(test_seikai_label, x_test, Y_test, classes):
    diff = test_seikai_label.reshape(-1,) - classes
    diff_num = np.count_nonzero(diff)
    diff_list = np.where(diff != 0)
    
    plt.figure(figsize=(15, 15))
    for i in range(diff_num):
        plt.subplots_adjust(left=0, right=1, top=1, bottom=0)
        plt.subplot(10, 10, i + 1)
        plt.imshow(x_test[diff_list][i], 'gray')
        plt.axis("off")
        plt.text(0, -5, Y_test[diff_list][i], fontsize=14, color='blue')
        plt.text(15, -5, classes[diff_list][i], fontsize=14, color='red')
