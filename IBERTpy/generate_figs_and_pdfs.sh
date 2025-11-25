#! /bin/sh

# Script to generate all plots for a given board and date, and
# the pdf file that collects them all.
# Usage: ./generate_all_plots.sh CM3XXY MM-DD-YY
# run this from the IBERTpy directory


print_help() {
    cat <<EOF
Usage: $0 [--sm|--cm] <board_id> <date>

Description:
  Generate plots and summary PDFs for a given board and scan date.
  By default, both SM and CM links are processed.

Options:
  --sm           Only process SM links (C2C and TCDS).
  --cm           Only process CM links (firefly and inter-fpga)
  -h, --help     Show this help and exit.

Arguments:
  <board_id>     Board ID in the format CM3XXY (e.g. CM3003).
  <date>         Date of the scans in MM-DD-YY (e.g. 06-13-25).

Examples:
  $0 CM3003 06-13-25
  $0 --sm CM3003 06-13-25
  $0 --cm CM3003 06-13-25
EOF
}

# Parse command line options for SM/CM links
LINK_TYPE="both"  # default: process both SM and CM links
while [[ $# -gt 0 ]]; do
    case $1 in
        --sm)
            LINK_TYPE="sm"
            shift
            ;;
        --cm)
            LINK_TYPE="cm"
            shift
            ;;
        *)
            break
            ;;
    esac
done


# show help if requested
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    print_help
    exit 0
fi

# process the command line arguments
if [ "$#" -ne 2 ]; then
    print_help
    exit 1
fi

BOARD_ID=$1
# sanity check the board ID format
if ! [[ $BOARD_ID =~ ^CM3[0-9]{3}$ ]]; then
    echo "Error: board ID format is incorrect."
    print_help
    exit 1
fi

DATE=$2 
# sanity check the date format
if ! [[ $DATE =~ ^[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: date format is incorrect."
    print_help
    exit 1
fi

# print out what we are doing
echo "Generating plots for board $BOARD_ID on date $DATE..."
cd python || { echo "Error: Failed to change directory to python."; exit 1; }

# call the python script to generate all plots
python3 generate_all_plots.py $BOARD_ID $DATE
if [ $? -ne 0 ]; then
    echo "Error: Failed to generate plots."
    exit 1
fi
echo "Plots generated successfully for board $BOARD_ID on date $DATE."

cd ../latex || { echo "Error: Failed to change directory to latex."; exit 1; }

# run pdflatex to create the summary PDF
TEXFILES="rev3_prodtest_eyescan_summary.tex rev3_C2CTCDS_eyescan_summary.tex"
if [ "$LINK_TYPE" = "sm" ]; then
    TEXFILES="rev3_C2CTCDS_eyescan_summary.tex"
elif [ "$LINK_TYPE" = "cm" ]; then
    TEXFILES="rev3_prodtest_eyescan_summary.tex"
fi

for TEXFILE in $TEXFILES; do
    if [ ! -f $TEXFILE ]; then
        echo "Error: LaTeX file $TEXFILE not found."
        exit 1
    fi
    ODIR="../../scans/$BOARD_ID/scans/$DATE"
    JOBNAME=$(basename $TEXFILE .tex).pdf
    echo "file $TEXFILE, writing to directory $ODIR, jobname $JOBNAME"

    pdflatex --interaction=nonstopmode --jobname=$JOBNAME \
        --output-directory=$ODIR \
        "\def\dateofscans{$DATE} \def\CM{$BOARD_ID} \input{$TEXFILE}"
    pdflatex --interaction=nonstopmode --jobname=$JOBNAME \
        --output-directory=$ODIR \
        "\def\dateofscans{$DATE} \def\CM{$BOARD_ID} \input{$TEXFILE}"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to generate PDF $JOBNAME."
        exit 1
    fi
    echo "Summary PDF $(basename $TEXFILE .tex) generated successfully."
done
