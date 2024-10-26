# PostProcessGATT

This repository is a collection of functions that may be useful to new GATT USP students.

It contains the following structure: Matlab folder, Python folder, and Labview folder, all of which have the respective format functions.

# Matlab folder, functions:

# view2D.m: 
    Simple example for plotting a two-dimensional variable of the flow. This file loads the mesh and the flow for plotting the variable.

# loadlog.m:
    Loads the log file of the simulation and returns the time and the values of the variables with all the probes.

# plotmesh.m:
    Plots the mesh of the simulation.

# volumecontour.m:
    Plot a series of surfaces to generate a three-dimensional volumetric plot.

# posprocvars.m:
    Postprocesses the variables of the simulation. It loads the flow file and the mesh, computing Q criterium, Lambda 2, Dilatation, Mach, Pressure, Temperature, and Vorticity. After appending to the original flow.

# meanflow_analises_x.m:
    Check the mean flow in the X direction.
    
# meanflow_analises_z.m:
    Check the mean flow in the Z direction.    

# meanflow_baseflow_compare.m:
    Check the mean flow and compare with the base flow.

# prob_analise.m
    Used to check and analyze the probs in the log.txt.

# shapefactor.m
    Shape factor calculate.

# plotlogs.m 
    Similar to loadlog, but used to plot the probs.

# walllaw.m
    Check the law of the wall.

# cf.m 
    Check the  Coefficient of Friction.
