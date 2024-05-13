# -*- coding: utf-8 -*-
"""
Created on Fri Jul 21 12:29:54 2017

@author: msilvaol
https://github.com/mvsoliveira/IBERTpy

modified by Alec Duquette, Rui Zou
"""

import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np
import csv
import operator as op
from matplotlib.colors import ListedColormap
import matplotlib.pylab as pl
import matplotlib as mpl

import pandas as pd
from pylab import title, figure, xlabel, ylabel, xticks, bar, legend, axis, savefig
from fpdf import FPDF


def get_mb(two_points):
    m = np.true_divide(*reversed([np.subtract(*s) for s in zip(*two_points)]))
    b = two_points[0][1] - m * two_points[0][0]
    return [m,b]

def gen_mask(size,two_points,operator, mask=[]):
    [m, b] = get_mb(two_points)
    if mask ==[]:
        mask = np.ones(list(reversed(size)), dtype=bool)
    for (y,x), value in np.ndenumerate(mask):
        mask[y][x] &= operator(y,m*x+b)
    return mask

def plot_mask(mask):
    plt.figure(num=None, figsize=(10, 7), dpi=80, facecolor='w', edgecolor='k')
    plt.imshow(mask, interpolation='none', vmin=0, vmax=1, aspect='auto', alpha=1)
    plt.show()

def gen_diamond_mask(size,x1n,y1n):
    xm = size[0]
    ym = size[1]
    x1 = int(round(x1n*xm))
    y1 = int(round(y1n*ym))
    xhalf = int(round(0.5*xm))
    yhalf = int(round(0.5*ym))
    points = [[x1,yhalf],[xhalf,ym-y1],[xm-x1,yhalf],[xhalf,y1]]
    pairs = zip(points,points[1:]+[points[0]])
    ops = [op.lt, op.lt, op.gt, op.gt]
    mask = []
    for (p,o) in zip(pairs,ops):
        mask = gen_mask(size,p,o,mask)
    return mask

def gen_hexagon_mask(size,x1n,x2n,y1n):
    xm = size[0]
    ym = size[1]
    x1 = int(round(x1n*xm))
    x2 = int(round(x2n*xm))
    y1 = int(round(y1n*ym))
    yhalf = int(round(0.5*ym))
    points = [[x1,yhalf],[x2,ym-y1],[xm-x2,ym-y1],[xm-x1,yhalf],[xm-x2,y1],[x2,y1]]
    pairs = zip(points,points[1:]+[points[0]])
    ops = [op.lt, op.lt, op.lt, op.gt, op.gt, op.gt]
    mask = []
    for (p,o) in zip(pairs,ops):
        mask = gen_mask(size,p,o,mask)
        #plot_mask(mask)
    return mask

def gen_decagon_mask(size, x1n, x2n, x3n, y1n, y2n):
    xm = size[0]
    ym = size[1]
    x1 = int(round(x1n * xm))
    x2 = int(round(x2n * xm))
    x3 = int(round(x3n * xm))
    y1 = int(round(y1n * ym))
    y2 = int(round(y2n * ym))
    yhalf = int(round(0.5 * ym))
    points = [[x1, yhalf], [x2, ym - y2], [x3, ym - y1], [xm - x3, ym - y1], [xm - x2, ym - y2], [xm - x1, yhalf], [xm - x2, y2], [xm - x3, y1], [x3, y1], [x2, y2]]
    pairs = zip(points, points[1:] + [points[0]])
    ops = [op.lt, op.lt, op.lt, op.lt, op.lt, op.gt, op.gt, op.gt, op.gt, op.gt]
    mask = []
    for (p, o) in zip(pairs, ops):
        mask = gen_mask(size, p, o, mask)
        # plot_mask(mask)
    return mask

    # function for getting eye data
def get_eye(scan_list):
    eyedata = False
    yticks = []
    img = []
    for row in scan_list:
        if row[0].startswith('Scan End'):
            eyedata = False

        if eyedata:
            yticks.append(row[0])
            img.append(row[1:])

        if row[0].startswith('2d statistical'):
            xticks = row[1:]
            eyedata = True
    img = [[float(y) for y in x] for x in img]

    xticks = [int(x) for x in xticks]
    yticks = [int(y) for y in yticks]
    return [img, xticks, yticks]


#Mask Criteria: https://support.xilinx.com/s/question/0D52E00006iHnb2SAC/any-parameters-we-can-tune-gty-transceiver-to-make-eye-open-area-bigger?language=en_US
#Generate eyescan plots
def eyescan_plot(filename_i, filename_o, minlog10ber, colorbar=True, xaxis=True, yaxis=True, xticks_f=[],yticks_f=[], mask_x1x2x3y1y2 = (0.25, 0.4, 0.45, 0.25, 0.28)):
    
    # opens the file
    with open(filename_i, 'rb') as f:
            reader = csv.reader(map(bytes.decode,f))
            scan_list = list(reader)
            
            df = pd.DataFrame()
            df['SW Version'] = [scan_list[0][1]]
            #df['GT Type'] = [scan_list[1][1]] #removed
            df['Date and Time Started'] = [scan_list[1][1]] #[2][1]
            df['Date and Time Ended'] = [scan_list[2][1]] #[3][1]

            df2 = pd.DataFrame()
            df2['Reset RX'] = [scan_list[5][1]] #[6][1]
            df2['OA'] = [scan_list[6][1]] #[7][1]
            df2['HO'] = [scan_list[7][1]] #[8][1]
            df2['HO(%)'] = [scan_list[8][1]] #[9][1]
            df2['VO'] = [scan_list[9][1]] #[10][1]
            df2['VO(%)'] = [scan_list[10][1]] #[11][1]

            df3 = pd.DataFrame()
            df3['Dwell Type'] = [scan_list[11][1]] #[12][1]
            df3['Dwell BER'] = [scan_list[12][1]] #[13][1]
            df3['Horizontal Inc.'] = [scan_list[14][1]] #[15][1]
            df3['Vertical Inc.'] = [scan_list[16][1]] #[17][1]
            df3['Misc Info'] = [scan_list[18][1]] #[19][1]

                
    # getting eye data
    [img, xticks, yticks] = get_eye(scan_list)

    # Defining mask
    size = [len(xticks), len(yticks)]
#-0.118
    mask = gen_diamond_mask(size, 0.382, 0.3799)
##Mask Criteria: https://support.xilinx.com/s/question/0D52E00006iHnb2SAC/any-parameters-we-can-tune-gty-transceiver-to-make-eye-open-area-bigger?language=en_US 
# y: 61 steps. ym: -127->127 steps: (127-61/2)/(127x2) = 0.3799
# x: 0.236 UI wide. xm:-0.5->0.5 UIs: (0.5-0.236/2)/(0.5x2) = 0.382
    #mask = gen_hexagon_mask(size, 0.22, 0.375, 0.2)
#    mask = gen_decagon_mask(size, *mask_x1x2x3y1y2)

    # testing Mask
    Passed = True
    for (y, x), value in np.ndenumerate(mask):
        if mask[y][x]:
#            Passed &= img[y][x] < 1e-6  #Rui
            Passed &= img[y][x] < 1e-7

    # creating color map
    if Passed:
        color = 'green'
    else:
        color = 'red'
    cmap = mpl.colors.LinearSegmentedColormap.from_list('my_cmap', ['white', color], 2)
    my_cmap = cmap(np.arange(cmap.N))
    my_cmap[:, -1] = np.linspace(0, 1, cmap.N)
    my_cmap = ListedColormap(my_cmap)
        
    # function for calculating x-y axis ranges in a such way that ticks is in the center of each entry
    def get_extent(xticks_n,yticks_r):
        xmin = xticks_n[0]
        xmax = xticks_n[-1]
        xstep = (xmax-xmin)/(len(xticks_n)-1)
        xmin_e = xmin-xstep/2
        xmax_e = xmax+xstep/2
        ymin = yticks_r[0]
        ymax = yticks_r[-1]
        ystep = (ymax-ymin)/(len(yticks_r)-1)
        ymin_e = ymin-ystep/2
        ymax_e = ymax+ystep/2
        return [xmin_e, xmax_e, ymin_e, ymax_e]


    # Generating, formating plot    
    plt.figure(num=None, figsize=(10, 7), dpi=80, facecolor='w', edgecolor='k')
    xticks_n = [float(x)/(2*xticks[-1]) for x in xticks]
    yticks_r = [y for y in reversed(yticks)]
    myplot = plt.imshow(np.log10(img),interpolation='none', vmin = minlog10ber, vmax = 0, aspect='auto', extent = get_extent(xticks_n,yticks_r), cmap = 'jet')
    if not mask==[]:
        plt.imshow(mask, interpolation='none', vmin=0, vmax=1, aspect='auto',
                   extent=get_extent(xticks_n, yticks_r), cmap=my_cmap, origin='lower', alpha=0.9)


    if xaxis:
        if not yticks:
            plt.xticks(xticks_n)
        else:                             
            plt.xticks(xticks_f)
    if yaxis:
        if not yticks:
            plt.yticks(yticks_r)
        else:                             
            plt.yticks(yticks_f)
    else:
        plt.yticks([])
    
    # formating colorbar axis
    if colorbar:
        def fmt(x, pos):
            return '$10^{{{0:d}}}$'.format(x)        
        plt.colorbar(myplot, format=ticker.FuncFormatter(fmt), ticks=range(minlog10ber,1,1))
    # saving plot
    plt.savefig(filename_o.strip("pdf")+"png",bbox_inches='tight')

    # showing plot if needed
    #plt.show()
    pdf = FPDF()
    pdf.add_page()
    pdf.set_xy(0, 0)
    pdf.set_font('arial', 'B', 12)
    pdf.cell(60)
    pdf.cell(75, 10, " ", 0, 2, 'C')
    pdf.cell(90, 10, filename_o.strip(".pdf").split("/")[-1], 0, 2, 'C')
    pdf.ln(2)
    pdf.cell(30, 8, 'SW Version', 1, 0, 'C')
    #pdf.cell(30, 8, 'GT Type', 1, 0, 'C') #removed
    pdf.cell(70, 8, 'Date and Time Started', 1, 0, 'C')
    pdf.cell(60, 8, 'Date and Time Ended', 1, 0, 'C')
    pdf.ln(8)
    pdf.set_font('arial', '', 10)
    for i in range(0, len(df)):
        pdf.cell(30, 8, '%s' % (str(df['SW Version'].iloc[i])), 1, 0, 'C')
        #pdf.cell(30, 8, '%s' % (str(df['GT Type'].iloc[i])), 1, 0, 'C') #removed
        pdf.cell(70, 8, '%s' % (str(df['Date and Time Started'].iloc[i])), 1, 0, 'C')
        pdf.cell(60, 8, '%s' % (str(df['Date and Time Ended'].iloc[i])), 1, 0, 'C')
        

    pdf.ln(10)
    pdf.set_font('arial', 'B', 12)
    pdf.cell(75, 10, " ", 0, 2, 'C')
    pdf.cell(30, 8, 'Reset RX', 1, 0, 'C')
    pdf.cell(30, 8, 'OA', 1, 0, 'C')
    pdf.cell(35, 8, 'HO', 1, 0, 'C')
    pdf.cell(35, 8, 'HO(%)', 1, 0, 'C')
    pdf.cell(30, 8, 'VO', 1, 0, 'C')
    pdf.cell(30, 8, 'VO(%)', 1, 0, 'C')
    pdf.ln(8)
    pdf.set_font('arial', '', 10)
    for i in range(0, len(df2)):
        pdf.cell(30, 8, '%s' % (str(df2['Reset RX'].iloc[i])), 1, 0, 'C')
        pdf.cell(30, 8, '%s' % (str(df2['OA'].iloc[i])), 1, 0, 'C')
        pdf.cell(35, 8, '%s' % (str(df2['HO'].iloc[i])), 1, 0, 'C')
        pdf.cell(35, 8, '%s' % (str(df2['HO(%)'].iloc[i])), 1, 0, 'C')
        pdf.cell(30, 8, '%s' % (str(df2['VO'].iloc[i])), 1, 0, 'C')
        pdf.cell(30, 8, '%s' % (str(df2['VO(%)'].iloc[i])), 1, 0, 'C')
        

    pdf.ln(10)
    pdf.set_font('arial', 'B', 12)
    pdf.cell(75, 10, " ", 0, 2, 'C')
    pdf.cell(30, 8, 'Dwell Type', 1, 0, 'C')
    pdf.cell(30, 8, 'Dwell BER', 1, 0, 'C')
    pdf.cell(35, 8, 'Horizontal Inc.', 1, 0, 'C')
    pdf.cell(35, 8, 'Vertical Inc.', 1, 0, 'C')
    pdf.cell(60, 8, 'Misc Info', 1, 0, 'C')
    pdf.ln(8)
    pdf.set_font('arial', '', 10)
    for i in range(0, len(df3)):
        pdf.cell(30, 8, '%s' % (str(df3['Dwell Type'].iloc[i])), 1, 0, 'C')
        pdf.cell(30, 8, '%s' % (str(df3['Dwell BER'].iloc[i])), 1, 0, 'C')
        pdf.cell(35, 8, '%s' % (str(df3['Horizontal Inc.'].iloc[i])), 1, 0, 'C')
        pdf.cell(35, 8, '%s' % (str(df3['Vertical Inc.'].iloc[i])), 1, 0, 'C')
        pdf.cell(60, 8, '%s' % (str(df3['Misc Info'].iloc[i])), 1, 0, 'C')
        

    #pdf.cell(90, 10, " ", 0, 2, 'C')
    #pdf.cell(-30)

    #pdf.cell(60)
    #pdf.cell(75, 10, " " , 0, 2, 'C')
    #pdf.cell(90, 10, " ", 0, 2, 'C')
    #pdf.cell(-30)
    pdf.ln(10)
    pdf.image(filename_o.strip("pdf")+"png", x = None, y = None, w = 0, h = 0, type = '', link = '')
    pdf.output(filename_o, 'F')
    plt.close()
