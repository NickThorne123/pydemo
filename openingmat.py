# This script opens a cell from within a .mat file and formats it as a pandas dataframe

from scipy.io import loadmat
import pandas as pd
import numpy as np
import h5py
datadir = '/Users/carolineharbison/Desktop/GitHub/pydemo/Participant_data/data/Test'

# create a list of all the subject numbers
nums = range(4,34)
subjects = [f"S{x}" for x in nums if x != 10]
# For loop to get the age of each subject then compile them into a dataframe
# Some of the .mat files are in hdf format so can't be opened with scipy, this code gets
# around that
age_data_list = []
gender_data_list = []
for subject in subjects:
    filename = f'{datadir}/{subject}_MDSLTest_B1.mat'
    try:
        with h5py.File(filename,'r') as f:
            age_data = f['data']['individual']['age'][:]
            age_data_list.append(age_data)
            gender = f['data']['individual']['jender'][()]
            extracted_gender = chr(gender.item())
            gender_data_list.append(extracted_gender)
    except OSError:
        data = loadmat(filename)
        age = data['data'][0,0]['individual'][0,0]['age']
        age_data_list.append(age)
        gender = data['data'][0,0]['individual'][0,0]['jender']
        gender_data_list.append(gender)
age_data_list = [int(arr.astype(float)[0,0]) for arr in age_data_list]
gender_data_list = [x.item() if isinstance(x, np.ndarray) else x for x in gender_data_list]
print(gender_data_list)
demographics = pd.DataFrame({'gender': gender_data_list, 'age': age_data_list})
age_stats=demographics['age'].describe()
gender_stats=demographics['gender'].describe()
print(demographics)
print(age_stats)
print(gender_stats)

# # First create table of output measures
# output = S1_test['data'][0,0]['output_test']
# output_df = pd.DataFrame(output, columns = ['domain', 'col2','ind1','ind2','col5','firstChar','col7','col8','col9','col10','col11','col12','chosenChar','col14','col15','col16','col17'])
# output_df = output_df[['domain', 'ind1', 'ind2', 'firstChar', 'chosenChar']]
# output_table = output_df.to_string(index=False)
# print(output_table)

# # Then a table of outcome (what character they chose versus the correct answer)
# outcome = S1_test['data'][0,0]['outcome']
# outcome_df = pd.DataFrame(outcome, columns = ['choice', 'answer'])
# outcome_table = outcome_df.to_string(index=False)
# print(outcome_table)

# # Then a table of the attributes of the 7 characters in each of the 3 domains

# atts = S1_test['data'][0,0]['atts']
# atts_df = pd.DataFrame(atts, columns = ['char1','char2','char3','char4','char5','char6','char7'])
# atts_table = atts_df.to_string(index=True)
# print(atts_table)

# age = S12_test['data'][0,0]['individual']
# print(age)


# subjects = range(2,34)
# for subject in subjects:
#     age = _test['data'][0,0]['individual'][0,0]['age']
