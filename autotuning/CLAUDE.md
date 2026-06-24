# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a production testing suite for Apollo/CMS tracker FPGA modules used in the CMS experiment at CERN. It automates characterization of high-speed serial links (MGTs — Multi-Gigabit Transceivers) on Xilinx VU13P FPGAs by sweeping TX/RX equalization parameters to maximize eye diagram opening, then generates summary PDF reports.

## Environment Setup (Cornell machines)

```bash
export PATH="/cdat/tem/pw94/miniconda/bin:${PATH}"
. "/cdat/tem/pw94/miniconda/etc/profile.d/conda.sh"
conda activate

source /nfs/opt/Xilinx/Vivado/2020.2/settings64.sh
export XILINXD_LICENSE_FILE=2100@lnxlm
```

## Key Commands

**Run autotuning for a board (primary workflow):**
```bash
cd autotuning
python3 run_rev3_prodtest.py <board_id>   # e.g., CM3002
```

**Run eyescans in Vivado TCL console:**
```tcl
source ./tcl/rev3_prodtest_setup_IBERT.tcl
set CM <board_id>
source ./tcl/rev3_prodtest_eyescan.tcl
```

**Generate eye diagram plots:**
```bash
cd IBERTpy/python
python3 generate_all_plots.py <board_id> <date>   # e.g., CM3002 06-13-25
```

**Generate full summary PDF:**
```bash
cd IBERTpy
./generate_figs_and_pdfs.sh [--sm|--cm] <board_id> <date>
```

**Automated multi-Vivado autotuning:**
```bash
cd autotuning/automate
./run_MGT_autotune.sh
```

## Architecture

### Layered Design

```
INI Config Files
      ↓
Python Main Scripts (run_rev3_prodtest.py, run.py, etc.)
      ↓
pyIBERT.py  ←→  XilinxTCL.py  (subprocess bridge to Vivado)
      ↓
Vivado TCL Console
      ↓
Physical FPGA Hardware (two VU13P FPGAs on Apollo Rev3)
      ↓
CSV results (eye area, error counts per parameter combination)
      ↓
generate_all_plots.py → PNG eye diagrams
      ↓
LaTeX templates + pdflatex → Summary PDF
```

### Python Classes (`classes/`)

- **`XilinxTCL.py`**: Spawns `vivado -mode tcl` as a subprocess; sends TCL commands via stdin and reads stdout, using boundary markers to detect when each command completes.
- **`pyIBERT.py`**: High-level IBERT interface built on `XilinxTCL`. Provides methods for link setup, PRBS pattern selection, DFE control, and eye scan trigger/readback.

### Configuration System

INI files (e.g., `config_rev3_prodtest.ini`) configure everything: hardware server addresses, link-to-quad mappings per direction (4 directional groups: `0_1`, `1_1`, `0to1`, `1to0`), parameter sweep ranges, target eye area, and BER thresholds. `config_parser.tcl` provides an INI parser for TCL scripts.

### TCL Scripts (`tcl/`)

Board-specific setup scripts that load into Vivado Hardware Manager. Named by board type and role: `CM_VU13P_rcv_setup_*.tcl` configures the receiving FPGA side; `CM_VU13P_trm_setup_*.tcl` configures the transmitting side. The `rev3_prodtest_eyescan.tcl` script triggers scans across all configured links.

### Post-Processing (`IBERTpy/`)

`IBERTpy/python/generate_all_plots.py` reads CSV scan data and produces PNG eye diagrams. `IBERTpy/latex/` contains LaTeX templates. `generate_figs_and_pdfs.sh` orchestrates plot generation and `pdflatex` to produce the final summary report.

## Link Configuration

Four directional link groups are tested between two VU13P FPGAs:
- `0_1` — FPGA0 → FPGA0 loopback links
- `1_1` — FPGA1 → FPGA1 loopback links
- `0to1` — FPGA0 → FPGA1 cross links
- `1to0` — FPGA1 → FPGA0 cross links

Links are specified as Xilinx quad/channel identifiers (e.g., `X0Y4`, `X1Y59`).

## Key Config Parameters

| Parameter | Meaning |
|-----------|---------|
| `desired_area` | Target eye opening threshold (higher = better quality, typical target ~8000) |
| `err_req` | Max error count before early exit per parameter combination |
| `BER` | Bit Error Rate for scan (`"1e-6"` is standard) |
| `include_all_results` | Whether to log all sweep iterations or only the best result |

## Output Artifacts

- **CSV files**: `autotune_results/` — raw sweep results, one row per parameter combination
- **PNG files**: Eye diagrams per link
- **PDF files**: Summary reports, mirrored to `/nfs/cms/tracktrigger/apollo/<board_id>/scans/<date>/`

## Runtime Expectations

- Full board autotuning (48+ links) takes 2–4 hours due to nested parameter sweeps and FPGA resets between each combination.
- Vivado Hardware Server must be running on localhost port 3121 before starting.
- Python 3 only; no external dependencies beyond the standard library.
