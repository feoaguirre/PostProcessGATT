import numpy as np
import matplotlib.pyplot as plt
import scipy.io
import os

def diff4or(index, U, Y):
    """Calculate the fourth order derivative."""
    return ((-25 * U[:, index] + 48 * U[:, index + 1] - 36 * U[:, index + 2] + 
             16 * U[:, index + 3] - 3 * U[:, index + 4]) / (12 * Y[index]))

def turbbl(Rex):
    """Calculate turbulent skin friction coefficient."""
    return (2 * np.log10(Rex) - 0.65) ** -2.3

def lambl(Rex):
    """Calculate laminar skin friction coefficient."""
    return 0.664 / np.sqrt(Rex)

def walllaw(xend=None, type='png'):
    # Some types of definitions
    if xend is None:
        xend = 800  # Default value for xend

    # Find mean flow or calculate meanflow
    if not os.path.exists('flow_mean.mat'):
        fi = float(input('fi \n'))
        fe = float(input('fe \n'))
        meanflow(fi, fe)  # You need to implement this function

    timeDelay = 0.5
    print('start plot surf')
    print('load files')

    # Load parameters, mesh, meanflow
    os.chdir('bin')
    parameters = {}  # Load parameters here
    os.chdir('..')

    mesh = scipy.io.loadmat('mesh.mat')
    flow_mean = scipy.io.loadmat('flow_mean.mat')

    # Variables
    print('load vars')
    flowType = flow_mean['flowType']
    x1 = flowType[0, 0]['cav'][0, 0][0][0]
    x2 = flowType[0, 0]['cav'][0, 0][1][0]
    X = mesh['X'].flatten()
    Y = mesh['Y'].flatten()
    
    indx2 = np.argmin(np.abs(X - x2))
    idY = np.where(Y == 0)[0][0]
    idx2 = np.where(X == x2)[0][0]
    idxend = np.where(X == xend)[0][0]
    
    mu = 1 / flow_mean['flowParameters']['Re'][0][0]
    nu = 1 / flow_mean['flowParameters']['Re'][0][0]
    Uinf = 1.0792
    Ue = 1
    Re = X[1:] * Ue / nu
    indY = np.where(Y == 0)[0][0] + 1
    
    U = np.mean(flow_mean['U'], axis=2)
    R = np.mean(flow_mean['R'], axis=2)
    
    dudy = diff4or(indY, U, Y)
    Cfcalc = (mu * dudy) / (0.5 * R[:, indY] * (Uinf ** 2))
    Cfturb = turbbl(Re)
    Cflam = lambl(Re)

    # Calculate law of the wall
    n = 0
    print('start calc law of the wall')

    if type == 'png':
        dtype = [280]
    elif type == 'gif':
        dtype = np.arange(idx2, idxend + 1, 10)

    ymais = []
    umais = []

    for indwall in dtype:
        os.system('cls' if os.name == 'nt' else 'clear')
        ii = np.argmin(np.abs(X - indwall))
        print(f'progress: {n / len(dtype) * 100:.2f}%')
        n += 1
        jjj = 1

        tau_wall = Cfcalc[ii] * 0.5 * R[ii, indY] * (Uinf ** 2)
        Utal = (tau_wall / R[ii, indY]) ** 0.5
        tau_wall_turb = Cfturb[ii] * 0.5 * 1 * (Uinf ** 2)
        Utal_turb = (tau_wall_turb / 1) ** 0.5

        y_row = []
        u_row = []

        for jj in range(idY, 161):
            jjj += 1
            y_row.append((Y[jj] / nu) * Utal)
            u_row.append(U[ii, jj] / (1 * Utal))

        ymais.append(y_row)
        umais.append(u_row)

        if type == 'png':
            plt.figure()
            plt.semilogx(np.abs(ymais[n - 1]), np.abs(umais[n - 1]), '-')
            plt.xlabel('Y+')
            plt.ylabel('U+')
            plt.title(f'Boundary Layer Law of the wall X={X[ii]}')
            plt.legend(['Wall Law short cavity', 'Log Law'], fontsize=12)
            plt.grid(True)
            plt.savefig(f'logboundaryprofile_X={X[ii]}.png')
            plt.close()

        elif type == 'gif':
            gifn = 'law_of_the_wall.gif'
            plt.figure()
            plt.grid(True)
            plt.semilogx(np.abs(ymais[n - 1]), np.abs(umais[n - 1]), '*-')
            plt.xlabel('Y+')
            plt.ylabel('U+')
            plt.title(f'Boundary Layer Law of the wall X={X[ii]}')
            plt.legend(['Log Law Calculated', 'Turbulent Test', 'Log Law Turbulent', 'Log Law Laminar'])
            
            # Capture the plot as an image
            plt.savefig('temp.png')  # Save temporary image
            plt.close()

            # Read the image and convert it to an indexed GIF
            from PIL import Image
            im = Image.open('temp.png')
            im = im.convert('RGBA')
            im = im.convert('P', palette=Image.ADAPTIVE, colors=256)

            if ii == 0:  # First frame
                im.save(gifn, save_all=True, append_images=[], loop=0, duration=int(timeDelay * 1000))
            else:
                im.save(gifn, save_all=True, append_images=[im], loop=0, duration=int(timeDelay * 1000), optimize=True)

    print("Finished processing.")
