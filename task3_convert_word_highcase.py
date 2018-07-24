import os
import sys

inpath=r'U:\system\label\task4_train_word.mlf'
outpath=r'U:\system\label\task4_train_word1.mlf'


if __name__ == "__main__":
    f = open(inpath,'r')
    ff= open(outpath,'a')
    flines=f.readlines()
    for fbuf in flines:
        fbuff=str.upper(fbuf)
        #word=fbuf.split(' ')[0]
        #fbuff= str.upper(word)+' '+' '.join(fbuf.split(' ')[1::])
        ff.write(fbuff)
        print(fbuff)
    f.close()
    ff.close()
