# Scripts Used for Cornell CM Produciton Checkout

## IBERTpy Eyescan & Plotting Scripts
### Overview
`mcu_tools` submodule contains automated scripts in the shell directory to create a weekly-report directory in `/nfs/cms/hw/apollo/` and run C2C eyescans on any apollo blades. We note that currently a one-by-one eyescan and parallel eyescans (for C2C links) are enabled.
### Requirements
- **Python 3+**
- **fpdf** (the package used to make a pdf file from converting a csv file of a Vivado eyescan. For instruction on how to install it, please follow https://github.com/reingart/pyfpdf)
- **FF Connectors** connected in standard configuration
### Instructions for running the rev3 production test eyescan scripts
The IBERTpy is a set of modified scripts from https://github.com/mvsoliveira/IBERTpy to convert Vivado eyescans from .csv to .pdf and .png formats. The path to a csv input file is structured for Cornell CM Production in the following manner: **Cornell_CM_Production_Scripts/scans/CM#/mm-dd-yy/*.csv'**.

We would like to generate eye diagrams of the links. To do this, we must first
program the board. Connect to the rev3 board in the Vivado GUI, and program the FPGAs
with the desired firmware. If the test is being run on the lnx231 with copper cables,
program the board with the firmwares immediately below. DO NOT USE THESE BIT FILES IF
THE LINKS ARE SET UP WITH OPTICAL CABLES. DOING SO MAY DAMAGE THE BOARD!
```sh
FPGA1 bitstream: /nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p1_VU13p-1-SM_USP_LHS_25G_DC_on_12ch_site.bit
FPGA2 bitstream: /nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p2_VU13p-1-SM_USP_LHS_25G_DC_on_12ch_site.bit
```

If the rev3 board is connected to the lnx4189 with links connected via optical cable, the following firmware properly programs the two FPGAs for eyescans of the standard links:
```sh
FPGA1 bitstream: /nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p1_VU13p-1-SM_USP_heaters_TF.bit
FPGA2 bitstream: /nfs/cms/tracktrigger/rzou/firmware/top_Cornell_rev3_p2_VU13p-1-SM_USP_heaters_TF.bit
```

Next, set the MGT links.  Autodetect links often misses several of the links, so instead run the command below in the Vivado tcl console:
```sh
source <path to this imported repository>/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_prodtest_setup_IBERT.tcl
```

We can now define the rev3 board id (e.g. CM3002) and run eyescans over all of these links. Run the following commands in the tcl console to run eyescans over all of the links that we just set:
```sh
set CM <board id>
source <path to this imported repository>/Cornell_CM_Production_Scripts/autotuning/tcl/rev3_prodtest_eyescan.tcl
```

The current version of the command that runs the eyescans in Vivado saves the scans to two locations: once into the downloaded Cornell_CM_ProductionScripts output directories (<path to this imported repository>/Cornell_CM_Production_Scripts/scans/<board id>/<date>) and once into the shared track trigger output directories (/nfs/cms/tracktrigger/apollo/<board id>/scans/<date>), where <date> will automatically be generated of the form mm-dd-yy:

To convert all of the csv files to pdf + png files and store them in the same directory as the csv files, run the following commands in <path to this imported repository>/Cornell_CM_Production_Scripts/IBERTpy/python, where <board id> is the id of the scanned board (e.g. CM3002) and date is of the form mm-dd-yy:
```sh
$ export PATH="/cdat/tem/pw94/miniconda/bin:${PATH}"
$ . "/cdat/tem/pw94/miniconda/etc/profile.d/conda.sh"
$ conda activate
$ python3 generate_all_plots.py <board id> <date of scans>
```
The first three of the above commands are to set up the necessary python environment.

After generating pdfs and png files, one can generate a summary pdf that organizes all eyescans of the standard rev3 MGT configuration into a more easily navigated summary document by entering the following command in <path to this imported repository>/Cornell_CM_Production_Scripts/IBERTpy/latex:
```sh
$ pdflatex --jobname=summary_eyescans --output-directory=/nfs/cms/tracktrigger/apollo/<board id>/scans/<date of scans> "\def\dateofscans{<date of scans>} \def\CM{<board id>} \input{rev3_prodtest_eyescan_summary.tex}"
```
Upon encountering a warning, type the letter r and hit enter to force the computer to ignore all further warnings. The "jobname" argument sets the name of the output pdf. If you wish to save the output files to a different directory you can change --output-directory=<desired output directory>. Finally, THE ABOVE COMMAND MUST BE RUN TWICE for the summary document's table of contents to generate properly.
  
## C2C-link Eyescans Script
- **Python 2.7** 
- **lnx4189.classe.cornell.edu machine** 
- ssh key-pair to **Apollo## blade**
### Instructions
There are four C2C transceivers with RX-eyescans enable on each rev1 apollo blade. That includes:
```INI
1: C2C1_PHY (RX on Zynq from Virtex)
2: C2C2_PHY (RX on Zynq from Kintex)
3: K_C2C_PHY (RX on Kintex from Zynq)
4: V_C2C_PHY (RX on Virtex from Zynq)
```

*Only K_C2C_PHY is not working (update on 02/01/2022)

Given that we know the Apollo## blade and ttydevice(e.g. ttyUL1)

Run the following command on lnx4189 to just run a single eyescan at a time
```sh
shell $ ./automate_apollo_single_eyescan.sh
```
Or, run the following command on lnx4189 to run eyescans in parallel. 
```sh
shell $ ./automate_apollo_parallel_eyescans.sh
```

Depending on what program is executed, it will ask for Apollo##, ttydevice and your username or foldername on apollo's home directory as well as the C2C link number (1,2,..etc.) for the single-eyescan script. It will `ssh` to a corresponding Zynq and run either **c2c_single_eyescan_script** or **c2c_parallel_eyescans_script** in `username/ApolloTool` folder. Then, it will take a few minutes to run eyescan(s), given the customizable numbers of x-binning, y-binnning, and maximum prescale inside the above automate shell script. The current set of these parameters is {binx=40,biny=40,max_prescale=6}. 

In addition to eyescan outputs to be transfered, both programs also implicitly dump CM##, ID and some commands to check statuses of FPGAs on the CM module to `mcu_tools/data` folder before transfering its `dump*.txt` to lnx4189. However, if the board ID/CM ID is not yet set (i.e ID:00000000), then the program will ask for a user-defined CM# (which is supposed to be the same as the board ID) to `set_id` on the apollo board and ammend the ID info in the `dump*.txt` that is transfered earlier. 

Once, the output files are ready to be transfered. The programs will create a directory `/CM##/weekXX-MM-YYYY/` in `/nfs/cms/hw/apollo/` in order to save `*.png` and `*.log` files from running eyescans with `BUTool.exe` on Apollo##. This step is done implicitly by `check_cm_id_to_mkdir.py` and `set_cm_dir.sh`. (Note that Weekly = Mon-Sun and WeekXX where XX = 1-53)


### Results

* **Eyescan outputs:** Two files(`*.png` + `*.log`) per one eyescan, or three* `*.png` and one `*.log` files from parallel eyescans will be transfered to the weekly-report folder. 
* **Minicom outputs:** One `dump*.txt` file per program execution will be transfered to the weekly-report folder. 

## Autotuning System for Xilinx MGTs

### Overview
Directory containing scripts to tune the emphasis and equalization of
high-speed serial links between two Xilinx FPGA's.

### Requirements
- **Python 3+**
- **Vivado** (the scripts consider that it is possible to start the vivado
  software by calling *vivado* at the terminal. If that is not the case, change
  the \_\_init\_\_ method of XilinxTCL class)
- Boards programmed with the **IBERT bitstream**, configured with the MGT's to
  be tuned at the desired line rate

### Instructions
The autotuning is done in 3 steps: **preparing the boards**, **setting the
*config.ini*** and **running the autotuning script**. In this respository, all
parameters were set for an optical transmission between two KC705 kits, running
at 10 Gbps and using PRBS31.

#### Preparing the boards
The transmitter and receiver boards should be programmed with an IBERT bitstream
generated by Vivado. The line rate, reference clock and enabled MGT's should be
set according to the conditions the system is going to operate.

#### [Optional] Set up the automated autotuning script
Please create and/or adjust the hw_*.tcl in the autotuning/automate folder.

#### Setting the *config.ini*
The *config.ini* file is where the test parameters should be set. They are
loaded by the *run.py* script and specify the MGT's to be tuned, the FPGA's on which the transmitters and receivers are located, the tuning
configurations to be tested, stop conditions for the tuning process, among other
parameters. The file is organized in sections and their variables, as the
following example:

```INI

[Section1]
variable1 = value
variable2 = value

[Section2]
variable3 = value
variable4 = value
variable5 = value

[DEFAULT]
variable1 = value
variable4 = value
variable5 = value

```

The DEFAULT section is a special one, and stablishes the default value for some
of the variables of other sections. If they are not set in their own sections,
the DEFAULT value is used.

#### Setting other files
In the program's current state, autotuning can only run over a set of MGT's that all
share the same transmitter and receiver FPGA locations (e.g. all MGT's with
transmitters on FPGA 1 and all receivers on FPGA 2). Autotuning of MGT's with different
transmitter and receiver FPGA locations must be performed in multiple runs of the autotuning
program for each collection of MGT's that have the same transmitter and receiver FPGA
locations, properly modifying the relevant files after each run.
Before running the files, be sure to set the FPGA on which the transmitters and
receivers of the MGT's are located in CM_VU13P_rcv_setup.tcl and CM_VU13P_trm_setup.tcl.
Both of these files have a line near the top of the code that specifies the FPGA location:
xcvu13p_0 for FPGA 1 and xcvu13p_1 for FPGA 2.

#### Running the autotuning script
The autotuning script for rev 3 production testing is run by the following command. The
argument <board id> should correspond to the board being tuned (e.g. CM3003).
```sh
$ python3 run_rev3_prodtest.py <board id>
```

It loads the parameters in *config_rev3_prodtest.ini*, opening two vivado instances and
connecting one to the transmitter and the other to the receiver FPGA. The
initial setting is then loaded through TCL files, which can set the initial
tuning configuration, PRBS pattern, DFE setting and invert RX/TX differential
pins (if this is required by the PCB design. The script then tests everyone of
the tuning configurations, saves its performance in a CSV file and then presents
the best configuration found.

#### [Optional] Run the automated autotuning script
This script opens Vivado instances and configures the FPGAs with bit files. The 
Vivado instances remain open (no need to start Vivado by yourself). Then the test 
is perormed by using the run.py script:

```sh
$ cd automate
$ ./run_MGT_autotune.sh
```

### Results
The results are presented in a CSV file. The columns present the TX Differential
Swing, TX Pre, TX Post, RX termination voltage and the respective eye scan open
area resultant for that configuration. This parameter measures how open the eye
scan is, and should be maximized to improve the link integrity. An example of a
CSV result file is shown bellow.

```CSV
TXDIFFSWING,TXPRE,TXPOST,RXTERM,Open Area
269 mV (0000),0.00 dB (00000),0.00 dB (00000),900 mV,2664
269 mV (0000),0.00 dB (00000),4.44 dB (10000),900 mV,2268
269 mV (0000),4.44 dB (10000),0.00 dB (00000),900 mV,1692
269 mV (0000),4.44 dB (10000),4.44 dB (10000),900 mV,1332
------------BEST------------
269 mV (0000),0.00 dB (00000),0.00 dB (00000),900 mV,2664

```

#### Running the margin scanning script
The margin scanning script is run by the following command. It uses the same logic as the autotuning script but scans with 1D bathtub plot instead of 2D eyescan.

```sh
$ python3 run1D.py
```
This only scans parameters on the FPGA. To scan parameter on the firefly, one needs to directly change the setting on the firefly via mcu and run the scan for each of the changed setting. Make sure to modify the name of the files saved everytime the firefly setting changes.


To plot. First run the following command to make a table with all the data.
```sh
$ python3 table.py
```
This creates a log that gathers all the settings and links together as well as an array of number of good links in the end.

Copy and paste the last array into the following script and run to create plot.

```sh
$ python3 plotting.py
```
