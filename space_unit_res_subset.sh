#!/bin/bash

'''
This script will go through the mtz dump files and extrac out the resolution, space group, and unit cell angles/dimensions and comapre them between the two potential pairs. If everything is within the specific criteria, then the script will output the pair as well as the values stated above into a text file
Input:
Output: 
'''


source /wynton/home/fraserlab/swankowicz/phenix-installer-dev-3594-intel-linux-2.6-x86_64-centos6/phenix-dev-3594/phenix_env.sh
export PATH="/wynton/home/fraserlab/swankowicz/anaconda3/bin:$PATH"
source activate qfit
which python

mtz_dump_dir='/wynton/group/fraser/swankowicz/mtz/mnt/data/u2/wankowicz/mtz_dump/' #location of the mtz dump files

line=$1
mid=$(echo ${line:1:2})
SPACE1=$(grep "^Space group number from file:" ${mtz_dump_dir}/${line}.dump | awk '{print $6,$7}')
UNIT1=$(grep "Unit cell:" ${mtz_dump_dir}/${line}.dump | tail -n 1 | sed "s/[(),]//g" | awk '{print $3,$4,$5,$6,$7,$8}')
RESO1=$(grep "^Resolution" ${mtz_dump_dir}/${line}.dump | head -n 1 | awk '{print $4}')

line2=$2
mid2=$(echo ${line2:1:2})
SPACE2=$(grep "^Space group number from file:" ${mtz_dump_dir}/${line2}.dump | awk '{print $6}')
UNIT2=$(grep "Unit cell:" ${mtz_dump_dir}/${line2}.dump | tail -n 1 | sed "s/[(),]//g" | awk '{print $3,$4,$5,$6,$7,$8}')
RESO2=$(grep "^Resolution" ${mtz_dump_dir}/${line2}.dump | head -n 1 | awk '{print $4}')

RESO1_lower=$(echo ${RESO1}-0.1 | bc -l)
RESO1_upper=$(echo ${RESO1}+0.1 | bc -l)

UNIT1_out=$UNIT1
UNIT2_out=$UNIT2
UNIT1=( $UNIT1 )
UNIT2=( $UNIT2 )

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


if (( `echo ${RESO2}'<='${RESO1_upper} | bc` )) && (( `echo ${RESO2}'>='${RESO1_lower} | bc` )); then #compare resolution
   if [ $SPACE1 == $SPACE2 ]; then #compare space group
      if (( `echo ${UNIT2[3]}'<='${UNIT1_3_upper} | bc` )) && (( `echo ${UNIT2[3]}'>='${UNIT1_3_lower} | bc` )) && (( `echo ${UNIT2[4]}'<='${UNIT1_4_upper} | bc` )) && (( `echo ${UNIT2[4]}'>='${UNIT1_4_lower} | bc` )) && (( `echo ${UNIT2[5]}'<='${UNIT1_5_upper} | bc` )) && (( `echo ${UNIT2[5]}'>='${UNIT1_5_lower} | bc` )); then #compare unit cells
         if (( `echo ${UNIT2[0]}'<='${UNIT1_0_upper} | bc` )) && (( `echo ${UNIT2[0]}'>='${UNIT1_0_lower} | bc` )) && (( `echo ${UNIT2[1]}'<='${UNIT1_1_upper} | bc` )) && (( `echo ${UNIT2[1]}'>='${UNIT1_1_lower} | bc` )) && (( `echo ${UNIT2[2]}'<='${UNIT1_2_upper} | bc` )) && (( `echo ${UNIT2[2]}'>='${UNIT1_2_lower} | bc` )); then #comapre unit cells
            echo $line $line2 $RESO1 $RESO2 $SPACE1 $SPACE2 $UNIT1_out $UNIT2_out >> /wynton/group/fraser/swankowicz/space_unit_out_110619.txt #output file with PDB values, resolution, space groups, and unit cells
         fi
      fi
   fi

fi
