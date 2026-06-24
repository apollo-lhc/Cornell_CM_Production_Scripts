# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Vivado Hardware IBERT eye-scan automation toolkit for characterizing high-speed serial links on Xilinx FPGAs. Targets 2× Xilinx Virtex UltraScale+ VU13P FPGAs with 88 configured MGT transceiver links.

## Requirements

- Vivado 2022.2+ (stable across 2020.x–2025.x) with Hardware Manager open and IBERT target detected
- Python 3 with `matplotlib` and `numpy` (for PNG generation)

## Usage

All Tcl scripts are run inside the **Vivado Tcl Console** with a hardware target open and IBERT detected.

### Standard workflow

```tcl
# 1. (Optional) Inspect TX property names on your specific build
source recreate_links.tcl
probe_link_props

# 2. Configure all 88 links
recreate_links -group ALL_LINKS -prefix CM3015_

# 3. Run eye scans on all links
source run_eyescans.tcl
run_eyescans -cm CM3015 -base /data/eyescans -h_incr 2 -v_incr 2 -ber 1e-8
```

### Sweep TX parameters on a single link

```tcl
source sweep_tx.tcl
# Recommended: numeric range filter (units match the Vivado label — mV for TXDIFFSWING, dB for TXPRE/TXPOST)
sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps \
    -txdiff_range {400 600} -txpost_range {0 4} -txpre_range {0 1}

# Preview which values the range selects without running any scans:
sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps -txdiff_range {400 600} -list 1

# Full sweep of all auto-enumerated values (can be hundreds of combinations):
sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps

# Explicit value lists (backward compatible):
sweep_tx -link F1_X0Y16 -cm CM3015 -base /data/sweeps \
    -txpost_values {{3.99 dB (01111)} {1.77 dB (00111)}} \
    -txpre_values  {{0.01 dB (00000)}}
```

### Render a PNG manually

```bash
python3 plot_eyescan.py <scan.csv> <out.png> ["optional title"]
```

## Architecture

**`recreate_links.tcl`** — Link configuration. Reads `ES_LINK_TABLE` (88 `{txdev txpath rxdev rxpath}` entries auto-generated from a hardware spreadsheet) and creates `hw_sio_link` objects in Vivado. Device mapping: index 0 = `xcvu13p_0` (F1), index 1 = `xcvu13p_1` (F2). All links are placed into one `hw_sio_linkgroup`. TX post-cursor and diff-swing are set on each link then committed to hardware via `commit_hw_sio`.

**`run_eyescans.tcl`** — Scan execution. Iterates all `hw_sio_link` objects matching an optional `DISPLAY_NAME` glob filter, runs a `2d_full_eye` scan on each with configurable resolution and BER dwell target, writes per-link CSV + PNG, and appends a row to `eyescan_summary.csv`. Output lands in `<base>/<CMID>/<YYYYMMDD>_<n>/` — the `<n>` suffix auto-increments to avoid overwriting. `plot_eyescan.py` is expected in the same directory as this script; PNG failures are non-fatal (CSV is always preserved).

**`sweep_tx.tcl`** — TX equalization optimizer. Targets a single link and iterates over combinations of TXPRE, TXPOST, and TXDIFFSWING values, running a fast coarse scan (h/v_incr=4, ber=1e-6) at each combination. Tracks the best result by a configurable metric (default `HORIZONTAL_PERCENTAGE`), restores original TX settings after the sweep, and optionally runs a full-resolution final scan on the winner (kept visible in the Serial I/O Scans tab). Parameter values can be specified three ways — explicit list (`-txXXX_values`), numeric range (`-txXXX_range {min max}`, where the unit matches the Vivado label: mV for TXDIFFSWING, dB for TXPRE/TXPOST), or full auto-enumeration via `list_property_value`. The combination count is logged upfront; use `-list 1` to preview selected values without scanning. Writes `sweep_summary.csv`, `link_props.txt`, and `scan_props.txt` to the output directory.

**`plot_eyescan.py`** — CSV-to-PNG renderer. Parses Vivado's 2D full-eye CSV by finding the largest contiguous block of equal-width, mostly-numeric rows (robust to format changes — no fixed line-number assumptions). Strips monotonic first row/column as axis labels. Renders log10(BER) heatmap via matplotlib viridis colormap; zero-error bins are floored to `min_positive_BER / 10` so they plot dark rather than as NaN.

## Key caveats

**TX property names vary by IBERT build.** `TXPOST` and `TXDIFFSWING` are the names emitted by the IBERT GUI, but they may differ on your build. Always run `probe_link_props` first and pass `-txpost_prop` / `-txdiff_prop` overrides to `recreate_links` if needed. Failures are logged per-link and never silently ignored.

**Link naming convention:** The F-number in a link name follows the **RX** endpoint (`make_link_name` proc in `recreate_links.tcl`). Cross-FPGA links use `F<rx>rx_<rxmgt>_F<tx>tx_<txmgt>` form.

**Cross-FPGA vs loopback:** 32 F1 links are intra-FPGA loopback (Quads 124–131), 32 F2 links are intra-FPGA loopback (Quads 124–131), and 24 links are cross-FPGA (Quads 132–134 with TX on one FPGA, RX on the other).
