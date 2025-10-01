set mgt_tx_list [eval get_hw_sio_txs]
set mgt_rx_list [eval get_hw_sio_rxs]
set mgt_len [llength $mgt_tx_list]
set mgt_link_list [eval get_hw_sio_links]
##remove_hw_sio_link [get_hw_sio_links]
##set Txs {20,59}
##set Rxs {43,4}

set systemTime [clock seconds]
set date [clock format $systemTime -format %m-%d-%y]
#This modifies this variable to correspond to current date before running, Example date: 01-19-22

variable myLocation [file normalize [info script]]
set dir [file dirname $myLocation]
if {!([info exists CM])} {
    puts "Error: Command Module id not defined. Before running this script, be sure to first run: set CM <id of CM being tested>"
    puts "Example CM id: CM3002"
}
set path [file join $dir "../../scans/${CM}/${date}"]
set nfspath /nfs/cms/tracktrigger/apollo/${CM}/scans/${date}
#set path /nfs/cms/tracktrigger/ad683/Cornell_CM_Production_Scripts/scans/CM3002/${date}
#set nfspath /nfs/cms/tracktrigger/apollo/CM3002/scans/${date}
file mkdir $path
file mkdir $nfspath
#file attributes /nfs/cms/tracktrigger/apollo/${CM} -permissions rwxrwxr-x
#file attributes [file join $dir "../../scans/${CM}/${date}"]
#file attributes $path -permissions rwxrwxr-x
#file attributes $nfspath -permissions rwxrwxr-x
exec chmod -R g+w [file join $dir "../../scans/${CM}"]
exec chmod -R g+w /nfs/cms/tracktrigger/apollo/${CM}
#Also, be sure to first modify these lines to save the scans how you would like (e.g. /mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/01-19-22)

set Quad_dict {"X0Y56" "Quad_134_" "X0Y57" "Quad_134_" "X0Y58" "Quad_134_" "X0Y59" "Quad_134_"
    "X0Y52" "Quad_133_" "X0Y53" "Quad_133_" "X0Y54" "Quad_133_" "X0Y55" "Quad_133_"
    "X0Y48" "Quad_132_" "X0Y49" "Quad_132_" "X0Y50" "Quad_132_" "X0Y51" "Quad_132_"
    "X0Y44" "Quad_131_" "X0Y45" "Quad_131_" "X0Y46" "Quad_131_" "X0Y47" "Quad_131_"
    "X0Y40" "Quad_130_" "X0Y41" "Quad_130_" "X0Y42" "Quad_130_" "X0Y43" "Quad_130_"
    "X0Y36" "Quad_129_" "X0Y37" "Quad_129_" "X0Y38" "Quad_129_" "X0Y39" "Quad_129_"
    "X0Y32" "Quad_128_" "X0Y33" "Quad_128_" "X0Y34" "Quad_128_" "X0Y35" "Quad_128_"
    "X0Y28" "Quad_127_" "X0Y29" "Quad_127_" "X0Y30" "Quad_127_" "X0Y31" "Quad_127_"
    "X0Y24" "Quad_126_" "X0Y25" "Quad_126_" "X0Y26" "Quad_126_" "X0Y27" "Quad_126_"
    "X0Y20" "Quad_125_" "X0Y21" "Quad_125_" "X0Y22" "Quad_125_" "X0Y23" "Quad_125_"
    "X0Y16" "Quad_124_" "X0Y17" "Quad_124_" "X0Y18" "Quad_124_" "X0Y19" "Quad_124_"
    "X0Y12" "Quad_123_" "X0Y13" "Quad_123_" "X0Y14" "Quad_123_" "X0Y15" "Quad_123_"
    "X0Y8" "Quad_122_" "X0Y9" "Quad_122_" "X0Y10" "Quad_122_" "X0Y11" "Quad_122_"
    "X0Y4" "Quad_121_" "X0Y5" "Quad_121_" "X0Y6" "Quad_121_" "X0Y7" "Quad_121_"
    "X1Y56" "Quad_234_" "X1Y57" "Quad_234_" "X1Y58" "Quad_234_" "X1Y59" "Quad_234_"
    "X1Y52" "Quad_233_" "X1Y53" "Quad_233_" "X1Y54" "Quad_233_" "X1Y55" "Quad_233_"
    "X1Y48" "Quad_232_" "X1Y49" "Quad_232_" "X1Y50" "Quad_232_" "X1Y51" "Quad_232_"
    "X1Y44" "Quad_231_" "X1Y45" "Quad_231_" "X1Y46" "Quad_231_" "X1Y47" "Quad_231_"
    "X1Y40" "Quad_230_" "X1Y41" "Quad_230_" "X1Y42" "Quad_230_" "X1Y43" "Quad_230_"
    "X1Y36" "Quad_229_" "X1Y37" "Quad_229_" "X1Y38" "Quad_229_" "X1Y39" "Quad_229_"
    "X1Y32" "Quad_228_" "X1Y33" "Quad_228_" "X1Y34" "Quad_228_" "X1Y35" "Quad_228_"
    "X1Y28" "Quad_227_" "X1Y29" "Quad_227_" "X1Y30" "Quad_227_" "X1Y31" "Quad_227_"
    "X1Y24" "Quad_226_" "X1Y25" "Quad_226_" "X1Y26" "Quad_226_" "X1Y27" "Quad_226_"
    "X1Y20" "Quad_225_" "X1Y21" "Quad_225_" "X1Y22" "Quad_225_" "X1Y23" "Quad_225_"
    "X1Y16" "Quad_224_" "X1Y17" "Quad_224_" "X1Y18" "Quad_224_" "X1Y19" "Quad_224_"
    "X1Y12" "Quad_223_" "X1Y13" "Quad_223_" "X1Y14" "Quad_223_" "X1Y15" "Quad_223_"
    "X1Y8" "Quad_222_" "X1Y9" "Quad_222_" "X1Y10" "Quad_222_" "X1Y11" "Quad_222_"
    "X1Y4" "Quad_221_" "X1Y5" "Quad_221_" "X1Y6" "Quad_221_" "X1Y7" "Quad_221_"}
set FF_FPGA_dict {"xcvu13p_0" "_F1" "xcvu13p_1" "_F2"}
set FF_dict {"X0Y56" "_4_" "X0Y57" "_4_" "X0Y58" "_4_" "X0Y59" "_4_"
    "X0Y52" "_4_" "X0Y53" "_4_" "X0Y54" "_4_" "X0Y55" "_4_"
    "X0Y48" "_4_" "X0Y49" "_4_" "X0Y50" "_4_" "X0Y51" "_4_"
    "X0Y44" "_6_" "X0Y45" "_6_" "X0Y46" "_6_" "X0Y47" "_6_"
    "X0Y40" "_3_" "X0Y41" "_3_" "X0Y42" "_3_" "X0Y43" "_3_"
    "X0Y36" "_3_" "X0Y37" "_3_" "X0Y38" "_3_" "X0Y39" "_3_"
    "X0Y32" "_3_" "X0Y33" "_3_" "X0Y34" "_3_" "X0Y35" "_3_"
    "X0Y28" "_2_" "X0Y29" "_2_" "X0Y30" "_2_" "X0Y31" "_2_"
    "X0Y24" "_2_" "X0Y25" "_2_" "X0Y26" "_2_" "X0Y27" "_2_"
    "X0Y20" "_2_" "X0Y21" "_2_" "X0Y22" "_2_" "X0Y23" "_2_"
    "X0Y16" "_5_" "X0Y17" "_5_" "X0Y18" "_5_" "X0Y19" "_5_"
    "X0Y12" "_1_" "X0Y13" "_1_" "X0Y14" "_1_" "X0Y15" "_1_"
    "X0Y8" "_1_" "X0Y9" "_1_" "X0Y10" "_1_" "X0Y11" "_1_"
    "X0Y4" "_1_" "X0Y5" "_1_" "X0Y6" "_1_" "X0Y7" "_1_"}

## Links between FPGA (Tx are the ones from FPGA1, Rxs are from FPGA2)
set Txs {}
set Rxs {}

for {set t 20} {$t<44} {incr t} {
    set tstring "X1Y$t/"
    lappend Txs $tstring
}
for {set r 43} {$r>19} {incr r -1} {
    set rstring "X1Y$r/"
    lappend Rxs $rstring
}

for {set t 4} {$t<18} {incr t} {
    set tstring "X1Y$t/"
    lappend Txs $tstring
}
for {set r 59} {$r>45} {incr r -1} {
    set rstring "X1Y$r/"
    lappend Rxs $rstring
}

for {set t 44} {$t<60} {incr t} {
    set tstring "X1Y$t/"
    lappend Txs $tstring
}
for {set r 19} {$r>3} {incr r -1} {
    set rstring "X1Y$r/"
    lappend Rxs $rstring
}
#ADD THESE BACK IN WHEN CAN GET QUAD 120 AND 220 VISIBLE IN VIVADO
#set tstring "X0Y3/"
#lappend Txs $tstring
#set rstring "X0Y0/"
#lappend Rxs $rstring
#set tstring "X1Y3/"
#lappend Txs $tstring
#set rstring "X1Y3/"
#lappend Rxs $rstring

set i 0
foreach Tx $Txs Rx $Rxs {
    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*00001631afcb01/0_1*$Tx*->*00001631afcb01/1_1*$Rx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*00001631afcb01/0_1*$Tx*->*00001631afcb01/1_1*$Rx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    set trimTx [string trim $Tx "/"]
    set trimRx [string trim $Rx "/"]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
    set QuadTx [string map $Quad_dict $trimTx]
    set QuadRx [string map $Quad_dict $trimRx]
    write_hw_sio_scan -force "${path}/eyescan_F1_${QuadTx}${trimTx}_to_F2_${QuadRx}${trimRx}" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_F1_${QuadTx}${trimTx}_to_F2_${QuadRx}${trimRx}" [get_hw_sio_scans $xil_newScan]    

    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*00001631afcb01/1_1*$Rx*->*00001631afcb01/0_1*$Tx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*00001631afcb01/1_1*$Rx*->*00001631afcb01/0_1*$Tx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${path}/eyescan_F2_${QuadRx}${trimRx}_to_F1_${QuadTx}${trimTx}" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_F2_${QuadRx}${trimRx}_to_F1_${QuadTx}${trimTx}" [get_hw_sio_scans $xil_newScan]
    ;
}

set TxFF1s {}
set RxFF1s {}

#####
#FPGA1
for {set t 16} {$t<20} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
}

for {set r 44} {$r<48} {incr r} {
    set rstring "X0Y$r/"
    lappend RxFF1s $rstring
}

#loopback ones
for {set t 4} {$t<16} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
    lappend RxFF1s $tstring
}
for {set t 20} {$t<32} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
    lappend RxFF1s $tstring
}
for {set t 32} {$t<44} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
    lappend RxFF1s $tstring
}
for {set t 48} {$t<60} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF1s $tstring
    lappend RxFF1s $tstring
}
#ADD THESE BACK IN WHEN CAN GET QUAD 120 AND 220 VISIBLE IN VIVADO
#set tstring "X0Y0/"
#lappend TxFF1s $tstring
#lappend RxFF1s $tstring
#set tstring "X0Y2/"
#lappend TxFF1s $tstring
#lappend RxFF1s $tstring
#set tstring "X1Y0/"
#lappend TxFF1s $tstring
#lappend RxFF1s $tstring
#set tstring "X1Y1/"
#lappend TxFF1s $tstring
#lappend RxFF1s $tstring

puts $TxFF1s

foreach Tx $TxFF1s Rx $RxFF1s {
    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*00001631afcb01/0_1*$Tx*->*00001631afcb01/0_1*$Rx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*00001631afcb01/0_1*$Tx*->*00001631afcb01/0_1*$Rx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    set trimTx [string trim $Tx "/"]
    set trimRx [string trim $Rx "/"]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimTx}(xcvu13p_0)_to_${trimRx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
    set FFTx [string map $FF_dict $trimTx]
    set FFRx [string map $FF_dict $trimRx]
    set QuadTx [string map $Quad_dict $trimTx]
    set QuadRx [string map $Quad_dict $trimRx]
    write_hw_sio_scan -force "${path}/eyescan_F1${FFTx}${QuadTx}${trimTx}_to_F1${FFRx}${QuadRx}${trimRx}" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_F1${FFTx}${QuadTx}${trimTx}_to_F1${FFRx}${QuadRx}${trimRx}" [get_hw_sio_scans $xil_newScan]

    if {$Tx != $Rx} {
	puts "MGT $i"
	puts [lsearch -all -inline $mgt_link_list "*00001631afcb01/0_1*$Rx*->*00001631afcb01/0_1*$Tx*"]
	set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*00001631afcb01/0_1*$Rx*->*00001631afcb01/0_1*$Tx*"]] 0 ]]
	set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	incr i 1
	wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	#write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimRx}(xcvu13p_0)_to_${trimTx}(xcvu13p_0)" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${path}/eyescan_F1${FFRx}${QuadRx}${trimRx}_to_F1${FFTx}${QuadTx}${trimTx}" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${nfspath}/eyescan_F1${FFRx}${QuadRx}${trimRx}_to_F1${FFTx}${QuadTx}${trimTx}" [get_hw_sio_scans $xil_newScan]
    }
    ;
}

set TxFF2s {}
set RxFF2s {}

####
#FPGA2
for {set t 16} {$t<20} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
}

for {set r 44} {$r<48} {incr r} {
    set rstring "X0Y$r/"
    lappend RxFF2s $rstring
}

#loopback ones
for {set t 4} {$t<16} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
    lappend RxFF2s $tstring
}
for {set t 20} {$t<32} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
    lappend RxFF2s $tstring
}
for {set t 32} {$t<44} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
    lappend RxFF2s $tstring
}
for {set t 48} {$t<60} {incr t} {
    set tstring "X0Y$t/"
    lappend TxFF2s $tstring
    lappend RxFF2s $tstring
}
#ADD THESE BACK IN WHEN CAN GET QUAD 120 AND 220 VISIBLE IN VIVADO
#set tstring "X1Y0"
#lappend TxFF1s $tstring
#lappend RxFF1s $tstring
#set tstring "X1Y1"
#lappend TxFF1s $tstring
#lappend RxFF1s $tstring

foreach Tx $TxFF2s Rx $RxFF2s {
    puts "MGT $i"
    puts [lsearch -all -inline $mgt_link_list "*00001631afcb01/1_1*$Tx*->*00001631afcb01/1_1*$Rx*"]
    set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*00001631afcb01/1_1*$Tx*->*00001631afcb01/1_1*$Rx*"]] 0 ]]
    set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
    run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    incr i 1
    wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
    set trimTx [string trim $Tx "/"]
    set trimRx [string trim $Rx "/"]
    #write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimTx}(xcvu13p_1)_to_${trimRx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
    set FFTx [string map $FF_dict $trimTx]
    set FFRx [string map $FF_dict $trimRx]
    set QuadTx [string map $Quad_dict $trimTx]
    set QuadRx [string map $Quad_dict $trimRx]
    write_hw_sio_scan -force "${path}/eyescan_F2${FFTx}${QuadTx}${trimTx}_to_F2${FFRx}${QuadRx}${trimRx}" [get_hw_sio_scans $xil_newScan]
    write_hw_sio_scan -force "${nfspath}/eyescan_F2${FFTx}${QuadTx}${trimTx}_to_F2${FFRx}${QuadRx}${trimRx}" [get_hw_sio_scans $xil_newScan]

    if {$Tx != $Rx} {
	puts "MGT $i"
	puts [lsearch -all -inline $mgt_link_list "*00001631afcb01/1_1*$Rx*->*00001631afcb01/1_1*$Tx*"]
	set xil_newScan [create_hw_sio_scan -description "Scan $i" 2d_full_eye  [lindex [get_hw_sio_links [lsearch -all -inline $mgt_link_list "*00001631afcb01/1_1*$Rx*->*00001631afcb01/1_1*$Tx*"]] 0 ]]
	set_property HORIZONTAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	set_property VERTICAL_INCREMENT {1} [get_hw_sio_scans $xil_newScan]
	run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	incr i 1
	wait_on_hw_sio_scan [get_hw_sio_scans $xil_newScan]
	#write_hw_sio_scan -force "/mnt/scratch/ad683/Cornell_CM_Production_Scripts/scans/CM203/${date}/eyescan_${trimRx}(xcvu13p_1)_to_${trimTx}(xcvu13p_1)" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${path}/eyescan_F2${FFRx}${QuadRx}${trimRx}_to_F2${FFTx}${QuadTx}${trimTx}" [get_hw_sio_scans $xil_newScan]
        write_hw_sio_scan -force "${nfspath}/eyescan_F2${FFRx}${QuadRx}${trimRx}_to_F2${FFTx}${QuadTx}${trimTx}" [get_hw_sio_scans $xil_newScan]
    }
    ;
}
