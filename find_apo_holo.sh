#!/bin/bash
#$ -l h_vmem=8G
#$ -l mem_free=8G
#$ -t 1-1
#$ -l h_rt=100:00:00
#$ -R yes
#$ -V

#source /wynton/home/fraserlab/swankowicz/phenix-installer-dev-3594-intel-linux-2.6-x86_64-centos6/phenix-dev-3594/phenix_env.sh
#export PATH="/wynton/home/fraserlab/swankowicz/anaconda3/bin:$PATH"
#source activate qfit3
#which python

file=/wynton/group/fraser/swankowicz/apo_done2.txt
for i in {2..1268}; do
      line=$(cat $file | awk '{ print $1 }' |head -n $i | tail -n 1)
      echo ${line}
      if [ -f /wynton/group/fraser/swankowicz/AWS_refine_done/${line}/${line}_qFit.pdb ]; then
         #echo $line >> /wynton/group/fraser/swankowicz/nomtz_191123.t
         RESO1=$(grep ${line} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | head -n 1 | awk '{print $2}')
         SPACE1=$(grep ${line} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | head -n 1 | awk '{print $3}')
         RESO1_lower=$(echo ${RESO1}-0.1 | bc -l)
         RESO1_upper=$(echo ${RESO1}+0.1 | bc -l)
         UNIT1=$(grep ${line} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | tail -n 1 | sed "s/[(),]//g" | awk '{print $4,$5,$6,$7,$8,$9}')
         UNIT1_out=$UNIT1
         UNIT1=( $UNIT1 )
         UNIT1_0_lower=$(echo ${UNIT1[0]}-1 | bc -l)
         UNIT1_0_upper=$(echo ${UNIT1[0]}+1 | bc -l)

         UNIT1_1_lower=$(echo ${UNIT1[1]}-1 | bc -l)
         UNIT1_1_upper=$(echo ${UNIT1[1]}+1 | bc -l)

         UNIT1_2_lower=$(echo ${UNIT1[2]}-1 | bc -l)
         UNIT1_2_upper=$(echo ${UNIT1[2]}+1 | bc -l)

         UNIT1_3_lower=$(echo ${UNIT1[3]}-1 | bc -l)
         UNIT1_3_upper=$(echo ${UNIT1[3]}+1 | bc -l)

         UNIT1_4_lower=$(echo ${UNIT1[4]}-1 | bc -l)
         UNIT1_4_upper=$(echo ${UNIT1[4]}+1 | bc -l)

         UNIT1_5_lower=$(echo ${UNIT1[5]}-1 | bc -l)
         UNIT1_5_upper=$(echo ${UNIT1[5]}+1 | bc -l)
   file2=/wynton/group/fraser/swankowicz/apo_done2.txt
   for line2 in $(cat $file2); do
      #echo ${line2}
      if [ -f /wynton/group/fraser/swankowicz/AWS_refine_done/${line2}/${line2}_qFit.pdb ]; then
         #echo $line2 
         RESO2=$(grep ${line2} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | head -n 1 | awk '{print $2}')
         SPACE2=$(grep ${line2} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | head -n 1 | awk '{print $3}')
         if (( `echo ${RESO2}'<='${RESO1_upper} | bc` )) && (( `echo ${RESO2}'>='${RESO1_lower} | bc` )); then
           if [ $SPACE1 == $SPACE2 ]; then
             UNIT2=$(grep ${line2} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | tail -n 1 | sed "s/[(),]//g" | awk '{print $4,$5,$6,$7,$8,$9}')
             UNIT2=( $UNIT2 )
             if (( $(echo "${UNIT2[0]} <= ${UNIT1_0_upper}" |bc -l) )) && (( $(echo "${UNIT2[0]} >= ${UNIT1_0_lower}" |bc -l) )) && (( $(echo "${UNIT2[1]} <= ${UNIT1_1_upper}" |bc -l) )) && (( $(echo "${UNIT2[1]} >= ${UNIT1_1_lower}" |bc -l) )) && (( $(echo "${UNIT2[2]} <= ${UNIT1_2_upper}" |bc -l) )) && (( $(echo "${UNIT2[2]} >= ${UNIT1_2_lower}" |bc -l) )); then
                echo 'pair1' 
                if (( $(echo "${UNIT2[3]} <= ${UNIT1_3_upper}"|bc -l) )) && (( $(echo "${UNIT2[3]} >= ${UNIT1_3_lower}" |bc -l) )) && (( $(echo "${UNIT2[4]} <= ${UNIT1_4_upper}" |bc -l) )) && (( $(echo "${UNIT2[4]} >= ${UNIT1_4_lower}" |bc -l) )) &&  (( $(echo "${UNIT2[5]} <= ${UNIT1_5_upper}" |bc -l) )) && (( $(echo "${UNIT2[5]} >= ${UNIT1_5_lower}" |bc -l) )); then
                   echo 'pair2'
                   echo ${line2} >> /wynton/group/fraser/swankowicz/apo_pairs/${line}_potential_pairs.txt
                fi
             fi
           fi
         fi
       fi
   done
   SEQ1=$(~/anaconda3/envs/qfit3/bin/python /wynton/group/fraser/swankowicz/selecting_apo_holo/get_seq.py /wynton/group/fraser/swankowicz/AWS_refine_done/${line}/${line}_qFit.pdb)
   file3=/wynton/group/fraser/swankowicz/apo_pairs/${line}_potential_pairs.txt
   for line2 in $(cat $file3); do
       echo $line2
       if [ ! -f /wynton/group/fraser/swankowicz/AWS_refine_done/${line}/${line}_qFit.pdb ]; then
          echo 'not found'
          continue
       fi
       RESO2=$(grep ${line2} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | head -n 1 | awk '{print $2}')
       UNIT2=$(grep ${line2} /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt | tail -n 1 | sed "s/[(),]//g" | awk '{print $4,$5,$6,$7,$8,$9}')
       SEQ2=$(~/anaconda3/envs/qfit3/bin/python /wynton/group/fraser/swankowicz/selecting_apo_holo/get_seq.py /wynton/group/fraser/swankowicz/AWS_refine_done/${line}/${line}_qFit.pdb)
                if [[ -z ${SEQ1} ]]; then
                    echo 'no seq1'
                    continue
                elif [[ -z ${SEQ2} ]]; then
                   echo 'no seq2'
                   continue
                else
                   #echo $SEQ2
                   if [ "$SEQ1" = "$SEQ2" ]; then
                     echo 'pair'
                     #echo $line
                     #echo $SEQ1
                     #echo $line2
                     #echo $SEQ2
                     echo $line $line2 $RESO1 $RESO2 >> /wynton/group/fraser/swankowicz/apo_pairs.txt
                   else
                     SEQ1_end5=${SEQ1:-5}
                     SEQ2_end5=${SEQ2:-5}
                     SEQ1_begin5=${SEQ1:5}
                     SEQ2_begin5=${SEQ2:5}
                     if [ "$SEQ1" = "$SEQ2_begin5" ] || [ "$SEQ1" = "$SEQ2_end5" ] || [ "$SEQ2" = "$SEQ1_end5" ] || [ "$SEQ2" = "$SEQ1_begin5" ]; then
                       #echo 'pair'
                       echo $line $line2 $RESO1 $RESO2 >> /wynton/group/fraser/swankowicz/apo_pairs.txt
                     fi
                   fi
              fi
   done
  fi
done
    
