################################################################################
#set_property PROBES.FILE {/scratch/disk2/rglein/vivado/CM_VU7P_125/CM_VU7P_125.runs/impl_1/example_ibert_ultrascale_gty_0.ltx} [get_hw_devices xcvu7p_2]
#set_property FULL_PROBES.FILE {/scratch/disk2/rglein/vivado/CM_VU7P_125/CM_VU7P_125.runs/impl_1/example_ibert_ultrascale_gty_0.ltx} [get_hw_devices xcvu7p_2]
#set_property PROGRAM.FILE {/scratch/disk2/rglein/vivado/CM_VU7P_125/CM_VU7P_125.runs/impl_1/example_ibert_ultrascale_gty_0.bit} [get_hw_devices xcvu7p_2]
#program_hw_devices [get_hw_devices xcvu7p_2]
#refresh_hw_device [lindex [get_hw_devices xcvu13p_0] 0]
#set_property PROBES.FILE {} [get_hw_devices xcvu13p_0]
#set_property FULL_PROBES.FILE {} [get_hw_devices xcvu13p_0]
#set_property PROGRAM.FILE {/nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev2_p1_VU13p-1-SM_7s_IBERT_lpGBT_v1_25GLHS.bit} [get_hw_devices xcvu13p_0]
#program_hw_devices [get_hw_devices xcvu13p_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu13p_0] 0]
#set_property PROBES.FILE {} [get_hw_devices xcvu13p_1]
#set_property FULL_PROBES.FILE {} [get_hw_devices xcvu13p_1]
#set_property PROGRAM.FILE {/nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev2_p2_VU13p-1-SM_7s_IBERT_lpGBT_v1_25GLHS.bit} [get_hw_devices xcvu13p_1]
#program_hw_devices [get_hw_devices xcvu13p_1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu13p_1] 0]

#refresh_hw_device [lindex [get_hw_devices xcku15p_1] 0]

#begin fix
set script [info script]
set dir [file dirname $script]
source $dir/../config_parser.tcl
cfg::parse_file	$dir/../config_linkcheck.ini

#import strings from config file
set 0_1_mgt_rx $cfg::mgt_parameters(0_1_mgt_rx)
set 0_1_mgt_tx $cfg::mgt_parameters(0_1_mgt_tx)
set 1_1_mgt_rx $cfg::mgt_parameters(1_1_mgt_rx)
set 1_1_mgt_tx $cfg::mgt_parameters(1_1_mgt_tx)
#set inter_mgt_rx $cfg::mgt_parameters(inter_mgt_rx)
#set inter_mgt_tx $cfg::mgt_parameters(inter_mgt_tx)
set 0to1_mgt_rx $cfg::mgt_parameters(0to1_mgt_rx)
set 0to1_mgt_tx $cfg::mgt_parameters(0to1_mgt_tx)
set 1to0_mgt_rx $cfg::mgt_parameters(1to0_mgt_rx)
set 1to0_mgt_tx $cfg::mgt_parameters(1to0_mgt_tx)

#reformat strings as lists
set 0_1_mgt_rx [split $0_1_mgt_rx ","]
set 0_1_mgt_tx [split $0_1_mgt_tx ","]
set 1_1_mgt_rx [split $1_1_mgt_rx ","]
set 1_1_mgt_tx [split $1_1_mgt_tx ","]
#set inter_mgt_rx [split $inter_mgt_rx ","]
#set inter_mgt_tx [split $inter_mgt_tx ","]
set 0to1_mgt_rx [split $0to1_mgt_rx ","]
set 0to1_mgt_tx [split $0to1_mgt_tx ","]
set 1to0_mgt_rx [split $1to0_mgt_rx ","]
set 1to0_mgt_tx [split $1to0_mgt_tx ","]

#puts "values of mgt_rx: $mgt_rx"
#puts "values of mgt_tx: $mgt_tx"

#use the lists of X*Y* id numbers to create corresponding lists of hw_sio_rxs and hw_sio_txs
set 0_1_mgt_len [llength $0_1_mgt_tx]
for {set i 0} {$i<$0_1_mgt_len} {incr i} {
    lappend mgt_rx_list	[get_hw_sio_rxs *$cfg::test(0_1_results_RXFPGAid)*[lindex $0_1_mgt_rx $i]/RX]
    lappend mgt_tx_list	[get_hw_sio_txs *$cfg::test(0_1_results_TXFPGAid)*[lindex $0_1_mgt_tx $i]/TX]
}
set 1_1_mgt_len [llength $1_1_mgt_tx]
for {set i 0} {$i<$1_1_mgt_len} {incr i} {
    lappend mgt_rx_list [get_hw_sio_rxs *$cfg::test(1_1_results_RXFPGAid)*[lindex $1_1_mgt_rx $i]/RX]
    lappend mgt_tx_list [get_hw_sio_txs *$cfg::test(1_1_results_TXFPGAid)*[lindex $1_1_mgt_tx $i]/TX]
}
#set inter_mgt_len [llength $inter_mgt_tx]
#for {set i 0} {$i<$inter_mgt_len} {incr i} {
#    lappend mgt_rx_list [get_hw_sio_rxs *$cfg::test(inter_results_RXFPGAid)*[lindex $inter_mgt_rx $i]/RX]
#    lappend mgt_tx_list [get_hw_sio_txs *$cfg::test(inter_results_TXFPGAid)*[lindex $inter_mgt_tx $i]/TX]
#}
set 0to1_mgt_len [llength $0to1_mgt_tx]
for {set i 0} {$i<$0to1_mgt_len} {incr i} {
    lappend mgt_rx_list [get_hw_sio_rxs *$cfg::test(0to1_results_RXFPGAid)*[lindex $0to1_mgt_rx $i]/RX]
    lappend mgt_tx_list [get_hw_sio_txs *$cfg::test(0to1_results_TXFPGAid)*[lindex $0to1_mgt_tx $i]/TX]
}
set 1to0_mgt_len [llength $1to0_mgt_tx]
for {set i 0} {$i<$1to0_mgt_len} {incr i} {
    lappend mgt_rx_list [get_hw_sio_rxs *$cfg::test(1to0_results_RXFPGAid)*[lindex $1to0_mgt_rx $i]/RX]
    lappend mgt_tx_list [get_hw_sio_txs *$cfg::test(1to0_results_TXFPGAid)*[lindex $1to0_mgt_tx $i]/TX]
}
#puts "values of mgt_rx_list: $mgt_rx_list"
#puts "values of mgt_tx_list: $mgt_tx_list"
#end fix

# Links
#set mgt_tx_list [eval get_hw_sio_txs]
#set mgt_rx_list [eval get_hw_sio_rxs]
set mgt_len [llength $mgt_tx_list]
#remove_hw_sio_link [get_hw_sio_links]
for {set i 0} {$i<$mgt_len} {incr i} {
    set xil_newLink [create_hw_sio_link -description "MGT $i" [lindex $mgt_tx_list $i] [lindex $mgt_rx_list $i] ]
    lappend xil_newLinks $xil_newLink
}
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
# set_property PORT.GTRXRESET 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# set_property PORT.GTRXRESET 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# set_property PORT.GTRXRESET 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# set_property PORT.GTRXRESET 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]

set_property LOGIC.TX_RESET_DATAPATH 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property LOGIC.TX_RESET_DATAPATH 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property LOGIC.RX_RESET_DATAPATH 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property LOGIC.RX_RESET_DATAPATH 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]

# set_property LOGIC.MGT_ERRCNT_RESET_CTRL 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# set_property LOGIC.MGT_ERRCNT_RESET_CTRL 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]


################################################################################
# PRBS Pattern
set_property TX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
#set_property TX_PATTERN {Slow Clk} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property RX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
#set_property RX_PATTERN {Slow Clk} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]

################################################################################
# TX Inhibit
#set_property PORT.TXINHIBIT 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
#commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
