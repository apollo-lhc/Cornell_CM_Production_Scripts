#!/usr/bin/env python3
"""
Single-file mode:
    plot_eyescan.py  <scan.csv>  <out.png>  [title]

Batch/directory mode:
    plot_eyescan.py  --dir  <directory>  [--suffix _eye]

    Finds every *.csv in <directory> that does NOT already have a corresponding
    .png (same stem), renders each one, and writes the PNG next to the CSV.
    Pass --suffix to append a string to each output stem (e.g. foo_eye.png).
    Prints a summary line and exits 0 even if some files fail (failures are
    reported per-file on stderr).

Vivado has no native PNG export for eye scans; this reconstructs the plot from
the CSV's 2D BER matrix. The parser does NOT assume fixed line numbers: it
locates the largest contiguous block of equal-length, mostly-numeric rows and
treats that as the matrix. If the first row / first column look like axis
values (monotonic), they are used as the horizontal (UI) / vertical (code)
axes; otherwise sample indices are used.

Exit code 0 on success, non-zero on failure (caller keeps the CSV regardless).
"""
import sys
import os
import glob
import csv as _csv

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np


def _to_float(x):
    try:
        return float(x)
    except (TypeError, ValueError):
        return None


def _numeric_fraction(row):
    if not row:
        return 0.0
    good = sum(1 for c in row if _to_float(c) is not None)
    return good / len(row)


def parse_matrix(path):
    with open(path, "r", newline="") as f:
        rows = list(_csv.reader(f))

    # candidate data rows: reasonably wide and mostly numeric
    flags = [(len(r) >= 4 and _numeric_fraction(r) >= 0.6) for r in rows]

    # find the longest contiguous run of candidate rows that share a row length
    best = (0, 0, 0)  # (length, start, width)
    i = 0
    n = len(rows)
    while i < n:
        if not flags[i]:
            i += 1
            continue
        j = i
        width = len(rows[i])
        while j < n and flags[j] and len(rows[j]) == width:
            j += 1
        if (j - i) > best[0]:
            best = (j - i, i, width)
        i = j

    run_len, start, width = best
    if run_len < 3 or width < 3:
        raise ValueError(
            "could not locate a 2D numeric block in CSV (run_len=%d width=%d)"
            % (run_len, width)
        )

    block = [[_to_float(c) for c in rows[r][:width]] for r in range(start, start + run_len)]

    arr = np.array([[np.nan if v is None else v for v in r] for r in block], dtype=float)

    x_axis = None
    y_axis = None

    def _monotonic(v):
        v = v[~np.isnan(v)]
        if v.size < 3:
            return False
        d = np.diff(v)
        return np.all(d > 0) or np.all(d < 0)

    # strip a header row if it looks like an x-axis
    if _monotonic(arr[0, 1:]):
        x_axis = arr[0, 1:]
        # and a y-axis column if present
        if _monotonic(arr[1:, 0]):
            y_axis = arr[1:, 0]
            data = arr[1:, 1:]
        else:
            data = arr[1:, :]
    else:
        if _monotonic(arr[:, 0]):
            y_axis = arr[:, 0]
            data = arr[:, 1:]
        else:
            data = arr

    return data, x_axis, y_axis


def render(csv_path, png_path, title=None):
    """Render one CSV to one PNG. Raises on failure."""
    if title is None:
        title = csv_path

    data, x_axis, y_axis = parse_matrix(csv_path)

    finite = data[np.isfinite(data)]
    pos = finite[finite > 0]
    floor = pos.min() / 10.0 if pos.size else 1e-12
    plot = np.where((data > 0) & np.isfinite(data), data, floor)
    plot = np.log10(plot)

    if x_axis is not None and y_axis is not None:
        extent = [float(np.nanmin(x_axis)), float(np.nanmax(x_axis)),
                  float(np.nanmin(y_axis)), float(np.nanmax(y_axis))]
        xlabel, ylabel = "Horizontal (UI)", "Vertical (codes)"
    else:
        extent = [0, data.shape[1], 0, data.shape[0]]
        xlabel, ylabel = "Horizontal sample", "Vertical sample"

    fig, ax = plt.subplots(figsize=(7, 5))
    im = ax.imshow(plot, aspect="auto", origin="lower", extent=extent,
                   cmap="viridis", interpolation="nearest")
    cb = fig.colorbar(im, ax=ax)
    cb.set_label("log10(BER)")
    ax.set_title(title, fontsize=9)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    fig.tight_layout()
    fig.savefig(png_path, dpi=150)
    plt.close(fig)


def main():
    args = sys.argv[1:]

    # batch/directory mode
    if args and args[0] == "--dir":
        if len(args) < 2:
            sys.stderr.write("usage: plot_eyescan.py --dir <directory> [--suffix <sfx>]\n")
            return 2
        directory = args[1]
        suffix = ""
        if "--suffix" in args:
            idx = args.index("--suffix")
            if idx + 1 < len(args):
                suffix = args[idx + 1]

        csvs = sorted(glob.glob(os.path.join(directory, "*.csv")))
        # skip the summary file produced by run_eyescans.tcl
        csvs = [c for c in csvs if os.path.basename(c) != "eyescan_summary.csv"]

        ok = skip = fail = 0
        for csv_path in csvs:
            stem = os.path.splitext(csv_path)[0]
            png_path = stem + suffix + ".png"
            if os.path.exists(png_path):
                skip += 1
                continue
            try:
                render(csv_path, png_path, title=os.path.basename(stem))
                ok += 1
            except Exception as e:
                sys.stderr.write("FAIL %s: %s\n" % (csv_path, e))
                fail += 1

        print("batch done: %d rendered, %d skipped (png exists), %d failed" % (ok, skip, fail))
        return 0 if fail == 0 else 1

    # single-file mode
    if len(args) < 2:
        sys.stderr.write("usage: plot_eyescan.py <scan.csv> <out.png> [title]\n"
                         "       plot_eyescan.py --dir <directory> [--suffix <sfx>]\n")
        return 2
    csv_path = args[0]
    png_path = args[1]
    title = args[2] if len(args) > 2 else csv_path

    try:
        render(csv_path, png_path, title)
    except Exception as e:
        sys.stderr.write("ERROR: %s\n" % e)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
