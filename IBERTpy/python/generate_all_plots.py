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
import re

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

    #yticks = list(np.arange(-127,0,16))+[0]+list(np.arange(127,0,-16))[-1::-1]
    #xticks = list(np.arange(-0.5,0.625,0.125))
    #Proposed change 127->63.5, 0.5->0.2, xticks 0.125->0.05
    yticks = list(np.arange(-63.5,0,16))+[0]+list(np.arange(63.5,0,-16))[-1::-1]
    xticks = list(np.arange(-0.2,0.25,0.05))
    k=1
    #if os.path.exists('..\scans\eyedata.csv'):
    #    pass
    #else
    #    eyedict

    failed_link_list_o = []
    for i,o in zip(filename_i_list, filename_o_list):
        print('Begin generating plots for user directory.')
        print('Saving file {0:03d} out of {1:d}.'.format(k,len(filename_i_list)))
        if (not os.path.exists(o)) or overwrite:
            failed_link_list_o.append(eyescan_plot(i, o, minlog10ber, colorbar=True, xaxis=True, yaxis=True, xticks_f=xticks, yticks_f=yticks, mask_x1x2x3y1y2=(0.25, 0.4, 0.45, 0.25, 0.28)))
        k += 1
        #break
    failed_link_list_o = list(filter(None, failed_link_list_o))

    failed_link_list_nfso = []
    k=1
    for i,nfso in zip(filename_i_list, filename_nfso_list):
        print('Begin generating plots for /nfs directory.')
        print('Saving file {0:03d} out of {1:d}.'.format(k,len(filename_i_list)))
        if (not os.path.exists(nfso)) or overwrite:
            failed_link_list_nfso.append(eyescan_plot(i, nfso, minlog10ber, colorbar=True, xaxis=True, yaxis=True, xticks_f=xticks, yticks_f=yticks, mask_x1x2x3y1y2=(0.25, 0.4, 0.45, 0.25, 0.28)))
        k += 1
        #break
    failed_link_list_nfso = list(filter(None, failed_link_list_nfso))
    #work in progress begin
    pattern_to_remove = r"_\test|\../../scans/"+sys.argv[1]+'/'+sys.argv[2]+"/eyescan_|\.csv"
    failed_link_list = [re.sub(pattern_to_remove, "", item) for item in failed_link_list_nfso]
    failed_output_dir = '/nfs/cms/tracktrigger/apollo/' + sys.argv[1] + '/scans/' + sys.argv[2]
    failed_output_file = 'failed_links.txt'
    full_failed_output_path = os.path.join(failed_output_dir, failed_output_file)
    os.makedirs(failed_output_dir, exist_ok=True)
    delimiter = " \n "
    failed_link_string = delimiter.join(failed_link_list)

    with open(full_failed_output_path, 'w') as f:
        f.write('Failed links: ')
        f.write(failed_link_string)
        f.write('\n')
    #work in progress end

    #print("List of links that fail the open area test:\n", failed_link_list_o, "\n")
    #print("List of links that fail the open area test:\n", failed_link_list_nfso, "\n")
    #print("The above lists should show the same links failing if the eyescan scripts were run properly.")
    print("List of links that fail the open area test:\n", failed_link_string)
