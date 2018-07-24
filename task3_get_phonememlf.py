import os
import sys

path=r'U:\Pages\Spoken_language\assignment\system\data\wav\train\clean/'
mlf_path=r'U:\Pages\Spoken_language\assignment\system\lable\label_phoneme.mlf'
key_wav='.lab'
def detect_walk(dir_path):
    
    for root, dirs, files in os.walk(dir_path):
        for filename in files:
            if os.path.splitext(filename)[1]==key_wav:
                fp= os.path.join(root, filename)
                f = open(fp,'r')
                fbuf=f.read()
                f.close()
                print(fbuf)
                ff = open(mlf_path,'a')
                ff.write('"'+fp+'"'+'\n')
                ff.write(fbuf)
                ff.write('.'+'\n')
                ff.close()
                
        #for dirname in dirs:
            #if key==os.path.splitext(dirname)[1][1:]:
                #f = open('U:\Pages\Spoken_language\assignment\system\list\TIMIT_train_list.txt','a')
                #f.write(dirname)
                #f.close()


if __name__ == "__main__":
    detect_walk(path)

