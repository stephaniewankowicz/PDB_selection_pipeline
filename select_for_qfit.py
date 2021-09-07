'''
This script will determine the apo structure closest in resolution to the holo structure of interest. 
Input: Original list of PDBs along with the resolution
Output: Final list of PDBs selecting the structures with the closest resolution. 
'''

import pandas as pd

data = pd.read_csv('/wynton/group/fraser/swankowicz/PDB_pairs_191202.txt', sep=" ", header=None)
data.columns = ['holo', 'apo', 'holo_res', 'apo_res']
data['res_diff'] = data['holo_res'] - data['apo_res']

final_df = pd.DataFrame()
for i in data['holo'].unique():
   #print(i)
   subset = (data.loc[data['holo'] == i])
   i2 = subset['res_diff'].min()
   subset2 = (subset.loc[subset['res_diff'] == i2])
   final_df = final_df.append(subset2)

final_df.to_csv('qfit_pairs_191229_final.txt', sep='\t', index=False)

