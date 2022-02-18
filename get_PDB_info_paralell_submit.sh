#$ -l mem_free=2G
#$ -t 1-100
#$ -l h_rt=100:00:00
#$ -R yes
#$ -V

#________________________________________________INPUTS________________________________________________
PDB_file=PDB_2A_res.txt
base_folder='/location/you/would/like/folders/of/PDBs/to/exist/'
export OMP_NUM_THREADS=1

#________________________________________________SET DEPENDENCY PATHS__________________________________
source phenix_env.sh
source activate qfit

#________________________________________________RUN SCRIPT____________________________________________
PDB=$(cat $PDB_file | head -n $SGE_TASK_ID | tail -n 1)

sh get_PDB_info ${PDB} ${base_folder}
