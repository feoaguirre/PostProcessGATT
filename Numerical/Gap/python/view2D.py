import numpy as np
import scipy.io
import matplotlib.pyplot as plt

# Load the data
flow_data = scipy.io.loadmat('flow_0000000100.mat')
mesh_data = scipy.io.loadmat('mesh.mat')

# Assuming that the variables X, Y, and U are stored in flow_data and mesh_data
X = mesh_data['X']  # Adjust as necessary
Y = mesh_data['Y']  # Adjust as necessary
U = flow_data['U']  # Adjust as necessary

# Create the figure
plt.figure()
plt.pcolor(X, Y, U.T, shading='interp')  # Transpose U to match the orientation
plt.colorbar()  # Adds a color bar
plt.xlabel('X')
plt.ylabel('Y')
plt.title('U(x,y)')
plt.xlim([0, 500])
plt.ylim([-10, 20])
plt.show()  # Display the generated figure