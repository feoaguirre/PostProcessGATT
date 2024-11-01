import numpy as np
import pandas as pd
import os

def loadlog(name=None):
    print('load logs')
    
    if name is None:
        rawdata = pd.read_csv('log.txt', delim_whitespace=True, header=None)
    else:
        rawdata = pd.read_csv(name, delim_whitespace=True, header=None)
       
    data = rawdata.values
    log = {}
    log['saveNumber'] = data[:, 0]
    log['iter'] = data[:, 1]
    log['t'] = data[:, 2]
    log['dt'] = data[:, 3]
    log['cfl'] = data[:, 4]
    log['res'] = data[:, 5:10]
    log['U'] = data[:, 10::5]
    log['V'] = data[:, 11::5]
    log['W'] = data[:, 12::5]
    log['R'] = data[:, 13::5]
    log['E'] = data[:, 14::5]

    return log