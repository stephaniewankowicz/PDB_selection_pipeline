#!/bin/bash
#Stephanie Wankowicz
#https://stephaniewankowicz.github.io/
#Fraser Lab UCSF

#This script takes in a list of PDB IDs, downloads the PDBs/MTZ files, extract crystallographic information, and extract sequence information.
# The folder structures for the PDBs will be /base_folder/PDB_ID/.

#____________________________________________SOURCE REQUIREMENTS____________________________________
source phenix_env.sh #source phenix (fill in phenix location)
source activate qfit #conda env with qFit 

#________________________________________________INPUTS________________________________________________
base_folder='/wynton/group/fraser/swankowicz/191227_qfit/' #base folder (where you want to put folders/pdb files
pdb_filelist=/wynton/group/fraser/swankowicz/script/comp_omit4.txt

#_________________________________________DOWNLOAD PDB/MTZ FILES AND CREATE FOLDERS_________________________
while read -r line; do
  PDB=$line
  cd $base_folder
  if [ -d "/$PDB" ]; then
    echo "Folder exists." 
  else
    mkdir ${PDB}
  fi
  cd ${PDB}
  wget https://files.rcsb.org/download/${PDB}.pdb
  wget https://files.rcsb.org/download/${PDB}-sf.cif
  wget http://edmaps.rcsb.org/coefficients/${PDB}.mtz


#____________________________________RUN MTZ DUMP & EXTRACT CRYSTALLOGRAPHIC INFO____________________________
  phenix.cif_as_mtz ${PDB}_ --ignore_bad_sigmas --extend_flags --merge #transfer cif into mtz file
  phenix.mtz.dump $PDB.mtz > /wynton/group/fraser/swankowicz/mtz/191114/mtz_dump/${pdb}.dump #run mtz dump

#__________________________________________DETERMINE HOLO OR APO___________________________________________
  find_largest_lig ${PDB}.pdb ${PDB}
  lig_name=$(cat ${PDB}_ligand_name.txt)
  if [ ! = ${lig_name} ]; then
      echo ${PDB} ${lig_name} >> PDB_Holo.txt.  #PDB has ligand that is considered a potential 'holo'
  else
      echo ${PDB} >> PDB_Apo.txt #PDB is considered apo.
  fi
done < $file
