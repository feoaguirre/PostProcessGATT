function gpuderivatives(fin,fend)
delete(gcp('nocreate'));
parpool(16);
pastaIn = pwd;
disp('run DNS for matrices');
cd ..;
[~,info]= runDNS('parameters');
aux=1;
for t = fin:fend
if ~exist(tstr,'file')
        step = step+1;
        continue;
end
aux = aux+1;
end

cd Red734-Ma05-L12.22-D6.11-3D-movie;
disp('load parameters');
load('mesh.mat');

pastaIn = pwd;
pastaOut = pastaIn;

steps = abs((fin-fend)/aux) + 1;
step = 0;
i = 1;
Tpast = 0;
Tprev = 0;
percent = 0;
for t = fin:fend
    clc;
    disp(strcat('progress: ',num2str(percent)));
    disp('Elapsed time (min)');
    disp(Tpast);
    disp('est time: (min)');
    disp(Tprev);
    tic;
    tstr = sprintf('%s/flow_%010d.mat',pastaIn,t);
    if ~exist(tstr,'file')
        step = step+1;
        
        continue;
    end
    disp('flow : \n')
    disp(t)
    current = load(tstr);
    
   disp('dU'); 
   [lambda1,lambda2,lambda3] = lambda2method(X,Y,Z,current.U,current.V,current.W,info); 
   
   lambda1 = reshape(lambda1,[length(X),length(Y),length(Z)]); 
   lambda2 = reshape(lambda2,[length(X),length(Y),length(Z)]); 
   lambda3 = reshape(lambda3,[length(X),length(Y),length(Z)]); 
   
   disp('save file'); 
   
   tstout = sprintf('%s/lambda_%010d.mat',pastaOut,t);
   save(tstout,'lambda2');

   T(i)= toc;
   i= i+1;
   Tpast = sum(T)/60;
   Tprev = ((Tpast*abs(step-steps))/step);
   step = step+1;
   percent = (step/steps)*100;
end
end