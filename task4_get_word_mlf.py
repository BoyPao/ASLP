import os
import sys

path=r'U:\system\data\spec\test\clean\dr2/'
mlf_path=r'U:\system\label\task4_test_word1.mlf'
key_wav='.wrd'
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
                    print(str.lower(fbuf))
                    ff.write(str.lower(fbuf))
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

