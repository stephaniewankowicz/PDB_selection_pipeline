#!/bin/bash

'''
This script take each PDB, go into the folder where the MTZ file is and run mtz.dump so we can extract information about the space group, unit cell, and resolution from the mtz file.

INPUT: List of PDB IDs (one per line)
OUTPUT: MTZ.dump files
'''

source /wynton/home/fraserlab/swankowicz/phenix-installer-dev-3594-intel-linux-2.6-x86_64-centos6/phenix-dev-3594/phenix_env.sh #source phenix

file=/wynton/group/fraser/swankowicz/PDB_ids.txt #list of PDB IDs
while read -r line; do
      line=$1
      pdb=$(echo ${line} | tr '[:upper:]' '[:lower:]')
      mid=$(echo ${pdb:1:2})
      echo $pdb
      echo $mid
      cp /netapp/database/pdb/remediated/structure_factors/${mid}/r${pdb}sf.ent.gz /wynton/group/fraser/swankowicz/mtz/191114/ #move MTZ file to my folder
      cd /wynton/group/fraser/swankowicz/mtz/191114/
      phenix.cif_as_mtz r${pdb}sf.ent.gz --ignore_bad_sigmas --extend_flags --merge #transfer cif into mtz file
      phenix.mtz.dump r${pdb}sf.mtz > /wynton/group/fraser/swankowicz/mtz/191114/mtz_dump/${pdb}.dump #run mtz dummp
      #fi
done < $file
