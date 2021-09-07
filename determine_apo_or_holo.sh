#!/bin/bash

'''
This script will go through the PDB database that sits on the Wynton server and classify ligands in holo or apo based on the largest ligand found. 
The script is set up to be run through a wrapper script (_______).
Input: PDB line
Output: List of potential holo and apo structures
'''
#________________________________________________SET PATHS________________________________________________#
source /wynton/home/fraserlab/swankowicz/phenix-installer-dev-3594-intel-linux-2.6-x86_64-centos6/phenix-dev-3594/phenix_env.sh
export PATH="/wynton/home/fraserlab/swankowicz/anaconda3/bin:$PATH"
source activate qfit

line=$1
mid=$(echo ${line:1:2} | tr '[:upper:]' '[:lower:]')
line=$(echo ${line} | tr '[:upper:]' '[:lower:]')
echo $line
   
if [[ ! -e /wynton/group/fraser/swankowicz/mtz/191114/${line}.dump  ]]; then
    echo 'no mtz'
    echo $line >> /wynton/group/fraser/swankowicz/nomtz_111419.txt
else
    if [[ -e /netapp/database/pdb/remediated/pdb/${mid}/pdb${line}.ent.gz ]]; then #folder where the PDB is located as of 12/19
       find_largest_lig /netapp/database/pdb/remediated/pdb/${mid}/pdb${line}.ent.gz $line #qFit activated script. Will determine if there is a ligand with >10 heavy atoms that should be considered a ligand of interest.
       lig_name=$(cat ${line}_ligand_name.txt)
       if [ ! -z "$lig_name" ]; then
            echo 'has ligand!'
            echo $lig_name
            echo $line >> /wynton/group/fraser/swankowicz/PDB_2A_res_w_lig_111419.txt
            echo $lig_name >> /wynton/group/fraser/swankowicz/PDB_2A_lig_name_111419.txt
       else
            echo $line >> /wynton/group/fraser/swankowicz/PDB_2A_res_w_lig_111419_apo.txt 
       fi
        
    else
        echo $line >> /wynton/group/fraser/swankowicz/no_pdb_111419.txt
      fi
   fi
