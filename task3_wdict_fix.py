import os
import sys

path=r'U:\system\lib1\wdict1'
mlf_path=r'U:\system\lib\wdict'
key_wav='.lab'

f = open(path,'r')
ff = open(mlf_path,'a')
flines=f.readlines()
for fbuf in flines:
    word1=fbuf[0:15]
    word2=fbuf[32:]

    word4=word1+word2
    #fbuff=' '.join(word1[::]) 
    print(word4)
    ff.write(word4)
ff.write('.'+'\n')
f.close()
ff.close()
                
        #for dirname in dirs:
            #if key==os.path.splitext(dirname)[1][1:]:
                #f = open('U:\Pages\Spoken_language\assignment\system\list\TIMIT_train_list.txt','a')
                #f.write(dirname)
                #f.close()


