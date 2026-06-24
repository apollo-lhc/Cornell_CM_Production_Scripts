proc setup_links_run {{hostname apollo3012-1}} {
    # allow hostname variable to be used in other scripts
    set ::hostname $hostname
    connect_hw_server -allow_non_jtag
    open_hw_target -xvc_url ${hostname}:2542

    # wait for command to complete 
    after 5000
    refresh_hw_device [lindex [get_hw_devices xcvu13p_0] 0]
    refresh_hw_device [lindex [get_hw_devices xcvu13p_1] 0]

    source setup_links_daq.tcl
}

# Keep command-line behavior when invoked as a script.
if {[info exists argv0] && ([file normalize [info script]] eq [file normalize $argv0])} {
    set hostname [lindex $argv 0]
    if {$hostname eq ""} {
        set hostname apollo3012-1
    }
    setup_links_run $hostname
}