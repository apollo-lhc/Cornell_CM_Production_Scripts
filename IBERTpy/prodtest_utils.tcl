#! /usr/bin/tclsh

# two functions defined:
# load_and_run CM3NNN --> for regular links, inter-FPGA and Firefly
# load_and_run_sm CM3NNN --> for SM links (TCDS and C2C)

# script to be run in vivado tcl console to scan and run on a given CM
# usage: source prodtest_utils.tcl; load_and_run CM3006. Source command
# only needs to be run once per vivado session.
proc load_and_run {CM} {
    puts "Loading and running on CM ${CM}"
    # make sure CM has the form CM3 followed by exactly three digits (CM3NNN)
    if {![regexp {^CM3\d{3}$} $CM]} {
        puts "Error: CM name ${CM} is not of the form CM3NNN where NNN are digits"
        return
    }
    # first program the FPGAs.
    # F1
    #set file_ltx_f1 "/nfs/cms/tracktrigger/wittich/Cornell_CM_Rev3_HW/Vivado/proj/prod_test/prod_test.runs/impl_1/top.ltx"
    set file_bit_f1 "/nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p1_VU13p-1-SM_USP_LHS_25G_DC_on_12ch_site_25GRHS.bit"
    #set_property PROBES.FILE {$file_ltx_f1} [get_hw_devices xcvu13p_0]
    #set_property FULL_PROBES.FILE {$file_ltx_f1} [get_hw_devices xcvu13p_0]
    set_property PROGRAM.FILE {$file_bit_f1} [get_hw_devices xcvu13p_0]
    program_hw_devices [get_hw_devices xcvu13p_0]


    # F2
    #set file_ltx_f2 $file_ltx_f1
    set file_bit_f2 "/nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p2_VU13p-1-SM_USP_LHS_25G_DC_on_12ch_site_25GRHS.bit"
    #set_property PROBES.FILE {$file_ltx_f2} [get_hw_devices xcvu13p_1]
    #set_property FULL_PROBES.FILE {$file_ltx_f2} [get_hw_devices xcvu13p_1]
    set_property PROGRAM.FILE {$file_bit_f2} [get_hw_devices xcvu13p_1]
    program_hw_devices [get_hw_devices xcvu13p_1]

    refresh_hw_device [lindex [get_hw_devices xcvu13p_0] 0]
    refresh_hw_device [lindex [get_hw_devices xcvu13p_1] 0]

    # set up IBERT
    source /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_prodtest_setup_IBERT.tcl

    # run Eye scans
    source /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_prodtest_eyescan.tcl


proc load_and_run_sm {CM} {
    puts "Loading and running on CM ${CM} for SM links"
    # make sure CM has the form CM3 followed by exactly three digits (CM3NNN)
    if {![regexp {^CM3\d{3}$} $CM]} {
        puts "Error: CM name ${CM} is not of the form CM3NNN where NNN are digits"
        return
    }
    # first program the FPGAs.
    # F1
    set file_ltx_f1 "/nfs/cms/tracktrigger/wittich/Cornell_CM_Rev3_HW/Vivado/proj/prod_test/prod_test.runs/impl_1/top.ltx"
    set file_bit_f1 "/nfs/cms/tracktrigger/wittich/Cornell_CM_Rev3_HW/Vivado/proj/prod_test/prod_test.runs/impl_1/top.bit"
    set_property PROBES.FILE {$file_ltx_f1} [get_hw_devices xcvu13p_0]
    set_property FULL_PROBES.FILE {$file_ltx_f1} [get_hw_devices xcvu13p_0]
    set_property PROGRAM.FILE {$file_bit_f1} [get_hw_devices xcvu13p_0]
    program_hw_devices [get_hw_devices xcvu13p_0]


    # F2
    # here F1 and F2 use the same bit and ltx files
    set file_ltx_f2 $file_ltx_f1
    set file_bit_f2 $file_bit_f1
    set_property PROBES.FILE {$file_ltx_f2} [get_hw_devices xcvu13p_1]
    set_property FULL_PROBES.FILE {$file_ltx_f2} [get_hw_devices xcvu13p_1]
    set_property PROGRAM.FILE {$file_bit_f2} [get_hw_devices xcvu13p_1]
    program_hw_devices [get_hw_devices xcvu13p_1]

    refresh_hw_device [lindex [get_hw_devices xcvu13p_0] 0]
    refresh_hw_device [lindex [get_hw_devices xcvu13p_1] 0]

    # set up IBERT
    source /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_C2CTCDS_setup_IBERT.tcl

    # run Eye scans
    source /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_C2CTCDS_eyescan.tcl
}
