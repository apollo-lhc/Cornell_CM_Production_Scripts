
if {[info exists ::hostname] && $::hostname ne ""} {
    set hostname $::hostname
} elseif {![info exists hostname] || $hostname eq ""} {
    set hostname apollo3008-1
}
puts "Setting up DAQ loopback links on ${hostname}..."

### SETUP DAQ LOOP-BACK
set xil_newLinks [list]
set xil_newLink [create_hw_sio_link -description {Link 0} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y44/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y44/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 1} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y45/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y45/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 2} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y46/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y46/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 3} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y47/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y47/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {DAQ Link F2} [get_hw_sio_links $xil_newLinks]]

# set to PRBS-31
set_property TX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property RX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
