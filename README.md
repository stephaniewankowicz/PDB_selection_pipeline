# PDB selection pipeline

This repository contains a list of scripts that can be used to find and create isomorphous PDB pairs with the same sequence. 

The original intent was to select ligand bound and ligand unbound structures however this can be adapted to look for other PDB pairs. 

The pipeline starts with a list of PDB IDs with your specification (type of experiment, resolution, ect). This can be obtained from the PDB (). This pipeline will also require you to have phenix installed, qFit installed, as well as a conda enviornment that contains the following packages (you can install these packages into the same conda env that qFit sits in):

os
sys
pandas
Bio.PDB

Run these scripts in this order:

1) run_mtz_dump.sh This script will go through the cif files, unzip them, convert them to mtz and run the mtz dump command. This will provide information on the resolution, space group, and unit cell of the PDBs. This pipeline is set up to be run on the UCSF Wynton servers where there is a local copy of the PDB. If this does not exist for you, please amend this script to download the mtz from the PDB
2) space_unit_text.sh This script will go through the mtz dump files and grab the important information and place it into a text file for easy access for later scripts. 
3) determine_apo_or_holo.sh This script will place PDB IDs into 'apo' or 'holo'. 
4) find_apo_holo.sh This script will go through and match up each holo structure with potential apo structures based on resolution, unit cell, and space group. The second half of the script will them compare the potential pairs by sequence. 
5) select_for_qfit.py This script will subset down your pairs to a list of only one apo structure for every holo structure.


Other scripts in this directory:

1) submission script: This was used to organized/submit jobs to the Wynton server so we could go through multiple holo PDBs at the same time.
 
