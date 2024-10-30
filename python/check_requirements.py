import subprocess

# List of required packages
required_packages = [
    'os',
    'sys',
    'vtk',
    'vtk.numpy_interface',
    'numpy',
    'scipy',
    'h5py',
    'multiprocessing',
    'matplotlib.pyplot',
    'scipy.io',
    'pandas',
    'mpl_toolkits.mplot3d',
    'scipy.ndimage',
    'mpl_toolkits.mplot3d.art3d'    
]

# Check and install packages
for package in required_packages:
    try:
        __import__(package)
        print(f"{package} is already installed.")
    except ImportError:
        #print(f"{package} is not installed. Installing...")
        subprocess.run(['pip', 'install', package])

print("All required packages are installed.")
