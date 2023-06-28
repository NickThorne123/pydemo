"""
Reads the aggregated data set from the pickle file 
Then egenrates stats using it
"""

from mat_data import Mat_data
import pickle
import pandas as pd

file = open('agg_data.pkl','rb')
agg_data = pickle.load(file)
file.close()

age_data_list = []
gender_data_list = []

for item in agg_data:
    print(item)
    age_data_list.append(item.age)
    gender_data_list.append(item.gender)

demographics = pd.DataFrame({'gender': gender_data_list, 'age': age_data_list})
demographics.hist(column='age')

print('end')


