# Scripts Used for Cornell CM Produciton Checkout

## IBERTpy Plotting Script
### Overview
### Requirements
- **Python 3+**
- **fpdf** (the package used to make a pdf file from converting a csv file of a Vivado eyescan. For instruction on how to install it, please follow https://github.com/reingart/pyfpdf) 
### Instructions
The IBERTpy is a set of modified scripts from https://github.com/mvsoliveira/IBERTpy to convert Vivado eyescans from .csv to .pdf and .png formats. The path to a csv input file is structured for Cornell CM Production in the following manner: **Cornell_CM_Production_Scripts/scans/CM#/fpga#/mm-dd-yyyy/*.csv'**. 

To convert a csv input file to a pdf + png file and store them in the same dir as the csv input file, run the following command in IBERTpy:
```sh
$ python3 generate_all_plots.py XX X 
```
where XX is an integer for CM# and X is another integer for fpga#
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
loaded by the *run.py* script and specify the MGT's to be tuned, the tuning
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

#### Running the autotuning script
The autotuning script is run by the following command:

```sh
$ python3 run.py
```

It loads the parameters in *config.ini*, opening two vivado instances and
connecting one to the transmitter and the other to the receiver FPGA. The
initial setting it then loaded through TCL files, which can set the initial
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
