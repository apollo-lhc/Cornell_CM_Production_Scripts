#==============================================================================
# sweep_tx.tcl
#
# Sweep TX equalization parameters (TXPRE, TXPOST, TXDIFFSWING) on a single
# IBERT link to find the combination that maximises eye opening. The link must
# already exist in a *running* Vivado Hardware Manager instance.
#
# Usage (Vivado Tcl Console, target open, links present):
#   source sweep_tx.tcl
#   sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps
#
# All flags are optional except -link:
#   -link          DISPLAY_NAME glob selecting the target link (must match exactly 1).
#   -cm            CM identifier (default CM0000).
#   -base          Base output directory (default: current working dir).
#   -metric        Scan property to maximise (default HORIZONTAL_PERCENTAGE).
#                  Other useful choices: OPEN_PERCENTAGE, OPEN_AREA.
#   -txpre_values  Tcl list of TXPRE values to try.   {} = auto-enumerate.
#   -txpost_values Tcl list of TXPOST values to try.  {} = auto-enumerate.
#   -txdiff_values Tcl list of TXDIFFSWING values to try. {} = auto-enumerate.
#   -txpre_prop    Property name override for pre-cursor  (default TXPRE).
#   -txpost_prop   Property name override for post-cursor (default TXPOST).
#   -txdiff_prop   Property name override for diff-swing  (default TXDIFFSWING).
#   -h_incr        Horizontal scan increment during sweep (default 4, coarser for speed).
#   -v_incr        Vertical   scan increment during sweep (default 4).
#   -ber           BER dwell target during sweep (default 1e-6, relaxed for speed).
#   -final_scan    1=run a full-resolution scan on the winner (default 1).
#   -final_h_incr  Horizontal increment for final scan (default 2).
#   -final_v_incr  Vertical   increment for final scan (default 2).
#   -final_ber     BER dwell for final scan (default 1e-8).
#   -png           1=render PNG of final scan via plot_eyescan.py (default 0).
#   -list          1=print enumerated parameter values and exit without scanning.
#
# Output layout:
#   <base>/<cm>/<YYYYMMDD>_<n>/
#       sweep_summary.csv       all combinations + metrics, sorted by -metric desc
#       link_props.txt          report_property of the link (verify TX prop names)
#       scan_props.txt          report_property of first scan (verify metric names)
#       winner_<label>.csv      full-res eye scan of best combination
#       winner_<label>.png      PNG of winner (if -png 1)
#       run.log
#
# IMPORTANT: TX property names (TXPRE / TXPOST / TXDIFFSWING) and their valid
# values are IBERT-build specific. If the defaults don't match your build, run
# probe_link_props (from recreate_links.tcl) to see the real names, then pass
# them via -txpre_prop / -txpost_prop / -txdiff_prop. link_props.txt in the
# output dir also shows all properties on the link.
#==============================================================================

proc _sw_log {fh msg} {
    set ts [clock format [clock seconds] -format %H:%M:%S]
    puts "\[$ts\] $msg"
    if {$fh ne ""} { puts $fh "\[$ts\] $msg" ; flush $fh }
}

proc _sw_getprop {obj name} {
    set v ""
    catch {set v [get_property $name $obj]}
    return $v
}

# Build a map of device-path-prefix -> F-number by querying get_hw_devices.
# Each device's NAME property is the path prefix that appears at the start of
# all its endpoints' NAME paths (e.g. "localhost:.../0_1_0_0").
# Call once before iterating links; pass the result to _sw_link_short_name.
proc _sw_build_dev_map {} {
    set m {}
    catch {
        foreach d [get_hw_devices] {
            set fnum [expr {[string match "*_0" $d] ? 1 : 2}]
            foreach ibert [get_hw_sio_iberts -of_objects $d] {
                set iname [get_property NAME $ibert]
                # IBERT NAME is like "localhost:.../0_1_0_0/IBERT"
                # Strip trailing /IBERT to get the device path prefix.
                if {[regexp {^(.+)/IBERT$} $iname -> dev_path]} {
                    dict set m $dev_path $fnum
                }
            }
        }
    }
    return $m
}

# Derive a short human-readable name for a link (e.g. "F2_X0Y27") using a
# pre-built device-path map. Mirrors make_link_name in recreate_links.tcl.
proc _sw_link_short_name {link dev_map} {
    set rx_path ""; set tx_path ""
    catch {set rx_path [get_property NAME [get_hw_sio_rxs -of_objects $link]]}
    catch {set tx_path [get_property NAME [get_hw_sio_txs -of_objects $link]]}

    set rx_mgt "?"; set tx_mgt "?"
    catch {regexp {MGT_(X\d+Y\d+)} $rx_path -> rx_mgt}
    catch {regexp {MGT_(X\d+Y\d+)} $tx_path -> tx_mgt}

    set rx_fnum "?"; set tx_fnum "?"
    dict for {dpath fnum} $dev_map {
        if {$dpath ne "" && [string first $dpath $rx_path] == 0} { set rx_fnum $fnum }
        if {$dpath ne "" && [string first $dpath $tx_path] == 0} { set tx_fnum $fnum }
    }

    if {$rx_fnum eq $tx_fnum && $rx_mgt eq $tx_mgt} { return "F${rx_fnum}_${rx_mgt}" }
    if {$rx_fnum eq $tx_fnum} { return "F${rx_fnum}_RX_${rx_mgt}_TX_${tx_mgt}" }
    return "F${rx_fnum}rx_${rx_mgt}_F${tx_fnum}tx_${tx_mgt}"
}

proc _sw_sanitize {s} {
    regsub -all {[^A-Za-z0-9._-]+} $s "_" s
    set s [string trim $s "_"]
    if {$s eq ""} { set s "unknown" }
    return $s
}

# Return the list of valid enumerated values for a property on a link object.
# Returns {} if the property doesn't exist or has no enumerated values.
proc _sw_enum_values {link prop} {
    set vals {}
    catch {set vals [list_property_value $prop $link]}
    return $vals
}

# Set TX equalization properties on a link and commit to hardware.
# Returns "" on success, or an error string on failure.
proc _sw_set_commit {link pre post diff prop_pre prop_post prop_diff} {
    set errs {}
    if {$pre  ne ""} { if {[catch {set_property $prop_pre  $pre  $link} e]} { lappend errs "$prop_pre: $e"  } }
    if {$post ne ""} { if {[catch {set_property $prop_post $post $link} e]} { lappend errs "$prop_post: $e" } }
    if {$diff ne ""} { if {[catch {set_property $prop_diff $diff $link} e]} { lappend errs "$prop_diff: $e" } }
    if {[catch {commit_hw_sio $link} e]} { lappend errs "commit: $e" }
    return [join $errs "; "]
}

# Run one 2d_full_eye scan on $link. Writes CSV to $csvpath, removes scan object.
# Returns a dict with keys: ok (1/0), metric_val, open_area, open_area_pct,
# open_ui_pct, h_open, v_open, v_pct, error.
proc _sw_one_scan {link csvpath label h_incr v_incr ber metric_prop {keep 0}} {
    set result [dict create ok 0 metric_val "" open_area "" open_area_pct "" \
                    open_ui_pct "" h_open "" v_open "" v_pct "" error ""]
    set scan ""
    if {[catch {
        set scan [create_hw_sio_scan -description $label 2d_full_eye $link]
        set_property HORIZONTAL_INCREMENT $h_incr $scan
        set_property VERTICAL_INCREMENT   $v_incr $scan
        set_property DWELL_BER            $ber    $scan
        run_hw_sio_scan     $scan
        wait_on_hw_sio_scan $scan

        dict set result open_area     [_sw_getprop $scan OPEN_AREA]
        dict set result open_area_pct [_sw_getprop $scan OPEN_PERCENTAGE]
        dict set result open_ui_pct   [_sw_getprop $scan HORIZONTAL_PERCENTAGE]
        dict set result h_open        [_sw_getprop $scan HORIZONTAL_OPENING]
        dict set result v_open        [_sw_getprop $scan VERTICAL_OPENING]
        dict set result v_pct         [_sw_getprop $scan VERTICAL_PERCENTAGE]
        dict set result metric_val    [_sw_getprop $scan $metric_prop]

        write_hw_sio_scan -force $csvpath $scan
        dict set result ok 1
    } emsg]} {
        dict set result error $emsg
    }
    if {!$keep && $scan ne ""} { catch {remove_hw_sio_scan $scan} }
    return $result
}

# Filter a list of Vivado enum value strings to those whose leading numeric
# value falls within [min_v, max_v] (inclusive). The leading number is the
# first integer or decimal at the start of the string, e.g.:
#   "450 mV (00010)"  -> 450
#   "3.99 dB (01111)" -> 3.99
proc _sw_filter_by_range {vals min_v max_v} {
    set out {}
    foreach v $vals {
        if {[regexp {^([0-9]+(?:\.[0-9]+)?)} [string trim $v] -> num]} {
            if {![catch {expr {double($num) >= double($min_v) && double($num) <= double($max_v)}} ok] && $ok} {
                lappend out $v
            }
        }
    }
    return $out
}

proc sweep_tx {args} {

    # ---- defaults --------------------------------------------------------
    array set opt {
        -link          {}
        -cm            CM0000
        -base          {}
        -metric        HORIZONTAL_PERCENTAGE
        -txpre_values  {}
        -txpost_values {}
        -txdiff_values {}
        -txpre_range   {}
        -txpost_range  {}
        -txdiff_range  {}
        -txpre_prop    TXPRE
        -txpost_prop   TXPOST
        -txdiff_prop   TXDIFFSWING
        -h_incr        4
        -v_incr        4
        -ber           1e-6
        -final_scan    1
        -final_h_incr  2
        -final_v_incr  2
        -final_ber     1e-8
        -png           0
        -list          0
    }
    foreach {k v} $args {
        if {![info exists opt($k)]} {
            error "sweep_tx: unknown option '$k'. Valid: [lsort [array names opt]]"
        }
        set opt($k) $v
    }
    if {$opt(-link) eq ""} { error "sweep_tx: -link is required." }
    if {$opt(-base) eq ""} { set opt(-base) [pwd] }

    # ---- output directory ------------------------------------------------
    set cm $opt(-cm)
    set datestr [clock format [clock seconds] -format %Y%m%d]
    set n 0
    while {[file exists [file join $opt(-base) $cm ${datestr}_$n]]} { incr n }
    set outdir [file join $opt(-base) $cm ${datestr}_$n]
    file mkdir $outdir

    set logfh [open [file join $outdir run.log] w]
    _sw_log $logfh "sweep_tx  link=$opt(-link)  metric=$opt(-metric)"
    _sw_log $logfh "Output directory: $outdir"

    # ---- build device map for F-number derivation (once, before link loop) --
    set dev_map [_sw_build_dev_map]
    _sw_log $logfh "Device map: $dev_map"

    # ---- resolve target link (must be exactly one) -----------------------
    set all_links {}
    catch {set all_links [get_hw_sio_links]}
    set candidates {}
    foreach l $all_links {
        set dn_disp ""; set dn_short ""
        catch {set dn_disp [get_property DISPLAY_NAME $l]}
        catch {set dn_short [_sw_link_short_name $l $dev_map]}
        if {[string match $opt(-link) $dn_disp] ||
            [string match $opt(-link) $dn_short]} {
            lappend candidates $l
        }
    }
    if {[llength $candidates] == 0} {
        _sw_log $logfh "ERROR: no links match -link '$opt(-link)'. Available: [llength $all_links] link(s)."
        _sw_log $logfh "First 3 links (DISPLAY_NAME / derived short name):"
        foreach l [lrange $all_links 0 2] {
            set d ""; set s ""
            catch {set d [get_property DISPLAY_NAME $l]}
            catch {set s [_sw_link_short_name $l $dev_map]}
            _sw_log $logfh "  DISPLAY_NAME='$d'  short='$s'"
        }
        close $logfh ; return
    }
    if {[llength $candidates] > 1} {
        set names [lmap l $candidates {_sw_link_short_name $l $dev_map}]
        _sw_log $logfh "ERROR: -link '$opt(-link)' matched [llength $candidates] links: $names. Use a more specific glob."
        close $logfh ; return
    }
    set link [lindex $candidates 0]
    set link_dn [_sw_getprop $link DISPLAY_NAME]
    if {$link_dn eq ""} { catch {set link_dn [_sw_link_short_name $link $dev_map]} }
    _sw_log $logfh "Target link: $link_dn"

    # ---- dump link properties for reference ------------------------------
    set lpf [open [file join $outdir link_props.txt] w]
    puts $lpf "report_property for link: $link_dn"
    catch {puts $lpf [report_property -return_string $link]}
    close $lpf

    # ---- save original TX values (restore on exit) -----------------------
    set orig_pre  [_sw_getprop $link $opt(-txpre_prop)]
    set orig_post [_sw_getprop $link $opt(-txpost_prop)]
    set orig_diff [_sw_getprop $link $opt(-txdiff_prop)]
    _sw_log $logfh "Original TX: $opt(-txpre_prop)='$orig_pre'  $opt(-txpost_prop)='$orig_post'  $opt(-txdiff_prop)='$orig_diff'"

    # ---- enumerate / filter parameter values --------------------------------
    # Priority: explicit -txXXX_values > -txXXX_range filter > full enumeration
    foreach {var prop val_flag range_flag orig_val} [list \
            pre_vals  $opt(-txpre_prop)  -txpre_values  -txpre_range  $orig_pre  \
            post_vals $opt(-txpost_prop) -txpost_values -txpost_range $orig_post \
            diff_vals $opt(-txdiff_prop) -txdiff_values -txdiff_range $orig_diff] {
        if {$opt($val_flag) ne {}} {
            set $var $opt($val_flag)
            _sw_log $logfh "$prop: using [llength $opt($val_flag)] explicit value(s)"
        } else {
            set all [_sw_enum_values $link $prop]
            if {[llength $all] == 0} {
                _sw_log $logfh "WARNING: could not enumerate values for $prop; using current value '$orig_val' only."
                set all [list $orig_val]
            }
            if {$opt($range_flag) ne {}} {
                set rmin [lindex $opt($range_flag) 0]
                set rmax [lindex $opt($range_flag) 1]
                set filtered [_sw_filter_by_range $all $rmin $rmax]
                if {[llength $filtered] == 0} {
                    _sw_log $logfh "WARNING: range \[$rmin, $rmax\] matched no values for $prop; using all [llength $all] value(s)."
                    set $var $all
                } else {
                    _sw_log $logfh "$prop: range \[$rmin, $rmax\] selected [llength $filtered] of [llength $all] value(s)"
                    set $var $filtered
                }
            } else {
                set $var $all
            }
        }
    }

    set n_pre  [llength $pre_vals]
    set n_post [llength $post_vals]
    set n_diff [llength $diff_vals]
    set total  [expr {$n_pre * $n_post * $n_diff}]
    _sw_log $logfh "$opt(-txpre_prop): $n_pre value(s)  $opt(-txpost_prop): $n_post value(s)  $opt(-txdiff_prop): $n_diff value(s)  => $total combination(s)"
    _sw_log $logfh "Sweep scan settings: h_incr=$opt(-h_incr) v_incr=$opt(-v_incr) ber=$opt(-ber)"
    if {$total > 200} {
        _sw_log $logfh "NOTE: $total combinations may take a long time. Consider narrowing with -txXXX_range or -txXXX_values."
    }

    # -list: print enumerated values and exit without scanning
    if {$opt(-list)} {
        puts "$opt(-txpre_prop) ([llength $pre_vals] values):"
        foreach v $pre_vals { puts "  {$v}" }
        puts "$opt(-txpost_prop) ([llength $post_vals] values):"
        foreach v $post_vals { puts "  {$v}" }
        puts "$opt(-txdiff_prop) ([llength $diff_vals] values):"
        foreach v $diff_vals { puts "  {$v}" }
        puts "Total combinations: $total"
        close $logfh
        file delete -force $outdir
        return
    }

    # ---- dump scan object properties for reference (before loop) --------
    catch {
        set probe [create_hw_sio_scan -description "prop_probe" 2d_full_eye $link]
        set spf [open [file join $outdir scan_props.txt] w]
        puts $spf "report_property of scan object:"
        catch {puts $spf [report_property -return_string $probe]}
        close $spf
        remove_hw_sio_scan $probe
    }

    # ---- summary CSV -----------------------------------------------------
    set sumfh [open [file join $outdir sweep_summary.csv] w]
    puts $sumfh "$opt(-txpre_prop),$opt(-txpost_prop),$opt(-txdiff_prop),$opt(-metric),open_area,open_area_pct,open_ui_pct,h_open,v_open,v_pct,csv_file,result"
    flush $sumfh

    # ---- sweep -----------------------------------------------------------
    set best_metric  -1e99
    set best_pre     $orig_pre
    set best_post    $orig_post
    set best_diff    $orig_diff
    set combo_idx 0

    foreach pre $pre_vals {
        set pre_ok 1
        foreach post $post_vals {
            if {!$pre_ok} break
            set post_ok 1
            foreach diff $diff_vals {
                incr combo_idx
                set label "sweep_[format %03d $combo_idx]_[_sw_sanitize $link_dn]"
                set csvpath [file join $outdir ${label}.csv]

                _sw_log $logfh "($combo_idx/$total) $opt(-txpre_prop)='$pre'  $opt(-txpost_prop)='$post'  $opt(-txdiff_prop)='$diff'"

                # apply TX settings
                set cerr [_sw_set_commit $link $pre $post $diff \
                              $opt(-txpre_prop) $opt(-txpost_prop) $opt(-txdiff_prop)]
                if {$cerr ne ""} {
                    _sw_log $logfh "  SKIP (set/commit failed): $cerr"
                    puts $sumfh "\"$pre\",\"$post\",\"$diff\",,,,,,,,,\"SKIP: $cerr\""
                    flush $sumfh
                    if {[string match "$opt(-txpre_prop):*" $cerr]}  { set pre_ok  0; break }
                    if {[string match "$opt(-txpost_prop):*" $cerr]} { set post_ok 0; break }
                    continue
                }

                # run scan
                set r [_sw_one_scan $link $csvpath $label \
                           $opt(-h_incr) $opt(-v_incr) $opt(-ber) $opt(-metric)]

                if {![dict get $r ok]} {
                    _sw_log $logfh "  SCAN_FAIL: [dict get $r error]"
                    puts $sumfh "\"$pre\",\"$post\",\"$diff\",,,,,,,,,\"SCAN_FAIL: [dict get $r error]\""
                    flush $sumfh
                    continue
                }

                set mv [dict get $r metric_val]
                _sw_log $logfh "  $opt(-metric)=$mv"

                puts $sumfh "\"$pre\",\"$post\",\"$diff\",\"$mv\",\"[dict get $r open_area]\",\"[dict get $r open_area_pct]\",\"[dict get $r open_ui_pct]\",\"[dict get $r h_open]\",\"[dict get $r v_open]\",\"[dict get $r v_pct]\",\"$csvpath\",\"OK\""
                flush $sumfh

                # track best (numeric compare; ignore non-numeric metric values)
                if {![catch {expr {double($mv) > $best_metric}} better] && $better} {
                    set best_metric $mv
                    set best_pre    $pre
                    set best_post   $post
                    set best_diff   $diff
                }
            }
        }
    }
    close $sumfh

    # ---- restore original TX settings ------------------------------------
    _sw_log $logfh "Restoring original TX settings."
    _sw_set_commit $link $orig_pre $orig_post $orig_diff \
        $opt(-txpre_prop) $opt(-txpost_prop) $opt(-txdiff_prop)

    _sw_log $logfh "Sweep complete. Winner: $opt(-txpre_prop)='$best_pre'  $opt(-txpost_prop)='$best_post'  $opt(-txdiff_prop)='$best_diff'  $opt(-metric)=$best_metric"

    # ---- optional full-resolution scan on winner -------------------------
    if {$opt(-final_scan)} {
        _sw_log $logfh "Running full-resolution final scan on winner (h=$opt(-final_h_incr) v=$opt(-final_v_incr) ber=$opt(-final_ber))."
        set cerr [_sw_set_commit $link $best_pre $best_post $best_diff \
                      $opt(-txpre_prop) $opt(-txpost_prop) $opt(-txdiff_prop)]
        if {$cerr ne ""} {
            _sw_log $logfh "  WARNING: could not apply winner TX settings for final scan: $cerr"
        } else {
            set win_label "winner_[_sw_sanitize $link_dn]"
            set win_csv   [file join $outdir ${win_label}.csv]
            set win_png   [file join $outdir ${win_label}.png]
            set r [_sw_one_scan $link $win_csv $win_label \
                       $opt(-final_h_incr) $opt(-final_v_incr) $opt(-final_ber) $opt(-metric) 1]
            if {[dict get $r ok]} {
                _sw_log $logfh "  Final scan written: $win_csv  $opt(-metric)=[dict get $r metric_val]"
                # optional PNG
                if {$opt(-png)} {
                    set script_dir [file dirname [file normalize [info script]]]
                    set pyhelper   [file join $script_dir plot_eyescan.py]
                    set pybin ""
                    foreach cand {python3 python} {
                        if {![catch {exec $cand --version}]} { set pybin $cand ; break }
                    }
                    if {$pybin ne "" && [file exists $pyhelper]} {
                        if {[catch {exec $pybin $pyhelper $win_csv $win_png "$cm $link_dn (winner)"} perr]} {
                            _sw_log $logfh "  WARNING: PNG render failed: $perr"
                        } else {
                            _sw_log $logfh "  PNG written: $win_png"
                        }
                    } else {
                        _sw_log $logfh "  WARNING: python or plot_eyescan.py not found; PNG skipped."
                    }
                }
            } else {
                _sw_log $logfh "  WARNING: final scan failed: [dict get $r error]"
            }
        }
        # restore again after final scan
        _sw_set_commit $link $orig_pre $orig_post $orig_diff \
            $opt(-txpre_prop) $opt(-txpost_prop) $opt(-txdiff_prop)
    }

    _sw_log $logfh "Done. Results in: $outdir"
    close $logfh
    puts "All output written to: $outdir"
    return $outdir
}

puts "Loaded sweep_tx."
puts "  # Full sweep (auto-enumerate all values):"
puts "  sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps"
puts "  # Numeric range filter (recommended — units match the Vivado label):"
puts "  sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps \\"
puts "      -txdiff_range {400 600} -txpost_range {0 4} -txpre_range {0 1}"
puts "  # Enumerate without scanning to see which values the range selects:"
puts "  sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps -txdiff_range {400 600} -list 1"
puts "  # Explicit values (backward compatible):"
puts "  sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps \\"
puts "      -txpost_values {{3.99 dB (01111)} {1.77 dB (00111)}} -txpre_values {{0.01 dB (00000)}}"
