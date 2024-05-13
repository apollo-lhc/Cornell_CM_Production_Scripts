# Script compares chip to sim
import os
import readline
# File Format:

 # TXDIFFSWING,TXPRE,TXPOST,RXTERM,Error_Count,Open Area,N Bits
 #name: defaultTxEq_RxX0Y16_TxX0Y16_ErrReq5000_BER1e-6_Bathtub.csv
#530 mV (00101),0.01 dB (00000),0.00 dB (00000),800 mV,0,68.75,434712880
#530 mV (00101),0.01 dB (00000),2.28 dB (01001),800 mV,0,70.3125,396994560
#530 mV (00101),0.01 dB (00000),3.99 dB (01111),800 mV,0,70.3125,409309200
#530 mV (00101),0.01 dB (00000),5.81 dB (10100),800 mV,16960,0


outputfile_4 = open("combined_ff4.txt", 'w')
outputfile_12 = open("combined_ff12.txt", 'w')  


TxEqs = ["defaultTxEq", "TxEqBin1_", "TxEqBin2_", "TxEqBin3_", "TxEqBin4_"]
TXEQs_12 = ["0", "1", "2", "4", "7"]
TXEQs_4 = ["2.7", "1.3", "3.7", "6.5", "8.8"] 
TXDIFFSWINGs = ["530 mV (00101)","950 mV (11000)","1040 mV (11111)"]
TXPOSTs = ["0.00 dB (00000)","2.28 dB (01001)","3.99 dB (01111)","5.81 dB (10100)"]
TXPREs =  ["0.01 dB (00000)","2.24 dB (01001)","3.90 dB (01111)"]
ff_4 = ["X0Y16","X0Y17","X0Y18","X0Y19","X0Y32","X0Y33","X0Y34","X0Y35"]
ff_12 = ["X0Y48","X0Y49","X0Y50","X0Y51","X0Y52","X0Y53","X0Y54","X0Y55","X0Y56","X0Y57","X0Y58","X0Y59"]


Nlinks_noerrors = [[[[],[],[]],[[],[],[]],[[],[],[]]],[[[],[],[]],[[],[],[]],[[],[],[]]],[[[],[],[]],[[],[],[]],[[],[],[]]],[[[],[],[]],[[],[],[]],[[],[],[]]],[[[],[],[]],[[],[],[]],[[],[],[]]]]

i = 0
for TxEq in TxEqs:
    for TxDiff in TXDIFFSWINGs:
        for TxPre in TXPREs:
            for TxPost in TXPOSTs: 
                line_string = TxDiff+","+TxPre+","+TxPost
                nlinks = 0
                for ff in ff_4:
                    file_ff = open("../results/"+TxEq+"_Rx"+ff+"_Tx"+ff+"_ErrReq5000_BER1e-6_Bathtub.csv", 'r')
                    while file_ff:
                        line  = file_ff.readline()
                        if line_string in line:
#                            print(line.split(",")[4])
                            if int(line.split(",")[4]) == 0:
                                nlinks += 1
                            break
                    file_ff.close()
                print(TXEQs_4[i]+","+line_string,": ",nlinks)
    i += 1
