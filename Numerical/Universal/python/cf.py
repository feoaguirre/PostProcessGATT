import numpy as np
import matplotlib.pyplot as plt
import scipy.io

def deltal(Rex, X):
    return (4.91 * X[1:]) / np.sqrt(Rex)

def deltat(Rex, X):
    return (0.16 * X[1:]) / (Rex ** (1/7))

def turbbl(Rex):
    return (2 * np.log10(Rex) - 0.65) ** -2.3

def lambl(Rex):
    return 0.664 / np.sqrt(Rex)

def diff4or(index, U, Y):
    return ((-25 * U[:, index] + 48 * U[:, index + 1] - 36 * U[:, index + 2] +
             16 * U[:, index + 3] - 3 * U[:, index + 4]) / (12 * Y[index]))

def diff2or(index, U, Y):
    return ((-3 * U[:, index] + 4 * U[:, index + 1] - U[:, index + 2]) / (2 * Y[index]))

def simpsons(f, a, b, n):
    h = (b - a) / n
    I = h / 3 * (f[0] + 2 * np.sum(f[2:-2:2]) + 4 * np.sum(f[1::2]) + f[-1])
    return I

print('load data')
# Load mesh and flow_mean data

mesh = scipy.io.loadmat('mesh.mat')
X = mesh['X'][0, 0].flatten()
Y = mesh['Y'][0, 0].flatten()

flow_mean = scipy.io.loadmat('flow_mean.mat')
U = flow_mean['U'][0, 0]
V = flow_mean['V'][0, 0]
R = flow_mean['R'][0, 0]
E = flow_mean['E'][0, 0]

# Creating variables PROBABLY HAVE SOME PROBLEMS HERE
xsize = len(X)
ysize = len(Y)
xendcav = flowType.cav[0][1].x[1]  # Adjust indexing for Python
xind_end = np.argmin(np.abs(X - xEnd))
Uinf = 1
mu = 1 / flowParameters.Re
nu = 1 / flowParameters.Re
Ue = 1

Re = X[1:] * Ue / nu
indY = np.where(Y == 0)[0][0] + 1  # Find index of Y=0 and adjust for Python indexing
U = np.mean(U, axis=2)
R = np.mean(R, axis=2)

dudy = diff4or(indY, U, Y)
Cfcalc = (mu * dudy) / (0.5 * R[:, indY] * (Uinf ** 2))

Cfturb = turbbl(Re)
Cflam = lambl(Re)

# Plotting
plt.figure()
plt.plot(X[1:] - flowType.cav[0][1].x[1], Cfturb, 'g', label='turbulent C_f')
plt.plot(X[1:] - flowType.cav[0][1].x[1], Cflam, 'r', label='laminar C_f')
plt.plot(X[81:xind_end], Cfcalc[81:xind_end], 'g-.', label='C_f Large D')
plt.xlim([200, 500])
plt.ylim([0, 0.007])
plt.title(r'$C_f$ comparison across the plate')
plt.legend()
plt.grid()
plt.xlabel(r'$X-X_{endgap}$')
plt.ylabel(r'$C_f$')
plt.show()


