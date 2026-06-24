#==============================================================================
# run_eyescans.tcl
#
# Loop over every hw_sio_link in a *running* Vivado Hardware Manager instance
# and run a 2D full-eye scan on each. Writes one CSV (native Vivado output) and
# one PNG (rendered from the CSV by plot_eyescan.py) per link.
#
# Output layout:
#   <base>/<CMID>/<YYYYMMDD>_<n>/
#       link_<idx>_<rxname>.csv
#       link_<idx>_<rxname>.png
#       eyescan_summary.csv      (per-link status / metrics / file paths)
#       run.log
#   where <n> is the lowest integer not already used today (no overwrite).
#
# Usage (in the Vivado Tcl Console, with a target open and links present):
#   source run_eyescans.tcl
#   run_eyescans -cm CM3015 -base /data/eyescans
#
# All flags are optional:
#   -cm        CM identifier (default CM0000). Form CMxxxx, used as top dir.
#   -base      base output directory (default: current working dir).
#   -h_incr    horizontal increment (default 2).
#   -v_incr    vertical   increment (default 2).
#   -ber       dwell BER target      (default 1e-8).
#   -filter    only scan links whose DISPLAY_NAME matches this glob (default *).
#   -h_range   horizontal range string, e.g. {-0.500 UI to 0.500 UI} (default: leave scan default).
#   -v_range   vertical   range string (default: leave scan default).
#
# Verified against Vivado 2022.2 command/property names; stable for later
# releases (2020.x-2025.x). create_/run_/wait_on_/write_hw_sio_scan and the
# HORIZONTAL_INCREMENT / VERTICAL_INCREMENT / DWELL_BER properties are the
# documented eye-scan interface.
#==============================================================================

proc _es_log {fh msg} {
    set ts [clock format [clock seconds] -format %H:%M:%S]
    puts "\[$ts\] $msg"
    if {$fh ne ""} { puts $fh "\[$ts\] $msg" ; flush $fh }
}

# Read a property if it exists, else return "" (no error).
proc _es_getprop {obj name} {
    set v ""
    catch {set v [get_property $name $obj]}
    return $v
}

# Make a filesystem-safe token out of an arbitrary object name.
proc _es_sanitize {s} {
    regsub -all {[^A-Za-z0-9._-]+} $s "_" s
    set s [string trim $s "_"]
    if {$s eq ""} { set s "unknown" }
    return $s
}

proc run_eyescans {args} {

    # ---- defaults --------------------------------------------------------
    array set opt {
        -cm      CM0000
        -base    {}
        -h_incr  2
        -v_incr  2
        -ber     1e-8
        -filter  *
        -h_range {}
        -v_range {}
    }
    # ---- parse flags -----------------------------------------------------
    foreach {k v} $args {
        if {![info exists opt($k)]} {
            error "run_eyescans: unknown option '$k'. Valid: [lsort [array names opt]]"
        }
        set opt($k) $v
    }
    if {$opt(-base) eq ""} { set opt(-base) [pwd] }

    set cm    $opt(-cm)
    if {![regexp {^CM[0-9A-Za-z]+$} $cm]} {
        puts "WARNING: -cm '$cm' is not of the form CMxxxx; using it verbatim."
    }

    # ---- build output dir: <base>/<cm>/<YYYYMMDD>_<n> --------------------
    set datestr [clock format [clock seconds] -format %Y%m%d]
    set n 0
    while {[file exists [file join $opt(-base) $cm ${datestr}_$n]]} { incr n }
    set outdir [file join $opt(-base) $cm ${datestr}_$n]
    file mkdir $outdir

    set logfh [open [file join $outdir run.log] w]
    _es_log $logfh "Output directory: $outdir"
    _es_log $logfh "Increments: h=$opt(-h_incr) v=$opt(-v_incr)  DWELL_BER=$opt(-ber)  filter=$opt(-filter)"

    # ---- locate the PNG helper (sits next to this script) ----------------
    set script_dir [file dirname [file normalize [info script]]]
    set pyhelper   [file join $script_dir plot_eyescan.py]
    set can_plot   [file exists $pyhelper]
    if {!$can_plot} {
        _es_log $logfh "WARNING: plot_eyescan.py not found next to this script; PNGs will be skipped (CSV still written)."
    }
    # pick a python interpreter once
    set pybin ""
    foreach cand {python3 python} {
        if {![catch {exec $cand --version} verr]} { set pybin $cand ; break }
    }
    if {$can_plot && $pybin eq ""} {
        _es_log $logfh "WARNING: no python3/python on PATH; PNGs will be skipped (CSV still written)."
        set can_plot 0
    }

    # ---- collect links ---------------------------------------------------
    if {[catch {get_hw_sio_links} all_links] || [llength $all_links] == 0} {
        _es_log $logfh "ERROR: no hw_sio_links found. Is a target open with detected links? Aborting."
        close $logfh
        return
    }
    # apply filter on DISPLAY_NAME
    set links {}
    foreach l $all_links {
        set dn ""
        catch {set dn [get_property DISPLAY_NAME $l]}
        if {[string match $opt(-filter) $dn]} { lappend links $l }
    }
    set total [llength $links]
    _es_log $logfh "Found [llength $all_links] link(s); $total match filter. Starting scans."

    # ---- summary file ----------------------------------------------------
    # NOTE on metrics (see Vivado / ChipScoPy eye-scan metrics):
    #   open_area           : OPEN_AREA            - size of the open region (2D)
    #   open_area_percent   : OPEN_PERCENTAGE      - open area / total scanned area (2D %)
    #   open_ui_percent     : HORIZONTAL_PERCENTAGE- horizontal opening / UI  == Vivado "Open UI %"
    #   horizontal_opening  : HORIZONTAL_OPENING   - raw horizontal opening
    #   vertical_opening    : VERTICAL_OPENING     - raw vertical opening
    #   vertical_percent    : VERTICAL_PERCENTAGE  - vertical opening %
    # Property names are inferred from the ChipScoPy API casing; the real names
    # for your build are dumped once to scan_properties.txt (verify against this).
    set sumfh [open [file join $outdir eyescan_summary.csv] w]
    puts $sumfh "index,link_display_name,rx,tx,link_group,status,open_area,open_area_percent,open_ui_percent,horizontal_opening,vertical_opening,vertical_percent,csv_file,png_file,result"
    flush $sumfh
    set dumped_props 0

    set idx 0
    foreach link $links {
        set tag [format "%03d" $idx]

        set dn ""; set rxn ""; set txn ""; set grp ""
        catch {set dn  [get_property DISPLAY_NAME $link]}
        catch {set rxn [get_property DISPLAY_NAME [get_hw_sio_rxs -of_objects $link]]}
        catch {set txn [get_property DISPLAY_NAME [get_hw_sio_txs -of_objects $link]]}
        catch {set grp [get_property DISPLAY_NAME [get_hw_sio_linkgroups -of_objects $link]]}

        set label "link_${tag}_[_es_sanitize $rxn]"
        set csv [file join $outdir ${label}.csv]
        set png [file join $outdir ${label}.png]

        _es_log $logfh "($idx/$total) scanning $dn  RX=$rxn  TX=$txn"

        set result "OK"
        set m_open_area ""; set m_open_area_pct ""; set m_open_ui_pct ""
        set m_h_open ""; set m_v_open ""; set m_v_pct ""
        set scan ""

        if {[catch {
            set scan [create_hw_sio_scan -description "${cm}_${label}" 2d_full_eye $link]
            set_property HORIZONTAL_INCREMENT $opt(-h_incr) $scan
            set_property VERTICAL_INCREMENT   $opt(-v_incr) $scan
            set_property DWELL_BER            $opt(-ber)    $scan
            if {$opt(-h_range) ne ""} { catch {set_property HORIZONTAL_RANGE $opt(-h_range) $scan} }
            if {$opt(-v_range) ne ""} { catch {set_property VERTICAL_RANGE   $opt(-v_range) $scan} }

            run_hw_sio_scan  $scan
            wait_on_hw_sio_scan $scan

            # On the first completed scan, dump the real property names/values so
            # the exact metric names for this Vivado build can be verified.
            if {!$dumped_props} {
                set pf [open [file join $outdir scan_properties.txt] w]
                puts $pf "report_property of scan for: $dn"
                catch {puts $pf [report_property -return_string $scan]}
                close $pf
                set dumped_props 1
            }

            # Eye-opening metrics. Distinct quantities -- do NOT conflate the 2D
            # area percentage (OPEN_PERCENTAGE) with the horizontal Open UI %
            # (HORIZONTAL_PERCENTAGE).
            set m_open_area    [_es_getprop $scan OPEN_AREA]
            set m_open_area_pct [_es_getprop $scan OPEN_PERCENTAGE]
            set m_open_ui_pct  [_es_getprop $scan HORIZONTAL_PERCENTAGE]
            set m_h_open       [_es_getprop $scan HORIZONTAL_OPENING]
            set m_v_open       [_es_getprop $scan VERTICAL_OPENING]
            set m_v_pct        [_es_getprop $scan VERTICAL_PERCENTAGE]

            write_hw_sio_scan -force $csv $scan
        } emsg]} {
            set result "SCAN_FAIL: $emsg"
            _es_log $logfh "  ERROR: $emsg"
        }

        # free the scan object regardless
        if {$scan ne ""} { catch {remove_hw_sio_scan $scan} }

        # render PNG from CSV
        set png_written ""
        if {$result eq "OK" && [file exists $csv]} {
            if {$can_plot} {
                if {[catch {exec $pybin $pyhelper $csv $png "$cm $dn ($rxn)"} perr]} {
                    _es_log $logfh "  WARNING: PNG render failed: $perr"
                    append result "; PNG_FAIL"
                } else {
                    set png_written $png
                }
            }
        }

        puts $sumfh "$idx,\"$dn\",\"$rxn\",\"$txn\",\"$grp\",[get_property STATUS $link],\"$m_open_area\",\"$m_open_area_pct\",\"$m_open_ui_pct\",\"$m_h_open\",\"$m_v_open\",\"$m_v_pct\",\"$csv\",\"$png_written\",\"$result\""
        flush $sumfh
        incr idx
    }

    close $sumfh
    _es_log $logfh "Done. $idx link(s) processed. Results in: $outdir"
    close $logfh
    puts "All output written to: $outdir"
    return $outdir
}

puts "Loaded run_eyescans. Example:"
puts "  run_eyescans -cm CM3015 -base /data/eyescans"
