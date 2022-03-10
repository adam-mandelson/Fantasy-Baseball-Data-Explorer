'''
Utility functions.
'''

import os
from pathlib import Path


def auth_dir() -> Path:
    '''
    Returns a Path object with the location of the config folder.
    '''
    return Path('./config/')


def data_dir() -> Path:
    '''
    Returns a Path object with the location of the data folder.
    Makes a new one if it doesn't exist.
    '''
    if not os.path.exists('./data/'):
        os.makedirs('./data/')
    return Path('./data/')
