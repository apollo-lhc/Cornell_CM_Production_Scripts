# -*- coding: utf-8 -*-
"""
Created on Fri Jul 21 16:40:12 2017

@author: msilvaol
modified by: duquale, Rui Zou
"""

from glob import glob
import os.path
import sys
import re
import numpy as np
from eyescan_plot import eyescan_plot

# user parameters
minlog10ber = -8
overwrite = True
basedir_user = '../../scans/'
basedir_nfso = '/nfs/cms/tracktrigger/apollo/'

def help_message():
    """
    Print help message for correct script usage.
    """
    print("Usage: python generate_all_plots.py <board_id> <date>")
    print("  <board_id>: Board ID in the format CM3XXY (e.g. CM3003)")
    print("  <date>: Date of the scans in the format MM-DD-YY (e.g. 06-13-25)")
    print(f"Looks for plots in: {basedir_user}<board_id>/<date>/")

if len(sys.argv) != 3:
    print("Error: incorrect number of arguments.")
    help_message()
    sys.exit(1)

CM=sys.argv[1]
# make sure this is "CM" + a four-digit number starting with 3 (rev3 CMs)
cm_pattern = r'^CM3\d{3}$'
if not re.match(cm_pattern, CM):
    print("Error: board id format is incorrect.")
    help_message()
    sys.exit(1)

date=sys.argv[2]
# make sure this is a valid date format
date_pattern = r'^\d{2}-\d{2}-\d{2}$'
if not re.match(date_pattern, date):
    print("Error: date format is incorrect.")
    help_message()
    sys.exit(1)


filedir = basedir_user + CM + '/' + date
filename_i_list = glob(filedir + '/*.csv')
if not filename_i_list:
    print(f"No input files found in {filedir}. Please check the path and try again.")
    help_message()
    sys.exit(1)

#    filename_i_list = glob('../../scans/' + CM + '/' + date + '/*DFE*.csv')
print(filename_i_list)
#    filename_o_list = [p.replace('csv','pdf').replace(' ','_') for p in filename_i_list]

filename_o_list = [p.replace('csv','pdf') for p in filename_i_list]
filename_nfso_list = [n.replace('../../scans/' + CM + '/' + date, basedir_nfso + CM + '/scans/' + date) for n in filename_o_list]

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
        failed_link_list_o.append(eyescan_plot(i, o, minlog10ber, colorbar=True, xaxis=True, yaxis=True,
                                               xticks_f=xticks, yticks_f=yticks, 
                                               mask_x1x2x3y1y2=(0.25, 0.4, 0.45, 0.25, 0.28)))
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
pattern_to_remove = r"_\test|\../../scans/"+CM+'/'+date+"/eyescan_|\.csv"
failed_link_list = [re.sub(pattern_to_remove, "", item) for item in failed_link_list_o]
failed_output_dir = basedir_nfso + CM + '/scans/' + date
#failed_output_dir = filedir
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
