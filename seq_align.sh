PDB_file=/wynton/group/fraser/swankowicz/script/text_files/qfit_pairs_191218.txt
basedir='/wynton/group/fraser/swankowicz/AWS_refine_done'
for i in {2..1268}; do
   holo=$(cat $PDB_file | awk '{ print $1 }' |head -n $i | tail -n 1)
   apo=$(cat $PDB_file | awk '{ print $2 }' | head -n $i | tail -n 1)
   SEQ1=$(python /wynton/group/fraser/swankowicz/selecting_apo_holo/get_seq.py ${basedir}/${holo}/${holo}_qFit.pdb)
   SEQ2=$(python /wynton/group/fraser/swankowicz/selecting_apo_holo/get_seq.py ${basedir}/${apo}/${apo}_qFit.pdb)
   echo $SEQ1
   #SEQ1=$(grep ${holo} /wynton/group/fraser/swankowicz/sequences_missed_191226.txt | head -n 1 | awk '{print $2}')
   #SEQ2=$(grep ${holo} /wynton/group/fraser/swankowicz/sequences_missed_191226.txt | head -n 1 | awk '{print $2}')
   if [ "$SEQ1" = "$SEQ2" ]; then
      #echo 'perfect match'
      echo $holo $apo >> /wynton/group/fraser/swankowicz/perfect_seq_pair.txt
   else
         SEQ1_end5=${SEQ1:-5}
         SEQ2_end5=${SEQ2:-5}
         SEQ1_begin5=${SEQ1:5}
         SEQ2_begin5=${SEQ2:5}
         if [ "$SEQ1" = "$SEQ2_begin5" ]; then
            echo 'apo needs to be adjusted'
         elif [ "$SEQ1" = "$SEQ2_end5" ]; then
            echo 'end, nothing needed'
         elif [ "$SEQ2" = "$SEQ1_end5" ]; then
            echo 'end, nothing needed'
         elif [ "$SEQ2" = "$SEQ1_begin5" ]; then
             echo 'holo needs to be adjusted'
         fi
        echo $holo $apo >> /wynton/group/fraser/swankowicz/not_perfect_seq_pair.txt
   fi
done
