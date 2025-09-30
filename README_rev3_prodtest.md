# CM Apollo Rev 3 IBERT Production Tests

### Set Up
Running these commands requires an up to date python and vivado installation.
You can tell the rev 3 production scripts how to find the python installation
on Cornell computers by running the following commands:
```sh
export PATH="/cdat/tem/pw94/miniconda/bin:${PATH}"
. "/cdat/tem/pw94/miniconda/etc/profile.d/conda.sh"
conda activate
```
Then, run these commands to do the same for vivado:
```sh
source /nfs/opt/Xilinx/Vivado/2020.2/settings64.sh
export XILINXD_LICENSE_FILE=2100@lnxlm
```

Next, program the board. Connect to the rev3 board in the Vivado GUI, and program the FPGAs
with the desired firmware. If the test is being run on the lnx231 with copper cables,
program the board with the firmwares immediately below. DO NOT USE THESE BIT FILES IF
THE LINKS ARE SET UP WITH OPTICAL CABLES. DOING SO MAY DAMAGE THE BOARD!
```sh
FPGA1 bitstream: /nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p1_VU13p-1-SM_USP_LHS_25G_DC_on_12ch_site_25GRHS.bit
FPGA2 bitstream: /nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p2_VU13p-1-SM_USP_LHS_25G_DC_on_12ch_site_25GRHS.bit
```

### Running the autotuning script
***Not yet decided if we are running autotuning before every eyescan test***
The autotuning scripts tune each link's paramaeters to maximize the link open area.
Navigate to /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/autotuning. 
Then run the autotuning scripts for rev 3 production testing with the command below. It
will take a while to run. As an example, if the board being tested has the id CM3003,
the `<board id>` argument should be CM3003.
```sh
python3 run_rev3_prodtest.py <board id>
```

It loads the parameters in *config_rev3_prodtest.ini*, opening two vivado instances and
connecting one to the transmitter and the other to the receiver FPGA. The
initial setting is then loaded through TCL files, which can set the initial
tuning configuration, PRBS pattern, DFE setting and invert RX/TX differential
pins (if this is required by the PCB design. The script then tests everyone of
the tuning configurations, saves its performance in a CSV file and then presents
the best configuration found.

### Running the eyescan script
Next, we want to generate eye diagrams of the links. To do this, set the MGT links.
"Autodetect links" often misses several of the links, so instead run the command
below in the Vivado tcl console:
```sh
source /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_prodtest_setup_IBERT.tcl
```

We now tell the scripts the board id (e.g. CM3002) and run eyescans over all of these
links. Run the commands below in the tcl console in the Vivado GUI to run eyescans over
all of the links that we just set. The tcl script will take a while to run.
```sh
set CM <board id>
source /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_prodtest_eyescan.tcl
```
This command will run eyescans one at a time over all of the links in the standard rev 3
configuration and save then as csv files. The current version of the command that runs the
eyescans in Vivado saves the scans to two locations: once into the downloaded
Cornell_CM_Production_Scripts output directories
(/nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/scans/`<board id>`/`<date>`)
and once into the shared track trigger output directories
(/nfs/cms/tracktrigger/apollo/`<board id>`/scans/`<date>`), where `<date>` will be automatically
generated of the form mm-dd-yy.

To convert all of the csv files to pdf + png files and store them in the same directory
as the csv files, run the following commands in
/nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/IBERTpy/python, where
`<board id>` is the id of the scanned board (e.g. CM3002) and date is of the form mm-dd-yy:
```sh
python3 generate_all_plots.py <board id> <date of scans>
```
If you encounter a problem, check that your python environment is set up correctly.

After generating pdfs and png files, one can generate a summary pdf that organizes all eyescans
of the standard rev3 MGT configuration into a more easily navigated summary document by entering
the following command in /nfs/cms/tracktrigger/apollo/Cornell_CM_Production_Scripts/IBERTpy/latex:
```sh
pdflatex --jobname=summary_eyescans --output-directory=/nfs/cms/tracktrigger/apollo/<board id>/scans/<date of scans> "\def\dateofscans{<date of scans>} \def\CM{<board id>} \input{rev3_prodtest_eyescan_summary.tex}"
```
Upon encountering a warning, type the letter r and hit enter to force the computer to ignore
all further warnings. The "jobname" argument sets the name of the output pdf. If you wish to
save the output files to a different directory you can change --output-directory=`<desired output directory>`.
Finally, THE ABOVE pdflatex COMMAND MUST BE RUN TWICE for the summary document's table of contents to generate properly.