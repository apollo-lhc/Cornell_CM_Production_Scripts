# program FPGAs with IBERT + heater FW
if {![info exists hostname]} {
    set hostname apollo3008-1
}
puts "Programming FPGAs on ${hostname}..."


set_property PROGRAM.FILE {/nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p1_VU13p-1-SM_USP_Quad121-134_25Gbps.bit} [get_hw_devices xcvu13p_0]
program_hw_devices [get_hw_devices xcvu13p_0]
refresh_hw_device [lindex [get_hw_devices xcvu13p_0] 0]
set_property PROBES.FILE {} [get_hw_devices xcvu13p_1]
set_property FULL_PROBES.FILE {} [get_hw_devices xcvu13p_1]
set_property PROGRAM.FILE {/nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p2_VU13p-1-SM_USP_Quad121-134_25Gbps.bit} [get_hw_devices xcvu13p_1]
program_hw_devices [get_hw_devices xcvu13p_1]
refresh_hw_device [lindex [get_hw_devices xcvu13p_1] 0]

