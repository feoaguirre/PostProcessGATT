# PostProcessGATT

This repository is a collection of functions that may be useful to new GATT USP students.

It contains the following structure: Matlab folder, Python folder, and Labview folder, all of which have the respective format functions.

Necessary programs for the GATT USP students: 

Matlab (2018a or new)

python3

MobaXterm: https://mobaxterm.mobatek.net/

WSL: https://learn.microsoft.com/en-us/windows/wsl/install

Paraview: https://www.paraview.org/download/

Github: https://desktop.github.com/download/

visual studio: https://code.visualstudio.com/

VS extensions: 

Blackbox AI: https://marketplace.visualstudio.com/items?itemName=Blackboxapp.blackbox

Jupyter: https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter

Remote - SSH: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh

Remote Explorer: https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-explorer


# ============  Matlab functions: ============

view2D: 
    
Simple example for plotting a two-dimensional variable of the flow. This file loads the mesh and the flow for plotting the variable.

loadlog:
   
Loads the log file of the simulation and returns the time and the values of the variables with all the probes.

plotmesh:
    
Plots the mesh of the simulation.

volumecontour:
    
Plot a series of surfaces to generate a three-dimensional volumetric plot.

posprocvars:
    
Postprocesses the variables of the simulation. It loads the flow file and the mesh, computing Q criterium, Lambda 2, Dilatation, Mach, Pressure, Temperature, and Vorticity. After appending to the original flow.

meanflow_analises_x:
    
Check the mean flow in the X direction.
    
meanflow_analises_z:
    
Check the mean flow in the Z direction.    

meanflow_baseflow_compare:
    
Check the mean flow and compare it with the base flow.

prob_analise:
    
Used to check and analyze the probs in the log.txt.

shapefactor:
    
Shape factor calculation.

plotlogs:
    
Similar to loadlog, but used to plot the probs.

walllaw:
    
Check the law of the wall.

cf:
    
Check the  Coefficient of Friction.

contourf_physFourierSpace_zt:

Preparation and plot for the two-dimensional spectrum.

plotmodes and plotModesFiltered2:

Preparing and plotting the frequency range in the dataset.

filt_GaussianShape:

Gaussian filter for a frequency band.

specCalc_zt:

Calculation for the two-dimensional spectrum.

Other Matlab specifics functions needed:

Crameri colormap available on: (https://www.fabiocrameri.ch/colourmaps/)

Simpson's rule for numerical integration: https://www.mathworks.com/matlabcentral/fileexchange/25754-simpson-s-rule-for-numerical-integration


# ============  Python functions: ============

check_requirements.py:

Check if all the python dependencies stay installed in the computer.

view2D:

Simple example for plotting a two-dimensional variable of the flow. This file loads the mesh and the flow for plotting the variable.

loadlog:

Loads the log file of the simulation and returns the time and the values of the variables with all the probes.

volumecontour:
    
Plot a series of surfaces to generate a three-dimensional volumetric plot.

shapefactor:
    
Shape factor calculation.

walllaw:
    
Check the law of the wall.

cf:
    
Check the  Coefficient of Friction.


vtkconvert.py:

Read a mat file and create a vtk file for postprocessing on Paraview or similar.

# ========= Acknowledgements ===========

We thank the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior (CAPES)- Programa de Excelência Acadêmica (PROEX) - Brasil, the National Council for Scientific and Technological Development (CNPq), and the US Air Force Office of Scientific Research (AFOSR) for grant FA9550-23-1-0030, managed by Dr. Roger Greenwood and Dr. James Lyke.

