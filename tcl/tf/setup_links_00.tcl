#
#source program_fpgas_2.tcl
#puts [get_hw_sio_rxs]
#puts [get_hw_devices]

# setup links below here
set xil_newLinks [list]
set xil_newLink [create_hw_sio_link -description {Link 0} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y4/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y4/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 1} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y5/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y5/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 2} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y6/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y6/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 3} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y7/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y7/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 4} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y4/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y4/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 5} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y5/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y5/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 6} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y6/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y6/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 7} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_121/MGT_X0Y7/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_121/MGT_X0Y7/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 8} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y8/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y8/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 9} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y9/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y9/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 10} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y10/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y10/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 11} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y11/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y11/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 12} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y8/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y8/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 13} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y9/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y9/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 14} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y10/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y10/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 15} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_122/MGT_X0Y11/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_122/MGT_X0Y11/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 16} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y12/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y12/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 17} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y13/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y13/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 18} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y14/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y14/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 19} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y15/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y15/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 20} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y12/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y12/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 21} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y13/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y13/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 22} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y14/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y14/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 23} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_123/MGT_X0Y15/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_123/MGT_X0Y15/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {Link Group 0} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks
set xil_newLinks [list]
set xil_newLink [create_hw_sio_link -description {Link 24} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y20/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y20/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 25} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y21/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y21/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 26} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y22/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y22/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 27} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y23/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y23/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 28} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y20/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y20/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 29} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y21/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y21/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 30} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y22/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y22/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 31} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_125/MGT_X0Y23/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_125/MGT_X0Y23/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 32} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y24/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y24/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 33} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y25/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y25/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 34} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y26/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y26/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 35} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y27/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y27/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 36} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y24/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y24/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 37} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y25/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y25/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 38} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y26/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y26/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 39} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_126/MGT_X0Y27/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_126/MGT_X0Y27/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 40} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y28/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y28/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 41} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y29/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y29/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 42} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y30/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y30/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 43} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y31/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y31/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 44} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y28/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y28/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 45} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y29/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y29/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 46} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y30/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y30/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 47} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_127/MGT_X0Y31/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_127/MGT_X0Y31/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {Link Group 1} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks
set xil_newLinks [list]
set xil_newLink [create_hw_sio_link -description {Link 48} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y16/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y16/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 49} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y17/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y17/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 50} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y18/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y18/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 51} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y19/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y19/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 52} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y16/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y16/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 53} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y17/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y17/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 54} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y18/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y18/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 55} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_124/MGT_X0Y19/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_124/MGT_X0Y19/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {Link Group 2} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks
set xil_newLinks [list]
set xil_newLink [create_hw_sio_link -description {Link 56} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y44/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y44/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 57} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y45/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y45/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 58} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y46/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y46/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 59} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y47/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y47/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 60} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y44/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y44/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 61} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y45/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y45/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 62} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y46/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y46/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLink [create_hw_sio_link -description {Link 63} [lindex [get_hw_sio_txs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/1_1_0_0/IBERT/Quad_131/MGT_X0Y47/TX] 0] [lindex [get_hw_sio_rxs localhost:3121/xilinx_tcf/Xilinx/apollo3010-1:2542/0_1_0_0/IBERT/Quad_131/MGT_X0Y47/RX] 0] ]
lappend xil_newLinks $xil_newLink
set xil_newLinkGroup [create_hw_sio_linkgroup -description {Link Group 3} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks

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
# PRBS Pattern -- Link groups 0 and 1
set_property TX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
set_property RX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_0}]]
# PRBS Pattern -- Link groups 0 and 1
set_property TX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
set_property RX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {Link_Group_1}]]

