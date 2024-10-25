% clear;clc;

% steps = 1:2000;
steps = 200:300;
casePath = 'E:\DNS\new\m05-FINAL';
% casePath = 'C:\Users\Intel i3\Downloads\teste - Copia';
% cd 'C:\Users\Intel i3\Downloads\teste - Copia';
cd 'E:\DNS\new\m05-FINAL';
load mesh.mat;
xEnd = 500;
domain.zf = Z(end);
domain.zi = Z(1);
% casePath = 'C:\Users\Intel i3\Downloads\teste - Copia';
D = -flowType.cav{1,1}.y(1);
L = flowType.cav{1,1}.x(2)-flowType.cav{1,1}.x(1);
axLim = [(flowType.cav{1,1}.x(1)-10) (flowType.cav{1,1}.x(2)+(xEnd-flowType.cav{1,1}.x(2))/2), [flowType.cav{1,1}.y(1) -(flowType.cav{1,1}.y(1))], [-1 1]*domain.zf];

[x,y,z,t,varOut,wall] = loadVar(casePath,steps,axLim);

varPlot1 = varOut.U;
varPlot2 = varOut.V;
varPlot3 = varOut.W;
varPlot4 = varOut.R;

%% GAP %%

probsZgap = [z(1) z(floor(length(z)/4)) z(floor(length(z)/2)) z(floor(3*(length(z)/4))) z(end)];
probsYgap = [(-D+0.1*D) (-D+0.25*D) (-D+0.5*D) (-D+0.75*D) 0];
gaplinemap = zeros(2,length(probsZgap)*length(probsYgap));
meanlinegap.U = zeros(length(x),length(probsZgap)*length(probsYgap));
meanlinegap.V = zeros(length(x),length(probsZgap)*length(probsYgap));
meanlinegap.W = zeros(length(x),length(probsZgap)*length(probsYgap));
meanlinegap.R = zeros(length(x),length(probsZgap)*length(probsYgap));
linegap.U = zeros(length(x),length(t),length(probsZgap)*length(probsYgap));
linegap.V = zeros(length(x),length(t),length(probsZgap)*length(probsYgap));
linegap.W = zeros(length(x),length(t),length(probsZgap)*length(probsYgap));
linegap.R = zeros(length(x),length(t),length(probsZgap)*length(probsYgap));
probcountgap = 0;

for i = probsZgap
    
    for j = probsYgap
        probcountgap = probcountgap+1;
        gaplinemap(:,probcountgap) = [j i];
        legendagap{probcountgap} = strcat('GAP Y = ',num2str(j),'Z = ',num2str(i));
        meanlinegap.U(:,probcountgap) = mean(varPlot1(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        meanlinegap.V(:,probcountgap) = mean(varPlot2(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        meanlinegap.W(:,probcountgap) = mean(varPlot3(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        meanlinegap.R(:,probcountgap) = mean(varPlot4(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        linegap.U(:,:,probcountgap) = varPlot1(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
        linegap.V(:,:,probcountgap) = varPlot2(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
        linegap.W(:,:,probcountgap) = varPlot3(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
        linegap.R(:,:,probcountgap) = varPlot4(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
    end
end



%% PLATE %%

probsZ= [z(1) z(floor(length(z)/4)) z(floor(length(z)/2)) z(floor(3*(length(z)/4))) z(end)];
probsY = [(0+0.1*D) 1 (-0+0.5*D) D];
linemap = zeros(2,length(probsZ)*length(probsY));
meanline.U = zeros(length(x),length(probsZ)*length(probsY));
meanline.V = zeros(length(x),length(probsZ)*length(probsY));
meanline.W = zeros(length(x),length(probsZ)*length(probsY));
meanline.R = zeros(length(x),length(probsZ)*length(probsY));
line.U = zeros(length(x),length(t),length(probsZ)*length(probsY));
line.V = zeros(length(x),length(t),length(probsZ)*length(probsY));
line.W = zeros(length(x),length(t),length(probsZ)*length(probsY));
line.R = zeros(length(x),length(t),length(probsZ)*length(probsY));
probcount = 0;

for i = probsZ
    
    for j = probsY
        probcount = probcount+1;
        legenda{probcount} = strcat('Y = ',num2str(j),'Z = ',num2str(i));
        linemap(:,probcount) = [j i];
        meanline.U(:,probcount) = mean(varPlot1(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        meanline.V(:,probcount) = mean(varPlot2(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        meanline.W(:,probcount) = mean(varPlot3(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        meanline.R(:,probcount) = mean(varPlot4(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:),4);
        line.U(:,:,probcount) = varPlot1(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
        line.V(:,:,probcount) = varPlot2(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
        line.W(:,:,probcount) = varPlot3(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
        line.R(:,:,probcount) = varPlot4(:,find(abs(y-j)==min(abs(y-j))),find(abs(z-i)==min(abs(z-i))),:);
    end
end



%% GAP
figure;clf;
hold on;
plot(x,meanlinegap.U);
xlim([flowType.cav{1,1}.x(1) flowType.cav{1,1}.x(2)]);
legend(legendagap{:})
title('gap')

%% PLATE
figure;clf;
hold on;
plot(x,meanline.U);
legend(legenda{:})
title('plate')


function [x,y,z,t,varOut,wall] = loadVar(casePath,steps,axLim)

mesh = load(sprintf('%s/mesh.mat',casePath));
wall = mesh.wall;

x = mesh.X; y = mesh.Y; z = mesh.Z;
nx = length(x); ny = length(y); nz = length(z);
indX = find(abs(x-axLim(1))==min(abs(x-axLim(1)))):find(abs(x-axLim(2))==min(abs(x-axLim(2))));
indY = find(abs(y-axLim(3))==min(abs(y-axLim(3)))):find(abs(y-axLim(4))==min(abs(y-axLim(4))));
indZ = find(abs(z-axLim(5))==min(abs(z-axLim(5)))):find(abs(z-axLim(6))==min(abs(z-axLim(6))));
x = x(indX); y = y(indY); z = z(indZ);
wall = wall(indX,indY,indZ);

Re = mesh.flowParameters.Re;

U = zeros(length(x),length(y),length(z),length(steps));
V = zeros(length(x),length(y),length(z),length(steps));
W = zeros(length(x),length(y),length(z),length(steps));
R = zeros(length(x),length(y),length(z),length(steps));
for iStep = 1:length(steps)
    flow = matfile(sprintf('%s/flow_%010.0f.mat',casePath,steps(iStep)));
    [nx,ny,nz] = size(flow,'U');
    [nx,ny,nz] = size(flow,'V');
    [nx,ny,nz] = size(flow,'W');
    [nx,ny,nz] = size(flow,'R');
    
    U(:,:,:,iStep) = flow.U(indX,indY,indZ);
    V(:,:,:,iStep) = flow.V(indX,indY,indZ);
    W(:,:,:,iStep) = flow.W(indX,indY,indZ);
    R(:,:,:,iStep) = flow.R(indX,indY,indZ);
    t(iStep) = flow.t;
end
varOut.U = U;
varOut.V = V;
varOut.W = W;
varOut.R = R;

fprintf('Finished \n\n')
end