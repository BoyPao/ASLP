import os
import sys

inpath=r'U:\Pages\Spoken_language\assignment\system\lib\wlist'
outpath=r'U:\Pages\Spoken_language\assignment\system\lib\wdict'


if __name__ == "__main__":
    f = open(inpath,'r')
    ff= open(outpath,'a')
    flines=f.readlines()
    for fbuf in flines:
        fbuff=fbuf.strip()
        ff.write(fbuff+' '+fbuff+'\n')
        print(fbuff)
    f.close()
    ff.close()
