set mgt_tx_list [eval get_hw_sio_txs]
set mgt_rx_list [eval get_hw_sio_rxs]
set mgt_len [llength $mgt_tx_list]
set mgt_link_list [eval get_hw_sio_links]
##remove_hw_sio_link [get_hw_sio_links]
##set Txs {20,59}
##set Rxs {43,4}

set date 07-25-22
#Modify this variable to correspond to current date before running, Example date: 01-19-22

set path /mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}
set nfspath /nfs/cms/tracktrigger/apollo/CM203/scans/${date}
#Also, be sure to first create corresponding directories to save the scans to (e.g. /mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/01-19-22)

## Links between FPGA (Tx are the ones from FPGA1, Rxs are from FPGA2)
set Txs {}
set Rxs {}

for {set t 20} {$t<60} {incr t} {
    set tstring "X1Y$t/"
    lappend Txs $tstring
}

for {set r 43} {$r>3} {incr r -1} {
    set rstring "X1Y$r/"
    lappend Rxs $rstring                                                                                                                                                          
}

for {set t 4} {$t<16} {incr t} {
    set tstring "X1Y$t/"
    lappend Txs $tstring
}

for {set r 59} {$r>47} {incr r -1} {
    set rstring "X1Y$r/"
    lappend Rxs $rstring
}

## FFs FPGA1 - FPGA2
for {set t 40} {$t<44} {incr t} {
    set tstring "X0Y$t/"
    lappend Txs $tstring
}

for {set r 32} {$r<36} {incr r} {
    set rstring "X0Y$r/"
    lappend Rxs $rstring
}

set i 0
foreach Tx $Txs Rx $Rxs {
    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*2542/0_1*$Tx*->*2542/1_1*$Rx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*2542/0_1*$Tx*->*2542/1_1*$Rx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    set trimTx [string trim $Tx "/"]
    set trimRx [string trim $Rx "/"]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${path}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]    

    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*2542/1_1*$Rx*->*2542/0_1*$Tx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*2542/1_1*$Rx*->*2542/0_1*$Tx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${path}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    ;
}

set TxFF1s {}
set RxFF1s {}

#####
#FPGA1
for {set t 4} {$t<16} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
}

for {set r 20} {$r<32} {incr r} {
    set rstring "X0Y$r/"
    lappend RxFF1s $rstring
}

#loopback ones
for {set t 16} {$t<20} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
    lappend RxFF1s $tstring
}
for {set t 32} {$t<40} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
    lappend RxFF1s $tstring
}
for {set t 48} {$t<60} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
    lappend RxFF1s $tstring
}

puts $TxFF1s

foreach Tx $TxFF1s Rx $RxFF1s {
    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*2542/0_1*$Tx*->*2542/0_1*$Rx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*2542/0_1*$Tx*->*2542/0_1*$Rx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    set trimTx [string trim $Tx "/"]
    set trimRx [string trim $Rx "/"]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${path}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]    

    if {$Tx != $Rx} {
	puts "MGT $i"
	puts [lsearch -all -inline $mgt_link_list "*2542/0_1*$Rx*->*2542/0_1*$Tx*"]
	set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*2542/0_1*$Rx*->*2542/0_1*$Tx*"]] 0 ]]
	set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	incr i 1
	wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	#write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimRx}(xcvu13p_0)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${path}/eyescan_${trimRx}(xcvu13p_0)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${nfspath}/eyescan_${trimRx}(xcvu13p_0)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    }
    ;
}

set TxFF2s {}
set RxFF2s {}

####
#FPGA2
for {set t 36} {$t<40} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
}

for {set r 40} {$r<44} {incr r} {
    set rstring "X0Y$r/"
    lappend RxFF2s $rstring
}

for {set t 4} {$t<32} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
    lappend RxFF2s $tstring
}



for {set t 48} {$t<60} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
    lappend RxFF2s $tstring
}

foreach Tx $TxFF2s Rx $RxFF2s {
    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*2542/1_1*$Tx*->*2542/1_1*$Rx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*2542/1_1*$Tx*->*2542/1_1*$Rx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    set trimTx [string trim $Tx "/"]
    set trimRx [string trim $Rx "/"]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimTx}(xcvu13p_1)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${path}/eyescan_${trimTx}(xcvu13p_1)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_${trimTx}(xcvu13p_1)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]    

    if {$Tx != $Rx} {
	puts "MGT $i"
	puts [lsearch -all -inline $mgt_link_list "*2542/1_1*$Rx*->*2542/1_1*$Tx*"]
	set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*2542/1_1*$Rx*->*2542/1_1*$Tx*"]] 0 ]]
	set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	incr i 1
	wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	#write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${path}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${nfspath}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
    }
    ;
}
