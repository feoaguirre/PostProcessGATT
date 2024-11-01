import numpy as np
import scipy.io
import matplotlib.pyplot as plt

# Load parameters and variables
# Assuming 'parameters' is a script that sets some variables; in Python, you would manually define them.
# For example:
# parameters = {...}  # Define your parameters here

# Load mesh and mean flow data
mesh = scipy.io.loadmat('mesh.mat')
meanflow = scipy.io.loadmat('flow_mean.mat')

# Find the index of the closest value to xEnd in mesh.X
xEnd = ...  # Define xEnd as needed
xind_end = np.argmin(np.abs(mesh['X'].flatten() - xEnd))

# Calculate mean U and mean R
meanU = np.nanmean(meanflow['U'], axis=2)
meanR = np.nanmean(meanflow['R'], axis=2)
meanU[np.isnan(meanU)] = 0
meanR[np.isnan(meanR)] = 0

# Calculate delta
Delta = np.zeros(len(mesh['X'].flatten()))
Deltai = np.zeros(len(mesh['X'].flatten()), dtype=int)

for i in range(len(mesh['X'].flatten())):
    for j in range(48, len(mesh['Y'].flatten())):
        if abs(meanU[i, j] - 1) <= 1e-3:
            Deltai[i] = j
            Delta[i] = mesh['Y'][0, j]  # Assuming mesh.Y is a 2D array
            break

for i in range(len(mesh['X'].flatten())):
    if Delta[i] == 0 and i > 0:
        Delta[i] = Delta[i - 1]

# Calculate delta star
Delta1 = np.zeros(len(mesh['X'].flatten()))
for i in range(len(mesh['X'].flatten())):
    Delta1[i] = np.trapz(1 - (meanR[i, 38:Deltai[i]] * meanU[i, 38:Deltai[i]]) / (1.002 * 1.002), mesh['Y'][0, 38:Deltai[i]])

# Calculate theta
Delta2 = np.zeros(len(mesh['X'].flatten()))
for i in range(len(mesh['X'].flatten())):
    Delta2[i] = np.trapz((1 - (meanU[i, 38:Deltai[i]] / 1.002)) * (meanR[i, 38:Deltai[i]] * meanU[i, 38:Deltai[i]] / (1.002 * 1.002)), mesh['Y'][0, 38:Deltai[i]])

# Find shape factor
H = Delta1 / Delta2

# Plotting
plt.figure()
plt.plot(mesh['X'][0:xind_end].flatten() - mesh['flowType'][0, 0]['cav'][0, 0][1][0][0], H[0:xind_end], 'b--')
fe = 800 - mesh['flowType'][0, 0]['cav'][0, 0][1][0][0]
plt.grid(True)
plt.axhline(y=2.59, color='r', linestyle='-')
plt.axhline(y=1.4, color='g', linestyle='-')
plt.axvline(x=mesh['flowType'][0, 0]['cav'][0, 0][1][0][0], color='k', linestyle='--')
plt.axvline(x=mesh['flowType'][0, 0]['cav'][0, 0][0][0][0], color='k', linestyle='--')
plt.xlim([0, 540])
plt.ylim([1.0, 3.5])
plt.xlabel('X')
plt.ylabel('Shape Factor')
plt.legend(['Shape factor case A', 'Blasius Shape Factor', 'Typical turbulent Shape Factor', 'Trailing edge case B', 'Leading edge case B'])
plt.show()