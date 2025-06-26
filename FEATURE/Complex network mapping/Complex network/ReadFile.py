import os
import numpy as np
import scipy.io as scio
"""
Author: Wenjun
Description: read txt、mat...file
Date: 2023-04-07 15:34:21
LastEditTime: 2023-05-22 09:46:35
"""

#%% READ DATA
#np.set_printoptions(threshold=np.inf)
def Read_file(path,i,struct = 1):
    # path1 = 'D:\\sj\\sj\\tp'
    if i==1:
        files= os.listdir(path) 
        txts = []
        for file in files: 
            position = path+'\\'+ file #
            with open(position, "r",encoding='utf-8') as f:   
                data = f.read()  
                data = list(map(int, data.split(",")))
                txts.append(data)
        datas=np.array(txts)

    elif i==2:
        #path='./matlab.mat'
        data = scio.loadmat(path)
        name = scio.whosmat(path)
        datas = np.array(data[name[0][0]])

    elif i==3: 
        f = open(path)
        line = f.readlines()
        lines = len(line) 
        for l in line:
            le = l.split(',')
            columns = len(le)  
        datas = np.zeros((lines, columns), dtype=float)
        datas_row = 0
        for lin in line:
            line = lin.strip("\n")
            list1 = lin.split(",")
            datas[datas_row:] = [float(x) for x in list1]
            datas_row += 1

    elif i==4: 
        # data = scio.loadmat(path)
        name = scio.whosmat(path)
        datas = scio.loadmat(path)[name[0][0]][0, 0][struct]

    return  datas

def Read_fourwave(path):
    data = scio.loadmat(path)
    
    PPGdata = data['data']
    
    channel_1 = PPGdata[0][0][0]  
    channel_2 = PPGdata[0][0][1] 
    channel_3 = PPGdata[0][0][2]  
    channel_4 = PPGdata[0][0][3]  
    return channel_1,channel_2,channel_3,channel_4