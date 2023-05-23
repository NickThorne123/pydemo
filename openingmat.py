# %%
# This script opens a cell from within a .mat file and formats it as a pandas dataframe

from scipy.io import loadmat
import pandas as pd
import numpy as np
import h5py
import matplotlib.pyplot as plt
datadir = '/Users/carolineharbison/Desktop/GitHub/pydemo/Participant_data/data/Test'

# create a list of all the subject numbers
nums = range(2,34)
subjects = [f"S{x}" for x in nums if x != 10]
blocks = range(1,4)
# For loop to get the age of each subject then compile them into a dataframe
# Some of the .mat files are in hdf format so can't be opened with scipy, this code gets
# around that
# age_data_list = []
# gender_data_list = []
# for subject in subjects:
#     filename = f'{datadir}/{subject}_MDSLTest_B1.mat'
#     try:
#         with h5py.File(filename,'r') as f:
#             age_data = f['data']['individual']['age'][:]
#             age_data_list.append(age_data)
#             gender = f['data']['individual']['jender'][()]
#             extracted_gender = chr(gender.item())
#             gender_data_list.append(extracted_gender)
#     except OSError:
#         data = loadmat(filename)
#         age = data['data'][0,0]['individual'][0,0]['age']
#         age_data_list.append(age)
#         gender = data['data'][0,0]['individual'][0,0]['jender']
#         gender_data_list.append(gender)
# age_data_list = [int(arr.astype(float)[0,0]) for arr in age_data_list]
# gender_data_list = [x.item() if isinstance(x, np.ndarray) else x for x in gender_data_list]
# print(gender_data_list)
# demographics = pd.DataFrame({'gender': gender_data_list, 'age': age_data_list})
# age_stats=demographics['age'].describe()
# gender_stats=demographics['gender'].describe()
# print(demographics)
# demographics.hist(column='age')



# First create a table of outcome (what character they chose versus the correct answer) for each participant
# then find out what percentage correct each participant had
# then finally figure out the overall accuracy of the participants for each block.

outcome_dfs = []
for subject in subjects:
    for block in blocks:
        filename = f'{datadir}/{subject}_MDSLTest_B{block}.mat'
        try:
            with h5py.File(filename,'r') as f:
                outcome_data = f['data']['outcome'][:]
                df = pd.DataFrame(outcome_data)
                df = df.T
                # df['Subject'] = subject
                # df['Block'] = block
                # outcome_dfs.append(df)
                
        except OSError:
            data = loadmat(filename)
            outcome = data['data'][0,0]['outcome']
            df = pd.DataFrame(outcome)
        df['Subject'] = subject
        df['Block'] = block
        outcome_dfs.append(df) 
combined_outcome = pd.concat(outcome_dfs, ignore_index = True)
print(combined_outcome)       



# for i, df in enumerate(outcome_dfs):
#     print(f"Dataframe {i + 1}:")
#     print(df)
#     print("\n")
    


# output = S5_test['data'][0,0]['output_test']
# output_df = pd.DataFrame(output, columns = ['domain', 'col2','ind1','ind2','col5','firstChar','col7','col8','col9','col10','col11','col12','chosenChar','col14','col15','col16','col17'])
# output_df = output_df[['domain', 'ind1', 'ind2', 'firstChar', 'chosenChar']]
# output_table = output_df.to_string(index=False)
# print(output_table)




# # Then a table of the attributes of the 7 characters in each of the 3 domains

# atts = S5_test['data'][0,0]['atts']
# atts_df = pd.DataFrame(atts, columns = ['char1','char2','char3','char4','char5','char6','char7'])
# atts_table = atts_df.to_string(index=True)
# print(atts_table)


# %%
