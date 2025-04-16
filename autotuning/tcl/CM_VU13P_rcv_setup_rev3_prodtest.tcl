################################################################################
# set_property PROBES.FILE {/mnt/scratch/bartz/ThermFiles_all_locking/ku_19.ltx} [get_hw_devices xcku15p_0]
# set_property FULL_PROBES.FILE {/mnt/scratch/bartz/ThermFiles_all_locking/ku_19.ltx} [get_hw_devices xcku15p_0]
# set_property PROGRAM.FILE {/mnt/scratch/bartz/ThermFiles_all_locking/ku_19.bit} [get_hw_devices xcku15p_0]
# program_hw_devices [get_hw_devices xcku15p_0]
# refresh_hw_device [lindex [get_hw_devices xcku15p_0] 0]
# The VU7P has to be programmed and refreshed here because otherwise only half the links (one direction) will be found
#set_property PROBES.FILE {/mnt/scratch/bartz/ThermFiles_all_locking/vu_19.ltx} [get_hw_devices xcvu7p_1]
#set_property FULL_PROBES.FILE {/mnt/scratch/bartz/ThermFiles_all_locking/vu_19.ltx} [get_hw_devices xcvu7p_1]
#set_property PROGRAM.FILE {/mnt/scratch/bartz/ThermFiles_all_locking/vu_19.bit} [get_hw_devices xcvu7p_1]
# program_hw_devices [get_hw_devices xcvu7p_1]
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
#begin fix
source /nfs/cms/tracktrigger/ad683/Cornell_CM_Production_Scripts/autotuning/config_parser.tcl

cfg::parse_file /nfs/cms/tracktrigger/ad683/Cornell_CM_Production_Scripts/autotuning/config_rev3_prodtest.ini

#import strings from config file
set 0_1_mgt_rx $cfg::mgt_parameters(0_1_mgt_rx)
set 0_1_mgt_tx $cfg::mgt_parameters(0_1_mgt_tx)
set 1_1_mgt_rx $cfg::mgt_parameters(1_1_mgt_rx)
set 1_1_mgt_tx $cfg::mgt_parameters(1_1_mgt_tx)
set inter_mgt_rx $cfg::mgt_parameters(inter_mgt_rx)
set inter_mgt_tx $cfg::mgt_parameters(inter_mgt_tx)

#reformat strings as lists
set 0_1_mgt_rx [split $0_1_mgt_rx ","]
set 0_1_mgt_tx [split $0_1_mgt_tx ","]
set 1_1_mgt_rx [split $1_1_mgt_rx ","]
set 1_1_mgt_tx [split $1_1_mgt_tx ","]
set inter_mgt_rx [split $inter_mgt_rx ","]
set inter_mgt_tx [split $inter_mgt_tx ","]

#use the lists of X*Y* id numbers to create corresponding lists of hw_sio_rxs and hw_sio_txs
set 0_1_mgt_len [llength $0_1_mgt_tx]
for {set i 0} {$i<$0_1_mgt_len} {incr i} {
    lappend mgt_rx_list [get_hw_sio_rxs *$cfg::test(0_1_results_RXFPGAid)*[lindex $0_1_mgt_rx $i]/RX]
    lappend mgt_tx_list [get_hw_sio_txs *$cfg::test(0_1_results_TXFPGAid)*[lindex $0_1_mgt_tx $i]/TX]
}
set 1_1_mgt_len [llength $1_1_mgt_tx]
for {set i 0} {$i<$1_1_mgt_len} {incr i} {
    lappend mgt_rx_list [get_hw_sio_rxs *$cfg::test(1_1_results_RXFPGAid)*[lindex $1_1_mgt_rx $i]/RX]
    lappend mgt_tx_list [get_hw_sio_txs *$cfg::test(1_1_results_TXFPGAid)*[lindex $1_1_mgt_tx $i]/TX]
}
set inter_mgt_len [llength $inter_mgt_tx]
for {set i 0} {$i<$inter_mgt_len} {incr i} {
    lappend mgt_rx_list [get_hw_sio_rxs *$cfg::test(inter_results_RXFPGAid)*[lindex $inter_mgt_rx $i]/RX]
    lappend mgt_tx_list [get_hw_sio_txs *$cfg::test(inter_results_TXFPGAid)*[lindex $inter_mgt_tx $i]/TX]
}
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
#hw_sio_link -description {Link 0} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/192.168.38.140:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y8/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/192.168.38.140:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y8/RX] 0] ]
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
set_property PORT.GTRXRESET 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property PORT.GTRXRESET 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property PORT.GTRXRESET 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property PORT.GTRXRESET 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]

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
