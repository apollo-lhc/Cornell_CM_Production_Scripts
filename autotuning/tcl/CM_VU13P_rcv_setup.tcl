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
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu13p_0] 0]

# Links
set mgt_tx_list [eval get_hw_sio_txs]
set mgt_rx_list [eval get_hw_sio_rxs]
set mgt_len [llength $mgt_tx_list]
remove_hw_sio_link [get_hw_sio_links]
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
