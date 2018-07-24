import os
import sys

path=r'U:\system\data\spec\train\clean\DR1/'
mlf_path=r'U:\system\label\task6_phoneme_withsp.mlf'
key_wav='.lab'
def detect_walk(dir_path):
    
    for root, dirs, files in os.walk(dir_path):
        for filename in files:
            if os.path.splitext(filename)[1]==key_wav:
                fp= os.path.join(root, filename)
                f = open(fp,'r')
                ff = open(mlf_path,'a')
                flines=f.readlines()
                ff.write('"'+fp+'"'+'\n')
                for fbuf in flines:
                    #word=fbuf.split(' ')[0]
                    #fbuff=' '.join(fbuf.split(' ')[2::]) 
                    print(fbuf)
                    ff.write(fbuf)
                ff.write('.'+'\n')
                f.close()
                ff.close()
                
        #for dirname in dirs:
            #if key==os.path.splitext(dirname)[1][1:]:
                #f = open('U:\Pages\Spoken_language\assignment\system\list\TIMIT_train_list.txt','a')
                #f.write(dirname)
                #f.close()


if __name__ == "__main__":
    detect_walk(path)

