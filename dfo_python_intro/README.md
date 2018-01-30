# Introduction to Python
An introductory lesson to using Python for data analysis. 

Author: Nancy Soontiens

## Set up
We will be using the Anaconda distribution of Python 3.6 for this lesson. 
Python is a popular programming language that can be used for scientific 
computing. The Anaconda distribution of Python automatically installs 
many packages useful for scientific computing.

### Web Browser
We will be using the Jupyter Notebook to use Python in a web browser. 
For this to work, you will need a reasonably up-to-date browser. The 
current versions of Chrome, Firefox, and Safari are 
[supported](https://jupyter-notebook.readthedocs.io/en/stable/notebook.html#browser-compatibility)
but older  browsers like Internet Explorer version 9 and below are not. 
Please update your default browser if needed.

### Installing Python

#### Windows Users

1. Open https://www.anaconda.com/download/#windows with your web 
browser.
2. Download the Python 3 installer for Windows.
3. Install Python 3 using all of the defaults for installation except 
make sure to check **Make Anaconda the default Python**.
4. Check the installation by loading "Anaconda Navigator" from the 
Start Menu. Once it is loaded, click "Launch" in the Jupyter Notebook 
dialogue/box. Your web browser should open Jupyter Notebook in a new 
tab.

#### Mac Users
1. Open http://continuum.io/downloads with your web browser.
2. Download the Python 3 installer for OS X.
3. Install Python 3 using all of the defaults for installation.
4. Check the installation by opening a terminal window. Type `jupyter 
notebook` and press enter. Your web browser should open JupyterNnotebook 
in a new tab.

#### Linux Users
1. Open https://www.anaconda.com/download/#linux with your web browser.
2. Download the Python 3 installer for Linux.
3. Open a terminal window.
4. Type
    ````bash
    bash Anaconda3-
    ````
    and then press tab. The name of the file you just downloaded should appear.
    If it does not, navigate to the folder where you downloaded the 
    file, for example with:
    ````bash
    cd Downloads
    ````
    Then, try again.
5. Press enter. You will follow the text-only prompts. To move through 
the text, press the space key. Type `yes` and press enter to approve the 
license. Press enter to approve the default location for the files. Type 
`yes` and press enter to prepend Anaconda to your `PATH` (this makes the 
Anaconda distribution the default Python).
6. Close the terminal window.  
7. Check the installation by opening a terminal window. Type `jupyter 
notebook` and press enter. Your web browser should open Jupyter 
Notebook in a new tab. 


Set up instructions adapted from [Software 
Carpentry](https://software-carpentry.org/). 

# Data Sources
The data file `RaceRocksDailySalTemp.txt` is from a [data collection 
program](http://www.pac.dfo-mpo.gc.ca/science/oceans/data-donnees/lightstations-phares/index-eng.html)
in the DFO Pacific Region.
