import os
import sys

path=r'U:\Pages\Spoken_language\assignment\system\data\wav\train\clean\DR1/'
mfcc_path=r'U:\Pages\Spoken_language\assignment\system\data\spec\train\clean\DR1/'
key_wav='.wav'
def detect_walk(dir_path):
    
    for root, dirs, files in os.walk(dir_path):
        for filename in files:
            if os.path.splitext(filename)[1]==key_wav:
                fp= os.path.join(root, filename)
                print(fp)
                f = open(r'U:\Pages\Spoken_language\assignment\system\list\TIMIT_clean.txt','a')
                f.write(filename+'\n')
                f.close()
                
        #for dirname in dirs:
            #if key==os.path.splitext(dirname)[1][1:]:
                #f = open('U:\Pages\Spoken_language\assignment\system\list\TIMIT_train_list.txt','a')
                #f.write(dirname)
                #f.close()


if __name__ == "__main__":
    detect_walk(path)

