import numpy as np
import scipy
import h5py
import os

import vtk
from vtk.numpy_interface import algorithms as algs
from vtk.numpy_interface import dataset_adapter as dsa

""" Computes a meanflow from a series of flow files - useful to compute fluctuations later """

# COMPUTE MEANFLOW ####################

# Set s
s = 0

print('Started s = {:.1f}'.format(s))

# Directory
directory = os.path.join(r"D:\IC\ETAPA_6","3D_Ma0.5_Re734_T300_D6_L12_step{}".format(s))

# List files inside the folder
flows_list = list()
for file in os.listdir(directory):
    if file.startswith('flow') and file.endswith('.mat'):
        flows_list.append(file)
    elif file.startswith('mesh') and file.endswith('.mat'):
        mesh = scipy.io.loadmat(os.path.join(directory,file))

# Extract mesh data
x = np.array(mesh['X'][0],dtype=np.float64)
y = np.array(mesh['Y'][0],dtype=np.float64)
z = np.array(mesh['Z'][0],dtype=np.float64)
X, Y, Z = np.meshgrid(x, y, z, indexing='ij')
wall = np.array(mesh['wall'])

# Initialize meanflow variables
U = np.zeros_like(X)
V = np.zeros_like(X)
W = np.zeros_like(X)
R = np.zeros_like(X)
E = np.zeros_like(X)

print('Starting meanflow calculation...')
print('Progress = 0 %')

# Compute mean variables
for file in flows_list:
    data = h5py.File(os.path.join(directory, file))
    U = U + np.array(data['U']).transpose((2, 1, 0))
    V = V + np.array(data['V']).transpose((2, 1, 0))
    W = W + np.array(data['W']).transpose((2, 1, 0))
    E = E + np.array(data['E']).transpose((2, 1, 0))
    R = R + np.array(data['R']).transpose((2, 1, 0))
    print('Progress = {:.0f} %'.format(100*(flows_list.index(file)+1) / len(flows_list)))

U = U/len(flows_list)
V = V/len(flows_list)
W = W/len(flows_list)
E = E/len(flows_list)
R = R/len(flows_list)

# Save meanflow file as .mat
scipy.io.savemat(os.path.join(directory,'meanflow.mat'), {'U': U, 'V': V, 'W': W, 'E': E, 'R': R})

print('Saved MAT file: {}'.format(os.path.join(directory,'meanflow.mat')))

make_vtk = False

if make_vtk == True:
    # Set display interval for vtk file
    x_start = np.abs(x - 243).argmin()
    x_end = np.abs(x - 400).argmin()
    y_start = np.abs(y + 6).argmin()
    y_end = np.abs(y - 8).argmin()
    z_start = np.abs(z + 20).argmin()
    z_end = np.abs(z - 20).argmin()

    x_factor = 1
    y_factor = 1
    z_factor = 1

    x = x[x_start:x_end][::x_factor]
    y = y[y_start:y_end][::y_factor]
    z = z[z_start:z_end][::z_factor]

    wall = np.array(wall)[x_start:x_end,y_start:y_end,z_start:z_end][::x_factor,::y_factor,::z_factor]

    U = U[x_start:x_end,y_start:y_end,z_start:z_end][::x_factor,::y_factor,::z_factor]
    V = V[x_start:x_end,y_start:y_end,z_start:z_end][::x_factor,::y_factor,::z_factor]
    W = W[x_start:x_end,y_start:y_end,z_start:z_end][::x_factor,::y_factor,::z_factor]

    U[np.isnan(U)] = 0
    V[np.isnan(V)] = 0
    W[np.isnan(W)] = 0

    ## PART 1

    # Create object vtkRectilinearGrid
    my_vtk_dataset = vtk.vtkRectilinearGrid()

    ## CONFIGURE POINTS

    # Set grid dimensions (IMPORTANT)
    my_vtk_dataset.SetDimensions(len(x),len(y),len(z))

    # Transform coordinate vectors into VTK format
    x_vtk = dsa.numpyTovtkDataArray(x)
    y_vtk = dsa.numpyTovtkDataArray(y)
    z_vtk = dsa.numpyTovtkDataArray(z)

    # Set grid coordinates using VTK vectors
    my_vtk_dataset.SetXCoordinates(x_vtk)
    my_vtk_dataset.SetYCoordinates(y_vtk)
    my_vtk_dataset.SetZCoordinates(z_vtk)

    ## CONFIGURE DATA

    # Create vector matrix on VTK format
    vectors = algs.make_vector(U.flatten('F'),
                               V.flatten('F'),
                               W.flatten('F'))

    # Use AddArray to add the data
    my_vtk_dataset.GetPointData().AddArray(dsa.numpyTovtkDataArray(wall.flatten('F'), "wall"))
    my_vtk_dataset.GetPointData().AddArray(dsa.numpyTovtkDataArray(vectors, "Velocity"))
    my_vtk_dataset.GetPointData().AddArray(dsa.numpyTovtkDataArray(U.flatten('F'), "U"))
    my_vtk_dataset.GetPointData().AddArray(dsa.numpyTovtkDataArray(V.flatten('F'), "V"))
    my_vtk_dataset.GetPointData().AddArray(dsa.numpyTovtkDataArray(W.flatten('F'), "W"))

    # Create Writer object to save the VTK file
    writer = vtk.vtkRectilinearGridWriter()
    writer.SetFileName(os.path.join(directory,'meanflow.vtk'))
    writer.SetInputData(my_vtk_dataset)
    writer.Update()
    writer.Write()

    print('Saved VTK file: {}'.format(os.path.join(directory,'meanflow.vtk')))


