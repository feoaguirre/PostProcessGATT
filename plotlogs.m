function [] = plotlogs(save,plotprobs)


%%===============================START=PLOT=LOGS=====================================%%
disp('start plotprob...');

if ~exist('prob','dir')
    mkdir('prob');
end
%%=================================LOAD=PROBS=AND=MESH=======================================%%
disp('load parameters');
load('mesh.mat');
cd bin;
parameters;
cd ..;
probs = mesh.trackedPoints;
nprobs = length(probs);
clear caseName D delta delta99end domain L logAll flowType flowParameters Ma numMethods p_col p_row Red time ;
%%=================================LOAD=LOGS========================================%%
disp('load logs');
rawdata = importdata('log.txt');
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
disp('change folder');

if nargin == 0
    save = 'on';
    plotprobs = 1:nprobs;
elseif nargin == 1
    plotprobs = 1:nprobs;
end


clc;
%%=============================================START=PLOT==========================================%%
%h = waitbar(0,'total of probs progress');
if strcmp(save,'on')
  cd prob;  
for i = plotprobs
    
    clc;
    disp(strcat('prob plot: ',num2str(i)));
    name = strcat('prob',num2str(i));
    f = figure('visible', 'off');
    %f = figure('visible', 'on');
    p = uipanel('Parent',f,'BorderType','none');
    
    if probs(i,1)>x2
        posx = 'downstream';
    elseif probs(i,1)>x1 && probs(i,1)<x2
        posx = 'in the gap';
    elseif probs(i,1)<x1 
        posx = 'upstream';
    elseif probs(i,1)== x1     
        posx = 'back face';
    elseif probs(i,1)== x2     
        posx = 'back face';
    end
    if probs(i,2)<= 0    
        posy = 'in the gap';
    elseif probs(i,2) > 0     
        posy = 'over plate';
    end
    
    p.Title = strcat('prob:',num2str(i),' Position:',' X:',posx,'  Y:',posy ,'  coord:' ,' X:',num2str(probs(i,1)),' Y:',num2str(probs(i,2)),' Z:',num2str(probs(i,3)));
    
   
%%==============================================FIGURES============================================%%    
    %%subfig1
    
    subplot(2,2,1,'Parent',p);
    plot(log.t,log.R(:,i));
    title (strcat('rho no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('rho');
    grid on;
    
    
    %%subfig2
    
    subplot(2,2,2,'Parent',p);
    plot(log.t,log.W(:,i));
    grid on;
    title (strcat('W no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('W');
   
    
    %%subfig3
    
    subplot(2,2,3,'Parent',p);
    plot(log.t,log.U(:,i));
    grid on;
    title (strcat('U no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('U');
    
    %%subfig4
    
    subplot(2,2,4,'Parent',p);
    plot(log.t,log.V(:,i));
    grid on;
    title (strcat('V no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('V');
    
    
    
    %disp(strcat('prob:',num2str(i),' Position:',' X:',posx,'  Y:',posy ,'  coord:' ,' X:',num2str(probs(i,1)),' Y:',num2str(probs(i,2)),' Z:',num2str(probs(i,3))));
    saveas(f,name,'epsc');
    
end
cd ..;

elseif strcmp(save,'off')
        
for i = plotprobs 
    
    clc;
    disp(strcat('prob plot: ',num2str(i)));
    %f = figure('visible', 'off');
    f = figure('visible', 'on');
    p = uipanel('Parent',f,'BorderType','none');
    
    if probs(i,1)>x2
        posx = 'downstream';
    elseif probs(i,1)>x1 && probs(i,1)<x2
        posx = 'in the gap';
    elseif probs(i,1)<x1 
        posx = 'upstream';
    elseif probs(i,1)== x1     
        posx = 'back face';
    elseif probs(i,1)== x2     
        posx = 'back face';
    end
    if probs(i,2)<= 0    
        posy = 'in the gap';
    elseif probs(i,2) > 0     
        posy = 'over plate';
    end
    
    p.Title = strcat('prob:',num2str(i),' Position:',' X:',posx,'  Y:',posy ,'  coord:' ,' X:',num2str(probs(i,1)),' Y:',num2str(probs(i,2)),' Z:',num2str(probs(i,3)));
    
   
%%==============================================FIGURES============================================%%    
    %%subfig1
    
    subplot(2,2,1,'Parent',p);
    plot(log.t,log.R(:,i));
    title (strcat('rho no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('rho');
    grid on;
    
    
    %%subfig2
    
    subplot(2,2,2,'Parent',p);
    plot(log.t,log.W(:,i));
    grid on;
    title (strcat('W no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('W');
   
    
    %%subfig3
    
    subplot(2,2,3,'Parent',p);
    plot(log.t,log.U(:,i));
    grid on;
    title (strcat('U no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('U');
    
    %%subfig4
    
    subplot(2,2,4,'Parent',p);
    plot(log.t,log.V(:,i));
    grid on;
    title (strcat('V no prob: ',num2str(i)));
    xlabel ('simulation time');
    ylabel ('V');
    
    
end
end

disp(' end plotprob ');

end