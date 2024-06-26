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
from configparser import ConfigParser

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
config.read('config.ini')
server0_addr = config.get('hw_server','server0_addr')
server0_port = config.get('hw_server','server0_port')
target0_name = config.get('hw_server','target0_name')
target0_freq = config.get('hw_server','target0_freq')
server1_addr = config.get('hw_server','server1_addr')
server1_port = config.get('hw_server','server1_port')
target1_name = config.get('hw_server','target1_name')
target1_freq = config.get('hw_server','target1_freq')
mgt_rx = config.get('mgt_parameters','mgt_rx')
mgt_tx = config.get('mgt_parameters','mgt_tx')
TXDIFFSWING = config.get('mgt_parameters','TXDIFFSWING')
TXPOST = config.get('mgt_parameters','TXPOST')
TXPRE = config.get('mgt_parameters','TXPRE')
RXTERM = config.get('mgt_parameters','RXTERM')
tcl_dir = config.get('test','tcl_dir')
tcl_transm_name = config.get('test','tcl_transm_name')
tcl_rcv_name = config.get('test','tcl_rcv_name')
results_dir = config.get('test','results_dir')
results_name = config.get('test','results_name')
results_TXFPGA = config.get('test','results_TXFPGA')
results_RXFPGA = config.get('test','results_RXFPGA')
results_TXFPGAid = config.get('test','results_TXFPGAid')
results_RXFPGAid = config.get('test','results_RXFPGAid')
desired_area = config.getint('test','desired_area')
BER = config.get('test','BER')
err_req = config.getint('test','err_req')
include_all_results = config.getboolean('test','include_all_results')

mgt_rx = format_to_list(mgt_rx)
mgt_tx = format_to_list(mgt_tx)
TXDIFFSWING = format_to_list(TXDIFFSWING)
TXPOST = format_to_list(TXPOST)
TXPRE = format_to_list(TXPRE)
RXTERM = format_to_list(RXTERM)

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
create_dir(results_dir)
print("-- Main loop -------------------")
for mgt_idx in range(len(mgt_rx)):

    f = open("./" + results_dir + results_name + "Rx" + mgt_rx[mgt_idx] + results_RXFPGA + "_Tx" + mgt_tx[mgt_idx] + results_TXFPGA + "_ErrReq" + str(err_req) + "_BER" + BER.replace("\"","") + ".csv","w")
    f.write("TXDIFFSWING"
            + "," + "TXPRE"
            + "," + "TXPOST"
            + "," + "RXTERM"
            + "," + "Error_Count"
            + "," + "Open Area"
            + "\n")
    #obj_rx = "get_hw_sio_links *MGT_" + mgt_rx[mgt_idx] + "/RX"
    #obj_tx = "get_hw_sio_links *MGT_" + mgt_tx[mgt_idx] + "/RX" # /RX is the end of the string
    #obj_rx = "get_hw_sio_links *->*" + target0_name + "*MGT_" + mgt_rx[mgt_idx] + "/RX"  #Alec
    #obj_tx = "get_hw_sio_links *" + target1_name + "*MGT_" + mgt_tx[mgt_idx] + "/TX->*"  #Alec
    obj_link = "get_hw_sio_links *" + target1_name + results_TXFPGAid + "*MGT_" + mgt_tx[mgt_idx] + "/TX->*" + target0_name + results_RXFPGAid + "*MGT_" +mgt_rx[mgt_idx] + "/RX"
    print(obj_link)

#    rcv.scan_remove_all() #Rui
#    transm.scan_remove_all() #RUi

    iter = 0

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

#                    transm.reset_all_gth_tx()
 #                   rcv.reset_all_gth_rx()
                    transm.reset_all_gty_txdatapath() #Rui
                    rcv.reset_all_gty_rxdatapath() #Rui

                    print("------ Transceiver - " + mgt_rx[mgt_idx])
                    print("------ Iter: " + str(iter))
                    print(iter)
                    iter = iter+1

                    rcv.reset_sio_link_error(obj_link)
                    rcv.refresh_hw_sio(obj_link)
#                    time.sleep(0.01) # parameters are not instantly  #Rui
                                    # refreshed. Adjust it to be as small as
                                    # possible for your setup

                    link = rcv.get_property("LOGIC.LINK", obj_rx)
                    print("Rui: link: ", link)
                    err = "-1"

                    if link == "1":
                        err = rcv.get_property("LOGIC.ERRBIT_COUNT", obj_link)

                        if int(err,16) <= err_req: # convert str hex to int

                            rcv.scan_create("xil_scan", obj_link)
                            rcv.scan_set_all("6", "6", BER)
                            rcv.scan_run_all()

                            scan_area = rcv.get_property("Open_Area", "get_hw_sio_scan")

                            #scan_ber = rcv.get_property("RX_BER", obj_rx)

                            rcv.scan_remove_all() 
                            print("--- TXDIFFSWING: " + str(i) + "-- TXPRE: " + str(j) + "-- TXPOST: " + str(k) + "-- RXTERM: " + str(l) + "-- Error_Count: " + str(int(err,16)) + "-- Open_Area: " + str(scan_area) )
                            write_result_csv(f, i, j, k, l, str(int(err,16)), scan_area)
                            if int(float(scan_area)) > int(float(best_area)):
                                best_area = scan_area
                                best_err = str(int(err,16))
                                best_diff = i
                                best_txpre = j
                                best_txpost = k
                                best_rx = l

                    if (link == "0" or int(err,16) != 0) and include_all_results:
                        write_result_csv(f, i, j, k, l, str(int(err,16)), "0")

                    if int(float(best_area)) > desired_area:
                        break
                if int(float(best_area)) > desired_area:
                    break
            if int(float(best_area)) > desired_area:
                break
        if int(float(best_area)) > desired_area:
            break



    transm.set_property("TXDIFFSWING", best_diff, obj_link)
    transm.set_property("TXPRE", best_txpre, obj_link)
    transm.set_property("TXPOST", best_txpost, obj_link)
    rcv.set_property("RXTERM", best_rx, obj_link)

    print("exit main()")

    f.write("------------BEST------------\n")
    write_result_csv(f, best_diff, best_txpre, best_txpost, best_rx, best_err, best_area)
    f.close()

    print("End of " + mgt_rx[mgt_idx])

transm.close_hw()
rcv.close_hw()
