#==============================================================================
# recreate_links.tcl
#
# Recreate the IBERT link configuration captured in Table_cm3003_itdtc.xlsx in a
# *running* Vivado 2022.2 Hardware Manager instance: create all 88 TX->RX links,
# put them in ONE link group, name them by FPGA (F1=xcvu13p_0, F2=xcvu13p_1),
# and explicitly set TX Post-Cursor and TX Diff Swing to the table values.
#
# Run in the Vivado Tcl Console (target open, IBERT detected):
#     source recreate_links.tcl
#     recreate_links                         ;# defaults
#     recreate_links -group MYGRP -prefix CM3015_
#
# Options (all optional):
#   -group       link group description/name        (default ALL_LINKS)
#   -prefix      string prepended to every link name (default "")
#   -clear       1=remove existing links+groups first (default 1)
#   -commit      1=commit_hw_sio after setting TX     (default 1)
#   -txpost      TX post-cursor value string          (default {3.99 dB (01111)})
#   -txdiff      TX diff-swing value string           (default {450 mV (00010)})
#   -txpost_prop link property name for post-cursor   (default TXPOST)
#   -txdiff_prop link property name for diff-swing    (default TXDIFFSWING)
#   -dev0        F1 device object override            (default: auto, *_0)
#   -dev1        F2 device object override            (default: auto, *_1)
#
# IMPORTANT - verify before trusting blindly:
#   * TXPOST / TXDIFFSWING are the link-property names emitted by the IBERT GUI
#     and the value is the full dropdown label incl. the register code in (...).
#     If your build differs, run  probe_link_props  on the existing instance to
#     dump the real names/values, then pass -txpost_prop/-txdiff_prop/-txpost/
#     -txdiff. Failures here are caught per-link and logged, never silent.
#   * Naming convention for cross-FPGA links: F-number follows the RX endpoint.
#     Edit make_link_name (below) to change it.
#
# Verified command/syntax: create_hw_sio_link <tx> <rx> (TX then RX, GUI order),
# create_hw_sio_linkgroup <links>, remove_hw_sio_link/-linkgroup, get_hw_sio_*.
#==============================================================================

#--- Endpoint inventory (auto-generated from the spreadsheet) -----------------
# Each element: {tx_dev tx_path rx_dev rx_path}
#   tx_dev/rx_dev: 0 = xcvu13p_0 (F1), 1 = xcvu13p_1 (F2)
#   *_path = Quad_xxx/MGT_XaYb ; the MGT coord is matched against endpoint DISPLAY_NAME
set ES_LINK_TABLE {
      {0 Quad_124/MGT_X0Y16 0 Quad_124/MGT_X0Y16}
      {0 Quad_124/MGT_X0Y17 0 Quad_124/MGT_X0Y17}
      {0 Quad_124/MGT_X0Y18 0 Quad_124/MGT_X0Y18}
      {0 Quad_124/MGT_X0Y19 0 Quad_124/MGT_X0Y19}
      {0 Quad_125/MGT_X0Y20 0 Quad_125/MGT_X0Y20}
      {0 Quad_125/MGT_X0Y21 0 Quad_125/MGT_X0Y21}
      {0 Quad_125/MGT_X0Y22 0 Quad_125/MGT_X0Y22}
      {0 Quad_125/MGT_X0Y23 0 Quad_125/MGT_X0Y23}
      {0 Quad_126/MGT_X0Y24 0 Quad_126/MGT_X0Y24}
      {0 Quad_126/MGT_X0Y25 0 Quad_126/MGT_X0Y25}
      {0 Quad_126/MGT_X0Y26 0 Quad_126/MGT_X0Y26}
      {0 Quad_126/MGT_X0Y27 0 Quad_126/MGT_X0Y27}
      {0 Quad_127/MGT_X0Y28 0 Quad_127/MGT_X0Y28}
      {0 Quad_127/MGT_X0Y29 0 Quad_127/MGT_X0Y29}
      {0 Quad_127/MGT_X0Y30 0 Quad_127/MGT_X0Y30}
      {0 Quad_127/MGT_X0Y31 0 Quad_127/MGT_X0Y31}
      {0 Quad_128/MGT_X0Y32 0 Quad_128/MGT_X0Y32}
      {0 Quad_128/MGT_X0Y33 0 Quad_128/MGT_X0Y33}
      {0 Quad_128/MGT_X0Y34 0 Quad_128/MGT_X0Y34}
      {0 Quad_128/MGT_X0Y35 0 Quad_128/MGT_X0Y35}
      {0 Quad_129/MGT_X0Y36 0 Quad_129/MGT_X0Y36}
      {0 Quad_129/MGT_X0Y37 0 Quad_129/MGT_X0Y37}
      {0 Quad_129/MGT_X0Y38 0 Quad_129/MGT_X0Y38}
      {0 Quad_129/MGT_X0Y39 0 Quad_129/MGT_X0Y39}
      {0 Quad_130/MGT_X0Y40 0 Quad_130/MGT_X0Y40}
      {0 Quad_130/MGT_X0Y41 0 Quad_130/MGT_X0Y41}
      {0 Quad_130/MGT_X0Y42 0 Quad_130/MGT_X0Y42}
      {0 Quad_130/MGT_X0Y43 0 Quad_130/MGT_X0Y43}
      {0 Quad_131/MGT_X0Y44 0 Quad_131/MGT_X0Y44}
      {0 Quad_131/MGT_X0Y45 0 Quad_131/MGT_X0Y45}
      {0 Quad_131/MGT_X0Y46 0 Quad_131/MGT_X0Y46}
      {0 Quad_131/MGT_X0Y47 0 Quad_131/MGT_X0Y47}
      {1 Quad_132/MGT_X0Y48 0 Quad_132/MGT_X0Y48}
      {1 Quad_132/MGT_X0Y49 0 Quad_132/MGT_X0Y49}
      {1 Quad_132/MGT_X0Y50 0 Quad_132/MGT_X0Y50}
      {1 Quad_132/MGT_X0Y51 0 Quad_132/MGT_X0Y51}
      {1 Quad_133/MGT_X0Y52 0 Quad_133/MGT_X0Y52}
      {1 Quad_133/MGT_X0Y53 0 Quad_133/MGT_X0Y53}
      {1 Quad_133/MGT_X0Y54 0 Quad_133/MGT_X0Y54}
      {1 Quad_133/MGT_X0Y55 0 Quad_133/MGT_X0Y55}
      {1 Quad_134/MGT_X0Y56 0 Quad_134/MGT_X0Y56}
      {1 Quad_134/MGT_X0Y57 0 Quad_134/MGT_X0Y57}
      {1 Quad_134/MGT_X0Y58 0 Quad_134/MGT_X0Y58}
      {1 Quad_134/MGT_X0Y59 0 Quad_134/MGT_X0Y59}
      {1 Quad_124/MGT_X0Y16 1 Quad_124/MGT_X0Y16}
      {1 Quad_124/MGT_X0Y17 1 Quad_124/MGT_X0Y17}
      {1 Quad_124/MGT_X0Y18 1 Quad_124/MGT_X0Y18}
      {1 Quad_124/MGT_X0Y19 1 Quad_124/MGT_X0Y19}
      {1 Quad_125/MGT_X0Y20 1 Quad_125/MGT_X0Y20}
      {1 Quad_125/MGT_X0Y21 1 Quad_125/MGT_X0Y21}
      {1 Quad_125/MGT_X0Y22 1 Quad_125/MGT_X0Y22}
      {1 Quad_125/MGT_X0Y23 1 Quad_125/MGT_X0Y23}
      {1 Quad_126/MGT_X0Y24 1 Quad_126/MGT_X0Y24}
      {1 Quad_126/MGT_X0Y25 1 Quad_126/MGT_X0Y25}
      {1 Quad_126/MGT_X0Y26 1 Quad_126/MGT_X0Y26}
      {1 Quad_126/MGT_X0Y27 1 Quad_126/MGT_X0Y27}
      {1 Quad_127/MGT_X0Y28 1 Quad_127/MGT_X0Y28}
      {1 Quad_127/MGT_X0Y29 1 Quad_127/MGT_X0Y29}
      {1 Quad_127/MGT_X0Y30 1 Quad_127/MGT_X0Y30}
      {1 Quad_127/MGT_X0Y31 1 Quad_127/MGT_X0Y31}
      {1 Quad_128/MGT_X0Y32 1 Quad_128/MGT_X0Y32}
      {1 Quad_128/MGT_X0Y33 1 Quad_128/MGT_X0Y33}
      {1 Quad_128/MGT_X0Y34 1 Quad_128/MGT_X0Y34}
      {1 Quad_128/MGT_X0Y35 1 Quad_128/MGT_X0Y35}
      {1 Quad_129/MGT_X0Y36 1 Quad_129/MGT_X0Y36}
      {1 Quad_129/MGT_X0Y37 1 Quad_129/MGT_X0Y37}
      {1 Quad_129/MGT_X0Y38 1 Quad_129/MGT_X0Y38}
      {1 Quad_129/MGT_X0Y39 1 Quad_129/MGT_X0Y39}
      {1 Quad_130/MGT_X0Y40 1 Quad_130/MGT_X0Y40}
      {1 Quad_130/MGT_X0Y41 1 Quad_130/MGT_X0Y41}
      {1 Quad_130/MGT_X0Y42 1 Quad_130/MGT_X0Y42}
      {1 Quad_130/MGT_X0Y43 1 Quad_130/MGT_X0Y43}
      {1 Quad_131/MGT_X0Y44 1 Quad_131/MGT_X0Y44}
      {1 Quad_131/MGT_X0Y45 1 Quad_131/MGT_X0Y45}
      {1 Quad_131/MGT_X0Y46 1 Quad_131/MGT_X0Y46}
      {1 Quad_131/MGT_X0Y47 1 Quad_131/MGT_X0Y47}
      {0 Quad_132/MGT_X0Y48 1 Quad_132/MGT_X0Y48}
      {0 Quad_132/MGT_X0Y49 1 Quad_132/MGT_X0Y49}
      {0 Quad_132/MGT_X0Y50 1 Quad_132/MGT_X0Y50}
      {0 Quad_132/MGT_X0Y51 1 Quad_132/MGT_X0Y51}
      {0 Quad_133/MGT_X0Y52 1 Quad_133/MGT_X0Y52}
      {0 Quad_133/MGT_X0Y53 1 Quad_133/MGT_X0Y53}
      {0 Quad_133/MGT_X0Y54 1 Quad_133/MGT_X0Y54}
      {0 Quad_133/MGT_X0Y55 1 Quad_133/MGT_X0Y55}
      {0 Quad_134/MGT_X0Y56 1 Quad_134/MGT_X0Y56}
      {0 Quad_134/MGT_X0Y57 1 Quad_134/MGT_X0Y57}
      {0 Quad_134/MGT_X0Y58 1 Quad_134/MGT_X0Y58}
      {0 Quad_134/MGT_X0Y59 1 Quad_134/MGT_X0Y59}
}

#------------------------------------------------------------------------------
# Link naming. F-number follows the RX (measurement) endpoint. EDIT FREELY.
#------------------------------------------------------------------------------
proc make_link_name {txdev txpath rxdev rxpath} {
    set frx [expr {$rxdev + 1}]
    set ftx [expr {$txdev + 1}]
    regexp {MGT_(X\d+Y\d+)} $rxpath -> rxmgt
    regexp {MGT_(X\d+Y\d+)} $txpath -> txmgt
    if {$txdev == $rxdev && $txmgt eq $rxmgt} {
        # ordinary intra-FPGA link, TX/RX on the same channel
        return "F${frx}_${rxmgt}"
    } elseif {$txdev == $rxdev} {
        # same FPGA, but TX and RX on different channels
        return "F${frx}_RX_${rxmgt}_TX_${txmgt}"
    } else {
        # cross-FPGA link: RX side decides the leading F-number
        return "F${frx}rx_${rxmgt}_F${ftx}tx_${txmgt}"
    }
}

#------------------------------------------------------------------------------
# Helper: dump real property names/values of an existing link, so you can
# confirm TXPOST / TXDIFFSWING before relying on them.
#------------------------------------------------------------------------------
proc probe_link_props {} {
    set ls [get_hw_sio_links -quiet]
    if {![llength $ls]} { puts "probe_link_props: no existing links to inspect."; return }
    set l [lindex $ls 0]
    puts "==== report_property for [get_property DISPLAY_NAME $l] ===="
    report_property $l
}

#------------------------------------------------------------------------------
# Resolve a TX/RX endpoint object on a given device by MGT coordinate.
# Returns the object, or "" if not exactly one match.
#------------------------------------------------------------------------------
proc _es_resolve_ep {dev_obj path dir} {
    if {![regexp {MGT_(X\d+Y\d+)} $path -> mgt]} { return "" }
    if {$dir eq "TX"} {
        set objs [get_hw_sio_txs -quiet -of_objects $dev_obj -filter "DISPLAY_NAME =~ *MGT_$mgt/TX"]
    } else {
        set objs [get_hw_sio_rxs -quiet -of_objects $dev_obj -filter "DISPLAY_NAME =~ *MGT_$mgt/RX"]
    }
    if {[llength $objs] != 1} { return "" }
    return [lindex $objs 0]
}

proc recreate_links {args} {
    global ES_LINK_TABLE

    array set opt {
        -group       ALL_LINKS
        -prefix      {}
        -clear       1
        -commit      1
        -txpost      {3.99 dB (01111)}
        -txdiff      {450 mV (00010)}
        -txpost_prop TXPOST
        -txdiff_prop TXDIFFSWING
        -dev0        {}
        -dev1        {}
    }
    foreach {k v} $args {
        if {![info exists opt($k)]} {
            error "recreate_links: unknown option '$k'. Valid: [lsort [array names opt]]"
        }
        set opt($k) $v
    }

    # ---- map FPGA index -> hw_device -----------------------------------
    array set dev {}
    if {$opt(-dev0) ne ""} { set dev(0) $opt(-dev0) }
    if {$opt(-dev1) ne ""} { set dev(1) $opt(-dev1) }
    if {![info exists dev(0)] || ![info exists dev(1)]} {
        foreach d [get_hw_devices] {
            if {![info exists dev(0)] && [string match {*_0} "$d"]} { set dev(0) $d }
            if {![info exists dev(1)] && [string match {*_1} "$d"]} { set dev(1) $d }
        }
    }
    foreach i {0 1} {
        if {![info exists dev($i)]} {
            puts "ERROR: could not identify device for F[expr {$i+1}] (xcvu13p_$i)."
            puts "       Devices present: [get_hw_devices]"
            puts "       Pass -dev0 / -dev1 explicitly with the device objects."
            return
        }
    }
    puts "F1 (xcvu13p_0) -> $dev(0)"
    puts "F2 (xcvu13p_1) -> $dev(1)"

    # ---- optionally clear existing links / groups ----------------------
    if {$opt(-clear)} {
        set eg [get_hw_sio_linkgroups -quiet]
        if {[llength $eg]} { catch {remove_hw_sio_linkgroup $eg} ; puts "Removed [llength $eg] existing link group(s)." }
        set el [get_hw_sio_links -quiet]
        if {[llength $el]} { catch {remove_hw_sio_link $el} ; puts "Removed [llength $el] existing link(s)." }
    }

    # ---- create links ---------------------------------------------------
    set created {}
    set nmade 0 ; set nskip 0 ; set ntx_fail 0
    foreach entry $ES_LINK_TABLE {
        lassign $entry txdev txpath rxdev rxpath
        set txo [_es_resolve_ep $dev($txdev) $txpath TX]
        set rxo [_es_resolve_ep $dev($rxdev) $rxpath RX]
        set nm  $opt(-prefix)[make_link_name $txdev $txpath $rxdev $rxpath]

        if {$txo eq "" || $rxo eq ""} {
            puts "  SKIP $nm : endpoint not resolved (tx='[expr {$txo eq {} ? {MISS} : {ok}}]' rx='[expr {$rxo eq {} ? {MISS} : {ok}}]')  tx=$txpath\[F[expr {$txdev+1}]] rx=$rxpath\[F[expr {$rxdev+1}]]"
            incr nskip
            continue
        }

        if {[catch {
            # GUI convention: TX endpoint first, then RX
            set link [create_hw_sio_link -description $nm $txo $rxo]
        } emsg]} {
            puts "  SKIP $nm : create_hw_sio_link failed: $emsg"
            incr nskip
            continue
        }

        # explicitly set TX post-cursor and diff-swing
        if {[catch {set_property $opt(-txpost_prop) $opt(-txpost) $link} e1]} {
            puts "    WARN $nm : set $opt(-txpost_prop) failed: $e1"; incr ntx_fail
        }
        if {[catch {set_property $opt(-txdiff_prop) $opt(-txdiff) $link} e2]} {
            puts "    WARN $nm : set $opt(-txdiff_prop) failed: $e2"; incr ntx_fail
        }

        lappend created $link
        incr nmade
    }

    puts "Created $nmade link(s); skipped $nskip; TX-property warnings: $ntx_fail."

    # ---- one link group -------------------------------------------------
    if {[llength $created]} {
        if {[catch {create_hw_sio_linkgroup -description $opt(-group) $created} grp]} {
            puts "ERROR: create_hw_sio_linkgroup failed: $grp"
        } else {
            puts "Link group '$opt(-group)' created with [llength $created] link(s): $grp"
        }
    } else {
        puts "ERROR: no links created; link group not made."
        return
    }

    # ---- push TX settings to hardware ----------------------------------
    if {$opt(-commit)} {
        if {[catch {commit_hw_sio $created} ce]} {
            puts "WARN: commit_hw_sio failed: $ce (TX values are set on objects; commit manually if needed)."
        } else {
            puts "Committed TX settings to hardware for [llength $created] link(s)."
        }
    }

    puts "Done."
    return
}

puts "Loaded recreate_links + probe_link_props."
puts "  1) (optional) probe_link_props        ;# confirm TXPOST/TXDIFFSWING on your build"
puts "  2) recreate_links                     ;# or: recreate_links -group MYGRP -prefix CM3015_"
