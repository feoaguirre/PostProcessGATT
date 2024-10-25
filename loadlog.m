function [log] = loadlog(name)

disp('load logs');
if ~exist('name','var')
    rawdata = importdata('log.txt');
else 
    rawdata = importdata(name);
end    
cd bin
    parameters;
    
    clear ans caseName delta Delta delta99end domain flowType mesh numMethods p_col p_row time xc 
    
cd ..
data = rawdata.data;
log.saveNumber = data(:,1);
log.iter = data(:,2);
log.t = data(:,3);
log.dt = data(:,4);
log.cfl = data(:,5);
log.res = data(:,6:10);
log.U = data(:,11:5:end);
log.V = data(:,12:5:end);
log.W = data(:,13:5:end);
log.R = data(:,14:5:end);
log.E = data(:,15:5:end);


end