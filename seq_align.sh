#!/bin/bash

PDB_file=/wynton/group/fraser/swankowicz/script/text_files/qfit_pairs_191218.txt #list of PDB IDs
basedir='/wynton/group/fraser/swankowicz/AWS_refine_done' #location of PDBs

for i in {2..1268}; do
   holo=$(cat $PDB_file | awk '{ print $1 }' |head -n $i | tail -n 1)
   apo=$(cat $PDB_file | awk '{ print $2 }' | head -n $i | tail -n 1)
   SEQ1=$(python /wynton/group/fraser/swankowicz/selecting_apo_holo/get_seq.py ${basedir}/${holo}/${holo}.pdb)
   SEQ2=$(python /wynton/group/fraser/swankowicz/selecting_apo_holo/get_seq.py ${basedir}/${apo}/${apo}.pdb)
   if [ "$SEQ1" = "$SEQ2" ]; then
      echo $holo $apo >> /wynton/group/fraser/swankowicz/perfect_seq_pair.txt 
   else #if there was not an exact sequence match, we compared the sequence with 5 bases remvoed at either end. 
         SEQ1_end5=${SEQ1:-5}
         SEQ2_end5=${SEQ2:-5}
         SEQ1_begin5=${SEQ1:5}
         SEQ2_begin5=${SEQ2:5}
         if [ "$SEQ1" = "$SEQ2_begin5" ]; then
            echo $holo $apo >> /wynton/group/fraser/swankowicz/not_perfect_seq_pair.txt
         elif [ "$SEQ1" = "$SEQ2_end5" ]; then
            echo $holo $apo >> /wynton/group/fraser/swankowicz/not_perfect_seq_pair.txt
         elif [ "$SEQ2" = "$SEQ1_end5" ]; then
            echo $holo $apo >> /wynton/group/fraser/swankowicz/not_perfect_seq_pair.txt
         elif [ "$SEQ2" = "$SEQ1_begin5" ]; then
             echo $holo $apo >> /wynton/group/fraser/swankowicz/not_perfect_seq_pair.txt
         fi
   fi
done
