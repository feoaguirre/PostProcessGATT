import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.ndimage import zoom
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

#necessary: pip install numpy matplotlib scikit-image

def volume_contour(x, y, z, V, n=5, vmin=None, vmax=None):
    flip = 1
    alpha = 0.5

    # Permute V to match the desired dimensions
    V = np.transpose(V, (1, 0, 2))

    if len(n) > 1:
        levels = n
        n = len(n)
    else:
        if vmin is None or vmax is None:
            vmin = np.min(V)
            vmax = np.max(V)
        levels = np.linspace(vmin, vmax, n + 2)[1:-1]  # Exclude the first and last levels

    colors = plt.cm.viridis(np.linspace(0, 1, n))  # Use viridis colormap

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.set_box_aspect([1, 1, 1])  # Equal aspect ratio

    for i in range(n):
        if flip == 0:
            # Create the isosurface
            verts, faces, _, _ = measure.marching_cubes(V, levels[i])
        else:
            # Permute dimensions for the isosurface
            verts, faces, _, _ = measure.marching_cubes(np.transpose(V, (2, 1, 0)), levels[i])

        # Create a Poly3DCollection
        poly3d = Poly3DCollection(verts[faces], facecolors=colors[i], alpha=alpha, linewidths=0, edgecolors='none')
        ax.add_collection3d(poly3d)

    ax.set_xlabel('X axis')
    ax.set_ylabel('Y axis')
    ax.set_zlabel('Z axis')
    plt.show()

    return poly3d