set xil_newLinks [list]

foreach a [list 1 2 3 4] b [list 5 6 7 8] c [list a b c d] d [list w x y z] {
    set xil_newLink [create_hw_sio_link -description {Link 0} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT_R/Quad_231/MGT_X1Y28/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT_R/Quad_231/MGT_X1Y28/RX] 0] ]
}
set xil_newLink [create_hw_sio_link -description {Link 0} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y28/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y28/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 1} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y29/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y29/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 2} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y30/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y30/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 3} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y31/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/192.168.38.142:2542/0_1_0_0/IBERT/Quad_231/MGT_X1Y31/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {Link Group 0} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks
