#-----------------------------------------------------------------------------
# Title      : Autotuning System for Xilinx MGTs
# Project    :
#-----------------------------------------------------------------------------
# File       : run.py
# Author     : Vitor Finotti Ferreira
# Company    :
# Created    : 2017-07-12
# Last update: 2017-07-12
# Standard   : Python 3.4
#-----------------------------------------------------------------------------
# Description:
#
# Autotuning script for the KC705 GTX transceivers
#
#-----------------------------------------------------------------------------
# Copyright (c) 2017 Vitor Finotti Ferreira
#-----------------------------------------------------------------------------
# Revisions  :
# Date        Version  Author          Description
# 2017-Jul-12 1.0      vfinotti        Created
# 2019-Mar-26 1.1      rglein          Added support for different Rx and Tx.
#                                      Added error counter and BER as defined 
#                                      in config and print it in results.
# 2022-May-24 1.2      rzou            Modified reset procedure.
#                                      Modified waiting procedure after reset.
#                                      Modified output format. 
#-----------------------------------------------------------------------------


from classes.pyIBERT import pyIBERT
import time
import os
import sys
from configparser import ConfigParser
from datetime import date
today = date.today()
date = today.strftime("%m-%d-%y")

# Functions
def create_dir(dir):
    # checks if data subdirectory exists. If not, create it.
    os.makedirs(os.getcwd() + "/" + os.path.dirname(dir), exist_ok=True)

def format_to_list(data):
    data = data.replace(",\n",",")
    data = data.split(",")
    return data

def write_result_csv(f, TXDIFFSWING, TXPRE, TXPOST, RXTERM, err, scan_area):
    f.write(TXDIFFSWING
            + "," +  TXPRE
            + "," +  TXPOST
            + "," +  RXTERM
            + "," +  err
            + "," +  scan_area
            + "\n")

# Load init
config = ConfigParser()
config.read('config_linkcheck.ini')
server0_addr = config.get('hw_server','server0_addr')
server0_port = config.get('hw_server','server0_port')
target0_name = config.get('hw_server','target0_name')
target0_freq = config.get('hw_server','target0_freq')
server1_addr = config.get('hw_server','server1_addr')
server1_port = config.get('hw_server','server1_port')
target1_name = config.get('hw_server','target1_name')
target1_freq = config.get('hw_server','target1_freq')
#mgt_rx = config.get('mgt_parameters','mgt_rx')
#mgt_tx = config.get('mgt_parameters','mgt_tx')
mgt_rx_0_1 = config.get('mgt_parameters','0_1_mgt_rx')
mgt_tx_0_1 = config.get('mgt_parameters','0_1_mgt_tx')
mgt_rx_1_1 = config.get('mgt_parameters','1_1_mgt_rx')
mgt_tx_1_1 = config.get('mgt_parameters','1_1_mgt_tx')
#mgt_rx_inter = config.get('mgt_parameters','inter_mgt_rx')
#mgt_tx_inter = config.get('mgt_parameters','inter_mgt_tx')
mgt_rx_0to1 = config.get('mgt_parameters','0to1_mgt_rx')
mgt_tx_0to1 = config.get('mgt_parameters','0to1_mgt_tx')
mgt_rx_1to0 = config.get('mgt_parameters','1to0_mgt_rx')
mgt_tx_1to0 = config.get('mgt_parameters','1to0_mgt_tx')
TXDIFFSWING = config.get('mgt_parameters','TXDIFFSWING')
TXPOST = config.get('mgt_parameters','TXPOST')
TXPRE = config.get('mgt_parameters','TXPRE')
RXTERM = config.get('mgt_parameters','RXTERM')
tcl_dir = config.get('test','tcl_dir')
tcl_transm_name = config.get('test','tcl_transm_name')
tcl_rcv_name = config.get('test','tcl_rcv_name')
results_dir = config.get('test','results_dir')
results_name = config.get('test','results_name')
#results_TXFPGA = config.get('test','results_TXFPGA')
#results_RXFPGA = config.get('test','results_RXFPGA')
#results_TXFPGAid = config.get('test','results_TXFPGAid')
#results_RXFPGAid = config.get('test','results_RXFPGAid')
results_TXFPGA_0_1 = config.get('test','0_1_results_TXFPGA')
results_RXFPGA_0_1 = config.get('test','0_1_results_RXFPGA')
results_TXFPGAid_0_1 = config.get('test','0_1_results_TXFPGAid')
results_RXFPGAid_0_1 = config.get('test','0_1_results_RXFPGAid')
results_TXFPGA_1_1 = config.get('test','1_1_results_TXFPGA')
results_RXFPGA_1_1 = config.get('test','1_1_results_RXFPGA')
results_TXFPGAid_1_1 = config.get('test','1_1_results_TXFPGAid')
results_RXFPGAid_1_1 = config.get('test','1_1_results_RXFPGAid')
#results_TXFPGA_inter = config.get('test','inter_results_TXFPGA')
#results_RXFPGA_inter = config.get('test','inter_results_RXFPGA')
#results_TXFPGAid_inter = config.get('test','inter_results_TXFPGAid')
#results_RXFPGAid_inter = config.get('test','inter_results_RXFPGAid')
results_TXFPGA_0to1 = config.get('test','0to1_results_TXFPGA')
results_RXFPGA_0to1 = config.get('test','0to1_results_RXFPGA')
results_TXFPGAid_0to1 = config.get('test','0to1_results_TXFPGAid')
results_RXFPGAid_0to1 = config.get('test','0to1_results_RXFPGAid')
results_TXFPGA_1to0 = config.get('test','1to0_results_TXFPGA')
results_RXFPGA_1to0 = config.get('test','1to0_results_RXFPGA')
results_TXFPGAid_1to0 = config.get('test','1to0_results_TXFPGAid')
results_RXFPGAid_1to0 = config.get('test','1to0_results_RXFPGAid')
desired_area = config.getint('test','desired_area')
BER = config.get('test','BER')
err_req = config.getint('test','err_req')
include_all_results = config.getboolean('test','include_all_results')

#mgt_rx = format_to_list(mgt_rx)
#mgt_tx = format_to_list(mgt_tx)
if not mgt_rx_0_1 or not mgt_tx_0_1:
    print("No link provided for FPGA1->FPGA1 case.")
    mgt_rx_0_1 = format_to_list(mgt_rx_0_1)
    mgt_tx_0_1 = format_to_list(mgt_tx_0_1)
    len_mgt_0_1 = 0
else:
    mgt_rx_0_1 = format_to_list(mgt_rx_0_1)
    mgt_tx_0_1 = format_to_list(mgt_tx_0_1)
    len_mgt_0_1 = len(mgt_rx_0_1)
if not mgt_rx_1_1 or not mgt_tx_1_1:
    print("No link provided for FPGA2->FPGA2 case.")
    mgt_rx_1_1 = format_to_list(mgt_rx_1_1)
    mgt_tx_1_1 = format_to_list(mgt_tx_1_1)
    len_mgt_1_1 = 0
else:
    mgt_rx_1_1 = format_to_list(mgt_rx_1_1)
    mgt_tx_1_1 = format_to_list(mgt_tx_1_1)
    len_mgt_1_1 = len(mgt_rx_1_1)
#mgt_rx_inter = format_to_list(mgt_rx_inter)
#mgt_tx_inter = format_to_list(mgt_tx_inter)
if not mgt_rx_0to1 or not mgt_tx_0to1:
    print("No link provided for FPGA1->FPGA2 case.")
    mgt_rx_0to1 = format_to_list(mgt_rx_0to1)
    mgt_tx_0to1 = format_to_list(mgt_tx_0to1)
    len_mgt_0to1 = 0
else:
    mgt_rx_0to1 = format_to_list(mgt_rx_0to1)
    mgt_tx_0to1 = format_to_list(mgt_tx_0to1)
    len_mgt_0to1 = len(mgt_rx_0to1)
if not mgt_rx_1to0 or not mgt_tx_1to0:
    print("No link provided for FPGA2->FPGA1 case.")
    mgt_rx_1to0 = format_to_list(mgt_rx_1to0)
    mgt_tx_1to0 = format_to_list(mgt_tx_1to0)
    len_mgt_1to0 = 0
else:
    mgt_rx_1to0 = format_to_list(mgt_rx_1to0)
    mgt_tx_1to0 = format_to_list(mgt_tx_1to0)
    len_mgt_1to0 = len(mgt_rx_1to0)
#mgt_rx = mgt_rx_0_1 + mgt_rx_1_1 + mgt_rx_inter
#mgt_tx = mgt_tx_0_1 + mgt_tx_1_1 + mgt_tx_inter
preclean_mgt_rx = mgt_rx_0_1 + mgt_rx_1_1 + mgt_rx_0to1 + mgt_rx_1to0
preclean_mgt_tx = mgt_tx_0_1 + mgt_tx_1_1 + mgt_tx_0to1 + mgt_tx_1to0
mgt_rx = list(filter(None, preclean_mgt_rx))
mgt_tx = list(filter(None, preclean_mgt_tx))
TXDIFFSWING = format_to_list(TXDIFFSWING)
TXPOST = format_to_list(TXPOST)
TXPRE = format_to_list(TXPRE)
RXTERM = format_to_list(RXTERM)

#dictionary mapping the links to the quads for the apollo Rev3 design
Quad_dict = {"X0Y4": "Quad_121_", "X0Y5": "Quad_121_", "X0Y6": "Quad_121_", "X0Y7": "Quad_121_",
             "X0Y8": "Quad_122_", "X0Y9": "Quad_122_", "X0Y10": "Quad_122_", "X0Y11": "Quad_122_",
             "X0Y12": "Quad_123_", "X0Y13": "Quad_123_", "X0Y14": "Quad_123_", "X0Y15": "Quad_123_",
             "X0Y16": "Quad_124_", "X0Y17": "Quad_124_", "X0Y18": "Quad_124_", "X0Y19": "Quad_124_",
             "X0Y20": "Quad_125_", "X0Y21": "Quad_125_", "X0Y22": "Quad_125_", "X0Y23": "Quad_125_",
             "X0Y24": "Quad_126_", "X0Y25": "Quad_126_", "X0Y26": "Quad_126_", "X0Y27": "Quad_126_",
             "X0Y28": "Quad_127_", "X0Y29": "Quad_127_", "X0Y30": "Quad_127_", "X0Y31": "Quad_127_",
             "X0Y32": "Quad_128_", "X0Y33": "Quad_128_", "X0Y34": "Quad_128_", "X0Y35": "Quad_128_",
             "X0Y36": "Quad_129_", "X0Y37": "Quad_129_", "X0Y38": "Quad_129_", "X0Y39": "Quad_129_",
             "X0Y40": "Quad_130_", "X0Y41": "Quad_130_", "X0Y42": "Quad_130_", "X0Y43": "Quad_130_",
             "X0Y44": "Quad_131_", "X0Y45": "Quad_131_", "X0Y46": "Quad_131_", "X0Y47": "Quad_131_",
             "X0Y48": "Quad_132_", "X0Y49": "Quad_132_", "X0Y50": "Quad_132_", "X0Y51": "Quad_132_",
             "X0Y52": "Quad_133_", "X0Y53": "Quad_133_", "X0Y54": "Quad_133_", "X0Y55": "Quad_133_",
             "X0Y56": "Quad_134_", "X0Y57": "Quad_134_", "X0Y58": "Quad_134_", "X0Y59": "Quad_134_",
             "X1Y4": "Quad_221_", "X1Y5": "Quad_221_", "X1Y6": "Quad_221_", "X1Y7": "Quad_221_",
             "X1Y8": "Quad_222_", "X1Y9": "Quad_222_", "X1Y10": "Quad_222_", "X1Y11": "Quad_222_",
             "X1Y12": "Quad_223_", "X1Y13": "Quad_223_", "X1Y14": "Quad_223_", "X1Y15": "Quad_223_",
             "X1Y16": "Quad_224_", "X1Y17": "Quad_224_", "X1Y18": "Quad_224_", "X1Y19": "Quad_224_",
             "X1Y20": "Quad_225_", "X1Y21": "Quad_225_", "X1Y22": "Quad_225_", "X1Y23": "Quad_225_",
             "X1Y24": "Quad_226_", "X1Y25": "Quad_226_", "X1Y26": "Quad_226_", "X1Y27": "Quad_226_",
             "X1Y28": "Quad_227_", "X1Y29": "Quad_227_", "X1Y30": "Quad_227_", "X1Y31": "Quad_227_",
             "X1Y32": "Quad_228_", "X1Y33": "Quad_228_", "X1Y34": "Quad_228_", "X1Y35": "Quad_228_",
             "X1Y36": "Quad_229_", "X1Y37": "Quad_229_", "X1Y38": "Quad_229_", "X1Y39": "Quad_229_",
             "X1Y40": "Quad_230_", "X1Y41": "Quad_230_", "X1Y42": "Quad_230_", "X1Y43": "Quad_230_",
             "X1Y44": "Quad_231_", "X1Y45": "Quad_231_", "X1Y46": "Quad_231_", "X1Y47": "Quad_231_",
             "X1Y48": "Quad_232_", "X1Y49": "Quad_232_", "X1Y50": "Quad_232_", "X1Y51": "Quad_232_",
             "X1Y52": "Quad_233_", "X1Y53": "Quad_233_", "X1Y54": "Quad_233_", "X1Y55": "Quad_233_",
             "X1Y56": "Quad_234_", "X1Y57": "Quad_234_", "X1Y58": "Quad_234_", "X1Y59": "Quad_234_"}
FF_FPGA_dict = {"xcvu13p_0": "_F1", "xcvu13p_1": "_F2"}
FF_dict = {"X0Y4": "_1_", "X0Y5": "_1_", "X0Y6": "_1_", "X0Y7": "_1_",
           "X0Y8": "_1_", "X0Y9": "_1_", "X0Y10": "_1_", "X0Y11": "_1_",
           "X0Y12": "_1_", "X0Y13": "_1_", "X0Y14": "_1_", "X0Y15": "_1_",
           "X0Y16": "_5_", "X0Y17": "_5_", "X0Y18": "_5_", "X0Y19": "_5_",
           "X0Y20": "_2_", "X0Y21": "_2_", "X0Y22": "_2_", "X0Y23": "_2_",
           "X0Y24": "_2_", "X0Y25": "_2_", "X0Y26": "_2_", "X0Y27": "_2_",
           "X0Y28": "_2_", "X0Y29": "_2_", "X0Y30": "_2_", "X0Y31": "_2_",
           "X0Y32": "_3_", "X0Y33": "_3_", "X0Y34": "_3_", "X0Y35": "_3_",
           "X0Y36": "_3_", "X0Y37": "_3_", "X0Y38": "_3_", "X0Y39": "_3_",
           "X0Y40": "_3_", "X0Y41": "_3_", "X0Y42": "_3_", "X0Y43": "_3_",
           "X0Y44": "_6_", "X0Y45": "_6_", "X0Y46": "_6_", "X0Y47": "_6_",
           "X0Y48": "_4_", "X0Y49": "_4_", "X0Y50": "_4_", "X0Y51": "_4_",
           "X0Y52": "_4_", "X0Y53": "_4_", "X0Y54": "_4_", "X0Y55": "_4_",
           "X0Y56": "_4_", "X0Y57": "_4_", "X0Y58": "_4_", "X0Y59": "_4_"}

# Main script
print("----------------------------------------------------------------------")
print("-- Creating Instance 0 ---------")
rcv = pyIBERT(server0_addr,server0_port,target0_name,target0_freq)
print("-- Creating Instance 1 ---------")
transm = pyIBERT(server1_addr,server1_port,target1_name,target1_freq)
print("-- Source rcv ------------------")
rcv.source("./" + tcl_dir + tcl_rcv_name + ".tcl")
print("-- Source trm ------------------")
transm.source("./" + tcl_dir + tcl_transm_name + ".tcl")
print("-- Creating dir ----------------")
#create_dir("/nfs/cms/tracktrigger/apollo/" + sys.argv[1] + "/" + results_dir + date)
if len(sys.argv) != 2:
    print("Error: Incorrect number of arguments. Please add the CM id as an argument when running this script, e.g. python3 run_linkcheck.py CM3002")
os.makedirs("/nfs/cms/tracktrigger/apollo/" + sys.argv[1] + "/" + results_dir + date, exist_ok=True)
print("Saving autotune results to /nfs/cms/tracktrigger/apollo/" + sys.argv[1] + "/" + results_dir + date)
print("-- Main loop -------------------")
link_counter = 0
for mgt_idx in range(len(mgt_rx)):
    link_counter += 1

    if mgt_idx < len_mgt_0_1:
        results_TXFPGA = results_TXFPGA_0_1
        results_RXFPGA = results_RXFPGA_0_1
        results_TXFPGAid = results_TXFPGAid_0_1
        results_RXFPGAid = results_RXFPGAid_0_1
    elif mgt_idx >= len_mgt_0_1 and mgt_idx < (len_mgt_0_1 + len_mgt_1_1):
        results_TXFPGA = results_TXFPGA_1_1
        results_RXFPGA = results_RXFPGA_1_1
        results_TXFPGAid = results_TXFPGAid_1_1
        results_RXFPGAid = results_RXFPGAid_1_1
    elif mgt_idx >= (len_mgt_0_1 + len_mgt_1_1) and mgt_idx < (len_mgt_0_1 + len_mgt_1_1 + len_mgt_0to1):
        results_TXFPGA = results_TXFPGA_0to1
        results_RXFPGA = results_RXFPGA_0to1
        results_TXFPGAid = results_TXFPGAid_0to1
        results_RXFPGAid = results_RXFPGAid_0to1
    else:
        results_TXFPGA = results_TXFPGA_1to0
        results_RXFPGA = results_RXFPGA_1to0
        results_TXFPGAid = results_TXFPGAid_1to0
        results_RXFPGAid = results_RXFPGAid_1to0
    #else:
    #    results_TXFPGA = results_TXFPGA_inter
    #    results_RXFPGA = results_RXFPGA_inter
    #    results_TXFPGAid = results_TXFPGAid_inter
    #    results_RXFPGAid = results_RXFPGAid_inter

    if len(sys.argv) != 2:
        print("Error: Incorrect number of arguments. Please add the CM id as an argument when running this script, e.g. python3 run_rev3_prodtest.py CM3002")
        break
    #f = open("/nfs/cms/tracktrigger/apollo/" + sys.argv[1] + "/" + results_dir + date + "/" + results_name + "Rx" + mgt_rx[mgt_idx] + results_RXFPGA + "_Tx" + mgt_tx[mgt_idx] + results_TXFPGA + "_ErrReq" + str(err_req) + "_BER" + BER.replace("\"","") + ".csv","w")
    if "X1" in mgt_rx[mgt_idx]:
        f = open("/nfs/cms/tracktrigger/apollo/" + sys.argv[1] + "/" + results_dir + date + "/" + results_name + "Rx_" + Quad_dict[mgt_rx[mgt_idx]] + mgt_rx[mgt_idx] + "_Tx_" + Quad_dict[mgt_tx[mgt_idx]] + mgt_tx[mgt_idx] + "_ErrReq" + str(err_req) + "_BER" + BER.replace("\"","") + ".csv","w")
    else:
        f = open("/nfs/cms/tracktrigger/apollo/" + sys.argv[1] + "/" + results_dir + date + "/" + results_name + "Rx" + FF_FPGA_dict[results_RXFPGA] + FF_dict[mgt_rx[mgt_idx]] + Quad_dict[mgt_rx[mgt_idx]] + mgt_rx[mgt_idx] + "_Tx" + FF_FPGA_dict[results_TXFPGA] + FF_dict[mgt_tx[mgt_idx]] + Quad_dict[mgt_tx[mgt_idx]] + mgt_tx[mgt_idx] + "_ErrReq" + str(err_req) + "_BER" + BER.replace("\"","") + ".csv","w")
    f.write("TXDIFFSWING"
            + "," + "TXPRE"
            + "," + "TXPOST"
            + "," + "RXTERM"
            + "," + "Error_Count"
            + "," + "Open Area"
            + "\n")
    #obj_rx = "get_hw_sio_links *MGT_" + mgt_rx[mgt_idx] + "/RX"
    #obj_tx = "get_hw_sio_links *MGT_" + mgt_tx[mgt_idx] + "/RX" # /RX is the end of the string
    obj_rx = "get_hw_sio_links *->*" + target0_name + "*" + results_RXFPGAid + "*MGT_" + mgt_rx[mgt_idx] + "/RX"  #Alec
    obj_tx = "get_hw_sio_links *" + target1_name + "*" + results_TXFPGAid + "*MGT_" + mgt_tx[mgt_idx] + "/TX->*"  #Alec
    obj_link = "get_hw_sio_links *" + target1_name + "*" + results_TXFPGAid + "*MGT_" + mgt_tx[mgt_idx] + "/TX->*" + target0_name + "*" + results_RXFPGAid + "*MGT_" +mgt_rx[mgt_idx] + "/RX"
    print("Link to autotune number " + str(link_counter) + ": " + obj_link)

#    rcv.scan_remove_all() #Rui
#    transm.scan_remove_all() #RUi

    iter = 0

    bad_biterror_counter = 0
    best_area = "-1"
    best_err = "-1"
    best_diff = TXDIFFSWING[0]
    best_rx = RXTERM[0]
    best_txpost = TXPOST[0]
    best_txpre = TXPRE[0]

    #import pdb; pdb.set_trace() # debug

    for i in TXDIFFSWING[::1]:
        transm.set_property("TXDIFFSWING", i, obj_link)
        for j in TXPRE[::1]:
            transm.set_property("TXPRE", j, obj_link)
            for k in TXPOST[::1]:
                transm.set_property("TXPOST", k, obj_link)
                for l in RXTERM[::1]:
                    rcv.set_property("RXTERM", l, obj_link)
                    #transm.set_property("RXTERM", l, obj_link)
                    print("Finished setting link properties for iteration.")

#                    transm.reset_all_gth_tx()
 #                   rcv.reset_all_gth_rx()
                    transm.reset_all_gty_txdatapath() #Rui
                    rcv.reset_all_gty_rxdatapath() #Rui
                    #transm.reset_all_gty_rxdatapath()
                    print("Finished reset of tx and rx datapath.")

                    print("------ Transceiver - " + mgt_rx[mgt_idx])
                    print("------ Iter: " + str(iter))
                    print(iter)
                    iter = iter+1

                    rcv.reset_sio_link_error(obj_link)
                    rcv.refresh_hw_sio(obj_link)
                    #transm.reset_sio_link_error(obj_link)
                    #transm.refresh_hw_sio(obj_link)
                    print("Finished refreshing link.")
#                    time.sleep(0.01) # parameters are not instantly  #Rui
                                    # refreshed. Adjust it to be as small as
                                    # possible for your setup

                    link = rcv.get_property("LOGIC.LINK", obj_link)
                    #link = transm.get_property("LOGIC.LINK", obj_link)
                    print("link: ", link)
                    err = "-1"

                    if link == "1":
                        err = rcv.get_property("LOGIC.ERRBIT_COUNT", obj_link)
                        #err = transm.get_property("LOGIC.ERRBIT_COUNT", obj_link)

                        if int(err,16) <= err_req: # convert str hex to int

                            rcv.scan_create("xil_scan", obj_link)
                            rcv.scan_set_all("6", "6", BER)
                            rcv.scan_run_all()
                            #transm.scan_create("xil_scan", obj_link)
                            #transm.scan_set_all("6", "6", BER)
                            #transm.scan_run_all()

                            scan_area = rcv.get_property("Open_Area", "get_hw_sio_scan")
                            #scan_area = transm.get_property("Open_Area", "get_hw_sio_scan")

                            #scan_ber = rcv.get_property("RX_BER", obj_rx)

                            rcv.scan_remove_all()
                            #transm.scan_remove_all()
                            print("--- TXDIFFSWING: " + str(i) + "-- TXPRE: " + str(j) + "-- TXPOST: " + str(k) + "-- RXTERM: " + str(l) + "-- Error_Count: " + str(int(err,16)) + "-- Open_Area: " + str(scan_area) )
                            write_result_csv(f, i, j, k, l, str(int(err,16)), scan_area)
                            if int(float(scan_area)) > int(float(best_area)):
                                best_area = scan_area
                                best_err = str(int(err,16))
                                best_diff = i
                                best_txpre = j
                                best_txpost = k
                                best_rx = l
                                
                        if (int(err,16) > err_req or int(err,16) == -1):
                            bad_biterror_counter = bad_biterror_counter+1
                                
                    if (link == "0" or int(err,16) != 0) and include_all_results:
                        write_result_csv(f, i, j, k, l, str(int(err,16)), "0")

                    if int(float(best_area)) > desired_area:
                        break
                    if bad_biterror_counter > 5:
                        break
                if int(float(best_area)) > desired_area:
                    break
                if bad_biterror_counter > 5:
                    break
            if int(float(best_area)) > desired_area:
                break
            if bad_biterror_counter > 5:
                break
        if int(float(best_area)) > desired_area:
            break
        if bad_biterror_counter > 5:
            print("LINK ERROR: Link has a bit error rate that is too high to properly autotune.")
            print("Skipping to next link to autotune")
            break



    transm.set_property("TXDIFFSWING", best_diff, obj_link)
    transm.set_property("TXPRE", best_txpre, obj_link)
    transm.set_property("TXPOST", best_txpost, obj_link)
    rcv.set_property("RXTERM", best_rx, obj_link)
    #transm.set_property("RXTERM", best_rx, obj_link)

    print("exit main()")

    f.write("------------BEST------------\n")
    write_result_csv(f, best_diff, best_txpre, best_txpost, best_rx, best_err, best_area)
    f.close()

    print("End of " + mgt_rx[mgt_idx])

transm.close_hw()
rcv.close_hw()
#transm.close_hw()
