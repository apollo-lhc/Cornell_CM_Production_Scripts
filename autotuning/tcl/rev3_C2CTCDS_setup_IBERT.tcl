################################################################################
#set_property PROGRAM.FILE {/scratch/disk2/rglein/vivado/CM_VU7P_125/CM_VU7P_125.runs/impl_1/example_ibert_ultrascale_gty_0.bit} [get_hw_devices xcvu7p_2]
#refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu13p_0] 0]
#refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu13p_1] 0]

set hw_target [eval get_hw_targets]
#THIS WILL NOT WORK IF MORE THAN ONE HARDWARE TARGET IS PRESENT ON THE MACHINE!

# Links
set mgt_tx_list [eval get_hw_sio_txs]
set mgt_rx_list [eval get_hw_sio_rxs]
set mgt_len [llength $mgt_tx_list]
remove_hw_sio_link [get_hw_sio_links]
## Links between FPGA (Tx are the ones from FPGA1, Rxs are from FPGA2)
set Txs {}
set Rxs {}

set tstring "X0Y3/"
lappend Txs $tstring
set rstring "X0Y0/"
lappend Rxs $rstring
set tstring "X1Y3/"
lappend Txs $tstring
set rstring "X1Y3/"
lappend Rxs $rstring

set i 0
foreach Tx $Txs Rx $Rxs {
    puts "MGT $i" 
    puts [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Tx*] "$hw_target/0_1*"] 
    puts [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Rx*] "$hw_target/1_1*"]
    set xil_newLink [create_hw_sio_link -description "MGT $i" [lindex [get_hw_sio_txs [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Tx*] "$hw_target/0_1*"]] 0] [lindex [get_hw_sio_rxs [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Rx*] "$hw_target/1_1*"]] 0]]
    lappend xil_newLinks $xil_newLink
    
    incr i 1
    set xil_newLink1 [create_hw_sio_link -description "MGT $i" [lindex [get_hw_sio_txs [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Rx*] "$hw_target/1_1*"]] 0] [lindex [get_hw_sio_rxs [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Tx*] "$hw_target/0_1*"]] 0]]
    lappend xil_newLinks $xil_newLink1 
    incr i 1
    ;
}

set TxFF1s {}
set RxFF1s {}

#####
#FPGA1
set tstring "X0Y0/"
lappend TxFF1s $tstring
lappend RxFF1s $tstring
set tstring "X0Y2/"
lappend TxFF1s $tstring
lappend RxFF1s $tstring
set tstring "X1Y0/"
lappend TxFF1s $tstring
lappend RxFF1s $tstring
set tstring "X1Y1/"
lappend TxFF1s $tstring
lappend RxFF1s $tstring

puts $TxFF1s

foreach Tx $TxFF1s Rx $RxFF1s {
    puts "MGT $i"
    puts [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Tx*] "$hw_target/0_1*"]
    puts [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Rx*] "$hw_target/0_1*"]
    set xil_newLink [create_hw_sio_link -description "MGT $i" [lindex [get_hw_sio_txs [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Tx*] "$hw_target/0_1*"]] 0] [lindex [get_hw_sio_rxs [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Rx*] "$hw_target/0_1*"]] 0]]
    lappend xil_newLinks $xil_newLink
    if {$Tx != $Rx} {
	incr i 1
	set xil_newLink1 [create_hw_sio_link -description "MGT $i" [lindex [get_hw_sio_txs [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Rx*] "$hw_target/0_1*"]] 0] [lindex [get_hw_sio_rxs [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Tx*] "$hw_target/0_1*"]] 0]]
	lappend xil_newLinks $xil_newLink1
    }
    incr i 1
    ;
}


set TxFF2s {}
set RxFF2s {}

####
#FPGA2
set tstring "X1Y0"
lappend TxFF2s $tstring
lappend RxFF2s $tstring
set tstring "X1Y1"
lappend TxFF2s $tstring
lappend RxFF2s $tstring

foreach Tx $TxFF2s Rx $RxFF2s {
    puts "MGT $i"
    puts [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Tx*] "$hw_target/1_1*"]
    puts [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Rx*] "$hw_target/1_1*"]
    set xil_newLink [create_hw_sio_link -description "MGT $i" [lindex [get_hw_sio_txs [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Tx*] "$hw_target/1_1*"]] 0] [lindex [get_hw_sio_rxs [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Rx*] "$hw_target/1_1*"]] 0]]
    lappend xil_newLinks $xil_newLink
    if {$Tx != $Rx} {
	incr i 1
	set xil_newLink1 [create_hw_sio_link -description "MGT $i" [lindex [get_hw_sio_txs [lsearch -all -inline [lsearch -all -inline $mgt_tx_list *$Rx*] "$hw_target/1_1*"]] 0] [lindex [get_hw_sio_rxs [lsearch -all -inline [lsearch -all -inline $mgt_rx_list *$Tx*] "$hw_target/1_1*"]] 0]]
	lappend xil_newLinks $xil_newLink1
    }
    incr i 1
    ;
}


#puts $mgt_tx_list

#foreach Tx $Txs Rx $Rxs { 
#00001631afcb01/0_1 00001631afcb01/1_1#
#    puts [lsearch -inline $mgt_tx_list $Tx*]
#}
# for {set i 0} {$i<$mgt_len} {incr i} {
#     set substring "6-31"
#     if {[string first $substring $variable] != -1} {
#     set xil_newLink [create_hw_sio_link -description "MGT $i" [lindex $mgt_tx_list $i] [lindex $mgt_rx_list $i] ]
#     lappend xil_newLinks $xil_newLink
# }
set xil_newLinkGroup [create_hw_sio_linkgroup -description {Link_Group_0} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks
eval get_hw_sio_links

################################################################################
# Transceivers
set_property TXDIFFSWING {530 mV (00101)} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property TXPOST {0.00 dB (00000)}  [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property TXPRE {0.01 dB (00000)} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property RXDFEENABLED 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]

################################################################################
# Reset channels
set_property LOGIC.TX_RESET_DATAPATH 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property LOGIC.TX_RESET_DATAPATH 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property LOGIC.RX_RESET_DATAPATH 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property LOGIC.RX_RESET_DATAPATH 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]

################################################################################
# PRBS Pattern
set_property TX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property RX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]

################################################################################
# TX Inhibit
#set_property PORT.TXINHIBIT 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
#commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
