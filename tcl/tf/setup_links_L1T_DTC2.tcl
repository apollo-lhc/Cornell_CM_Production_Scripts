
if {[info exists ::hostname] && $::hostname ne ""} {
    set hostname $::hostname
} elseif {![info exists hostname] || $hostname eq ""} {
    set hostname apollo3008-1
}
puts "Setting up links from F2 L1T to F1 OT DTC Recv 2 on ${hostname}..."


set xil_newLinks [list]
set xil_newLink [create_hw_sio_link -description {Link 16} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y32/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y20/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 17} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y33/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y21/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 18} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y34/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y22/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 19} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_128/MGT_X0Y35/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y23/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 20} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y36/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y24/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 21} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y37/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y25/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 22} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y38/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y26/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 23} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_129/MGT_X0Y39/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y27/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 24} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y40/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y28/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 25} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y41/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y29/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 26} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y42/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y30/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 27} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/1_1_0_0/IBERT/Quad_130/MGT_X0Y43/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/${hostname}:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y31/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {L1T on F2 to DTC Recv 1 on F1} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks
