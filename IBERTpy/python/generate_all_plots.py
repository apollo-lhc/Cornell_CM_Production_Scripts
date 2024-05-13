# -*- coding: utf-8 -*-
"""
Created on Fri Jul 21 16:40:12 2017

@author: msilvaol
modified by: duquale, Rui Zou
"""

from eyescan_plot import eyescan_plot
from glob import glob
import os.path
import numpy as np
import sys

minlog10ber = -8
overwrite = True

if len(sys.argv) != 3:
    print("Error: incorrect number of arguments \nPlease enter the board id of the board on which the scans were performed (e.g. CM203) followed by the date of the scans (e.g. 06-13-22) as the arguments for this command.")
else:
    #filename_i_list = glob('../scans/CM203/06-08-22/*.csv') # ---------------> date used to need to be modified here as a variable input before running (e.g. 06-13-22)
    filename_i_list = glob('../../scans/' + sys.argv[1] + '/' + sys.argv[2] + '/*.csv')
#    filename_i_list = glob('../../scans/' + sys.argv[1] + '/' + sys.argv[2] + '/*DFE*.csv')
    print(filename_i_list)
#    filename_o_list = [p.replace('csv','pdf').replace(' ','_') for p in filename_i_list]

    filename_o_list = [p.replace('csv','pdf') for p in filename_i_list]
    filename_nfso_list = [n.replace('../../scans/' + sys.argv[1] + '/' + sys.argv[2], '/nfs/cms/tracktrigger/apollo/' + sys.argv[1] + '/scans/' + sys.argv[2]) for n in filename_o_list]

    yticks = list(np.arange(-127,0,16))+[0]+list(np.arange(127,0,-16))[-1::-1]
    xticks = list(np.arange(-0.5,0.625,0.125))
    k=1
    #if os.path.exists('..\scans\eyedata.csv'):
    #    pass
    #else
    #    eyedict

    for i,o in zip(filename_i_list, filename_o_list):
        print('Saving file {0:03d} out of {1:d}.'.format(k,len(filename_i_list)))
        if (not os.path.exists(o)) or overwrite:
            eyescan_plot(i, o, minlog10ber, colorbar=True, xaxis=True, yaxis=True, xticks_f=xticks, yticks_f=yticks, mask_x1x2x3y1y2=(0.25, 0.4, 0.45, 0.25, 0.28))
        k += 1
        #break

    k=1
    for i,nfso in zip(filename_i_list, filename_nfso_list):
        print('Saving file {0:03d} out of {1:d}.'.format(k,len(filename_i_list)))
        if (not os.path.exists(nfso)) or overwrite:
            eyescan_plot(i, nfso, minlog10ber, colorbar=True, xaxis=True, yaxis=True, xticks_f=xticks, yticks_f=yticks, mask_x1x2x3y1y2=(0.25, 0.4, 0.45, 0.25, 0.28))
        k += 1
        #break 
