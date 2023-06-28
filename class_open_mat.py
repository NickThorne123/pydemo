"""
Iterate over the subjects, 
opening all the mat files and saving into an array of mat_data classes
Save aggregated data set to a pickle file on disk
"""

from scipy.io import loadmat
import pandas as pd
import numpy as np
import h5py
import matplotlib.pyplot as plt
from mat_data import Mat_data
import pickle

datadir = './Participant_data/data/Test'

mat_list = [] # This will be an array/list of all the mat file data
nums = range(2,34)
subjects = [f"S{x}" for x in nums if x != 10]
age_data_list = []
gender_data_list = []


for subject in subjects:
    filename = f'{datadir}/{subject}_MDSLTest_B1.mat'
    try:
        with h5py.File(filename,'r') as f:
            age = f['data']['individual']['age'][:][0][0]
            gender = f['data']['individual']['jender'][()]
            gender = chr(gender.item())
            outcome = np.array(f['data']['outcome'])
            atts = np.array(f['data']['atts'])
            output_test = np.array(f['data']['output_test'])
            print(f'h5py read {filename}')      
            
    except Exception as e:
        data = loadmat(filename)
        age = data['data'][0,0]['individual'][0,0]['age'][0][0]
        gender = data['data'][0,0]['individual'][0,0]['jender']
        outcome = data['data'][0,0]['outcome']
        atts = data['data'][0,0]['atts'] 
        output_test = data['data'][0,0]['output_test'] 
        print(f'loadmat read {filename}')  
         
    mat_item = Mat_data(subject,float(age), gender, atts, outcome, output_test)
    mat_list.append(mat_item)

# write the aggregated data to a file
file = open('agg_data.pkl', 'wb')
pickle.dump(mat_list, file)
file.close()

