from scipy.io import loadmat
import numpy as np
import pandas as pd
S1_test = loadmat('/Users/carolineharbison/Desktop/GitHub/pydemo/Participant_data/data/Test/S1_MDSLTest_B1.mat')
output = S1_test['data'][0,0]['output_test']
output_df = pd.DataFrame(output, columns = ['domain', 'col2','ind1','ind2','col5','firstChar','col7','col8','col9','col10','col11','col12','chosenChar','col14','col15','col16','col17'])
output_df = output_df[['domain', 'ind1', 'ind2', 'firstChar', 'chosenChar']]
output_table = output_df.to_string(index=False)
print(output_table)