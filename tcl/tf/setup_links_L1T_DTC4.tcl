
if {![info exists hostname]} {
    set hostname apollo3008-1
}
puts "Setting up links from F2 L1T to F1 OT DTC Recv 4 on ${hostname}..."



## L1T on F2 to DTC RECV4 on F1
#unset xil_newLinks
# set_property LOGIC.MGT_ERRCNT_RESET_CTRL 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio -non_blocking [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# set_property LOGIC.MGT_ERRCNT_RESET_CTRL 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# commit_hw_sio -non_blocking [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set xil_newLinks [list]
set xil_newLink [create_hw_sio_link -description {Link 4} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y32/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_132/MGT_X0Y48/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 5} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y33/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_132/MGT_X0Y49/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 6} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y34/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_132/MGT_X0Y50/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 7} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y35/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_132/MGT_X0Y51/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 8} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y36/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_133/MGT_X0Y52/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 9} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y37/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_133/MGT_X0Y53/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 10} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y38/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_133/MGT_X0Y54/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 11} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y39/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_133/MGT_X0Y55/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 12} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y40/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_134/MGT_X0Y56/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 13} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y41/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_134/MGT_X0Y57/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 14} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y42/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_134/MGT_X0Y58/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 15} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y43/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_134/MGT_X0Y59/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {L1T on F2 to DTC Recv 4 on F1} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks
set_property LOGIC.MGT_ERRCNT_RESET_CTRL 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
commit_hw_sio -non_blocking [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
set_property LOGIC.MGT_ERRCNT_RESET_CTRL 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
commit_hw_sio -non_blocking [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]

# set to PRBS-31. This presumes that the 4 daq links got the Link_Group_1 setting.
set_property TX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
set_property RX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
