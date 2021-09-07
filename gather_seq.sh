file=/wynton/group/fraser/swankowicz/holo.txt
for line in $(cat $file); do
   echo $line
   SEQ1=$(python /wynton/group/fraser/swankowicz/selecting_apo_holo/get_seq.py /wynton/group/fraser/swankowicz/AWS_refine_done/${line}/${line}.pdb)
   echo $SEQ1
   echo "> ${line}" >> /wynton/group/fraser/swankowicz/sequences_holo.txt
   echo $SEQ1 >> /wynton/group/fraser/swankowicz/sequences_holo.txt
done
