# This script opens a cell from within a .mat file and formats it as a pandas dataframe

from scipy.io import loadmat
import pandas as pd

S1_test = loadmat('/Users/carolineharbison/Desktop/GitHub/pydemo/Participant_data/data/Test/S1_MDSLTest_B1.mat')

# First create table of outcome measures
output = S1_test['data'][0,0]['output_test']
output_df = pd.DataFrame(output, columns = ['domain', 'col2','ind1','ind2','col5','firstChar','col7','col8','col9','col10','col11','col12','chosenChar','col14','col15','col16','col17'])
output_df = output_df[['domain', 'ind1', 'ind2', 'firstChar', 'chosenChar']]
output_table = output_df.to_string(index=False)
print(output_table)

# Then a table of outcome (what character they chose versus the correct answer)
outcome = S1_test['data'][0,0]['outcome']
outcome_df = pd.DataFrame(outcome, columns = ['choice', 'answer'])
outcome_table = outcome_df.to_string(index=False)
print(outcome_table)

# Then a table of the attributes of the 7 characters in each of the 3 domains

atts = S1_test['data'][0,0]['atts']
atts_df = pd.DataFrame(atts, columns = ['char1','char2','char3','char4','char5','char6','char7'])
atts_table = atts_df.to_string(index=True)
print(atts_table)