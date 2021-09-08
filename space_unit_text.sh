#!/bin/bash

line=$(echo $1 | tr '[:upper:]' '[:lower:]')
mid=$(echo ${line:1:2})
SPACE1=$(grep "^Space group number from file:" /wynton/group/fraser/swankowicz/mtz/191114/${line}.dump | awk '{print $6,$7}')
UNIT1=$(grep "Unit cell:" /wynton/group/fraser/swankowicz/mtz/191114/${line}.dump | tail -n 1 | sed "s/[(),]//g" | awk '{print $3,$4,$5,$6,$7,$8}')
RESO1=$(grep "^Resolution" /wynton/group/fraser/swankowicz/mtz/191114/${line}.dump | head -n 1 | awk '{print $4}')

echo $line $RESO1 $SPACE1 $UNIT1 >> /wynton/group/fraser/swankowicz/space_unit_reso_191118.txt
