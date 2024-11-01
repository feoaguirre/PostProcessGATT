% clear;clc;

steps = 200:300;
% steps = 150:155;
casePath = 'E:\DNS\new\m05-FINAL';
cd 'E:\DNS\new\m05-FINAL';
% casePath = 'C:\Users\Intel i3\Downloads\teste - Copia';
% cd 'C:\Users\Intel i3\Downloads\teste - Copia';
load mesh.mat;
xEnd = 500;
domain.zf = Z(end);
domain.zi = Z(1);
% casePath = 'C:\Users\Intel i3\Downloads\teste - Copia';
D = -flowType.cav{1,1}.y(1);
L = flowType.cav{1,1}.x(2)-flowType.cav{1,1}.x(1);
axLim = [(flowType.cav{1,1}.x(1)) (flowType.cav{1,1}.x(2)+(xEnd-flowType.cav{1,1}.x(2))/2), [flowType.cav{1,1}.y(1) -flowType.cav{1,1}.y(1)], [-1 1]*domain.zf];

[x,y,z,t,varOut,wall] = loadVar(casePath,steps,axLim);

varPlot1 = varOut.U;
varPlot2 = varOut.V;
varPlot3 = varOut.W;
varPlot4 = varOut.R;

%% FOR GAP %%


probsXgap = [(flowType.cav{1,1}.x(1)+0.25*L) ((flowType.cav{1,1}.x(2)+flowType.cav{1,1}.x(1))/2) (flowType.cav{1,1}.x(1)+0.75*L) (flowType.cav{1,1}.x(1)+0.9*L)];
probsYgap = [(-D+0.1*D) (-D+0.25*D) (-D+0.5*D) (-D+0.75*D) 0];
probsZgap = [z(1) z(floor(length(z)/4)) z(floor(length(z)/2)) z(floor(3*(length(z)/4))) z(end)];
%probgap = zeros(length(probsXgap)*length(probsYgap)*length(probsZgap),4,length(steps));


probgapmap = zeros(3,length(probsXgap)*length(probsYgap)*length(probsZgap));
probgap.U = zeros(length(t),length(probsXgap)*length(probsYgap)*length(probsZgap));
probgap.V = zeros(length(t),length(probsXgap)*length(probsYgap)*length(probsZgap));
probgap.W = zeros(length(t),length(probsXgap)*length(probsYgap)*length(probsZgap));
probgap.R = zeros(length(t),length(probsXgap)*length(probsYgap)*length(probsZgap));
probcountgap = 0;

for j= probsYgap
    for i= probsXgap
        for k= probsZgap
            probcountgap = probcountgap+1;
            probgapmap(:,probcountgap) = [i j k];
            probgap.U(:,probcountgap) = varPlot1(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            probgap.V(:,probcountgap) = varPlot2(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            probgap.W(:,probcountgap) = varPlot3(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            probgap.R(:,probcountgap) = varPlot4(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            
        end
    end
end



L=length(probgap.U(:,1));
l2 = round(L/2);
Fs = (length(probgap.U(:,1)))/(t(end)-t(1));
df = 1/(t(end)-t(1));
f = (Fs*(0:l2)/L)*2*pi;


%% For U %%

variable = zeros(L,probcountgap);
fourier = zeros(L,probcountgap);
P2 = zeros(L,probcountgap);
P1gap.U = zeros(l2+1,probcountgap);

for ii = 1:probcountgap
    variable(:,ii) = probgap.U(:,ii) - mean(probgap.U(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1gap.U(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1gap.U(2:end-1,ii) = 2*P1gap.U(2:end-1,ii);
end

%% For V %%

variable = zeros(L,probcountgap);
fourier = zeros(L,probcountgap);
P2 = zeros(L,probcountgap);
P1gap.V = zeros(l2+1,probcountgap);

for ii = 1:probcountgap
    variable(:,ii) = probgap.V(:,ii) - mean(probgap.V(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1gap.V(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1gap.V(2:end-1,ii) = 2*P1gap.V(2:end-1,ii);
end


%% For W %%

variable = zeros(L,probcountgap);
fourier = zeros(L,probcountgap);
P2 = zeros(L,probcountgap);
P1gap.W = zeros(l2+1,probcountgap);

for ii = 1:probcountgap
    variable(:,ii) = probgap.W(:,ii) - mean(probgap.W(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1gap.W(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1gap.W(2:end-1,ii) = 2*P1gap.W(2:end-1,ii);
end

%% For R %%

variable = zeros(L,probcountgap);
fourier = zeros(L,probcountgap);
P2 = zeros(L,probcountgap);
P1gap.R = zeros(l2+1,probcountgap);

for ii = 1:probcountgap
    variable(:,ii) = probgap.R(:,ii) - mean(probgap.R(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1gap.R(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1gap.R(2:end-1,ii) = 2*P1gap.R(2:end-1,ii);
end

%% FOR plate %%


probsX = [(flowType.cav{1,1}.x(1)) (flowType.cav{1,1}.x(2)) (flowType.cav{1,1}.x(2)+L) (flowType.cav{1,1}.x(2)+2*L) (flowType.cav{1,1}.x(2)+4*L) (flowType.cav{1,1}.x(2)+10*L) (flowType.cav{1,1}.x(2)+20*L)];
probsY = [(0+0.1*D) 1 (-0+0.5*D) D];
probsZ = [z(1) z(floor(length(z)/4)) z(floor(length(z)/2)) z(floor(3*(length(z)/4))) z(end)];
%prob = zeros(length(probsXgap)*length(probsYgap)*length(probsZgap),4,length(steps));
probcount = 0;

probmap = zeros(3,length(probsX)*length(probsY)*length(probsZ));
prob.U = zeros(length(t),length(probsX)*length(probsY)*length(probsZ));
prob.V = zeros(length(t),length(probsX)*length(probsY)*length(probsZ));
prob.W = zeros(length(t),length(probsX)*length(probsY)*length(probsZ));
prob.R = zeros(length(t),length(probsX)*length(probsY)*length(probsZ));

for j= probsY
    for i= probsX
        for k= probsZ
            probcount = probcount+1;
            probmap(:,probcount) = [i j k];
            prob.U(:,probcount) = varPlot1(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            prob.V(:,probcount) = varPlot2(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            prob.W(:,probcount) = varPlot3(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            prob.R(:,probcount) = varPlot4(find(abs(x-i)==min(abs(x-i))),find(abs(y-j)==min(abs(y-j))),find(abs(z-k)==min(abs(z-k))),:);
            
        end
    end
end



L=length(prob.U(:,1));
l2 = round(L/2);
Fs = (length(prob.U(:,1)))/(t(end)-t(1));
df = 1/(t(end)-t(1));
f = (Fs*(0:l2)/L)*2*pi;


%% For U %%

variable = zeros(L,probcount);
fourier = zeros(L,probcount);
P2 = zeros(L,probcount);
P1.U = zeros(l2+1,probcount);

for ii = 1:probcount
    variable(:,ii) = prob.U(:,ii) - mean(prob.U(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1.U(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1.U(2:end-1,ii) = 2*P1.U(2:end-1,ii);
end

%% For V %%

variable = zeros(L,probcount);
fourier = zeros(L,probcount);
P2 = zeros(L,probcount);
P1.V = zeros(l2+1,probcount);

for ii = 1:probcount
    variable(:,ii) = prob.V(:,ii) - mean(prob.V(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1.V(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1.V(2:end-1,ii) = 2*P1.V(2:end-1,ii);
end


%% For W %%

variable = zeros(L,probcount);
fourier = zeros(L,probcount);
P2 = zeros(L,probcount);
P1.W = zeros(l2+1,probcount);

for ii = 1:probcount
    variable(:,ii) = prob.W(:,ii) - mean(prob.W(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1.W(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1.W(2:end-1,ii) = 2*P1.W(2:end-1,ii);
end

%% For R %%

variable = zeros(L,probcount);
fourier = zeros(L,probcount);
P2 = zeros(L,probcount);
P1.R = zeros(l2+1,probcount);

for ii = 1:probcount
    variable(:,ii) = prob.R(:,ii) - mean(prob.R(:,ii));
    fourier(:,ii) =  fft(variable(:,ii));
    P2(:,ii) = abs(fourier(:,ii)/L);
    P1.R(:,ii) = P2(1:l2+1,ii);
    %       P1(:,ii) = P2(1:l2,ii);
    P1.R(2:end-1,ii) = 2*P1.R(2:end-1,ii);
end

for i=1:length(probmap)
    leganda{i} = strcat('x =',num2str(probmap(1,i)),'y =',num2str(probmap(2,i)),'z =',num2str(probmap(3,i)));
end
    figure; clf; hold on;
    plot(t,prob.U(:,1:35));
    title(strcat('Prob Y =',num2str(probmap(2,35))));
    legend(leganda{1:35});
    figure; clf; hold on;
    plot(f,P1.U(:,1:35));
    title(strcat('Y =',num2str(probmap(2,35))));
    legend(leganda{1:35});
    figure; clf; hold on;
    plot(t,prob.U(:,36:70));
    title(strcat('Prob Y =',num2str(probmap(2,70))));
    legend(leganda{36:70});
    figure; clf; hold on;
    plot(f,P1.U(:,36:70));
    title(strcat('Y =',num2str(probmap(2,70))));
    legend(leganda{36:70});
    figure; clf; hold on;
    plot(t,prob.U(:,71:105));
    title(strcat('Prob Y =',num2str(probmap(2,105))));
    legend(leganda{71:105});
    figure; clf; hold on;
    plot(f,P1.U(:,71:105));
     title(strcat('Y =',num2str(probmap(2,105))));
     legend(leganda{71:105});
    figure; clf; hold on;
    plot(t,prob.U(:,106:140));
     title(strcat('Prob Y =',num2str(probmap(2,106))));
     legend(leganda{106:140});
    figure; clf; hold on;
    plot(f,P1.U(:,106:140));
     title(strcat('Y =',num2str(probmap(2,106))));
          legend(leganda{106:140});

for i=1:length(probgapmap)
    legandagap{i} = strcat('x =',num2str(probgapmap(1,i)),'y =',num2str(probgapmap(2,i)),'z =',num2str(probgapmap(3,i)));
end
          
figure; clf; hold on;
    plot(t,probgap.U(:,1:20));
    title(strcat('Prob Y =',num2str(probgapmap(2,20))));
    legend(legandagap{1:20});
figure; clf; hold on;
    plot(t,probgap.U(:,21:40));
    title(strcat('Prob Y =',num2str(probgapmap(2,40))));
    legend(legandagap{21:40});
figure; clf; hold on;
    plot(t,probgap.U(:,41:60));
    title(strcat('Prob Y =',num2str(probgapmap(2,60))));
    legend(legandagap{41:60});
figure; clf; hold on;
    plot(t,probgap.U(:,61:80));
    title(strcat('Prob Y =',num2str(probgapmap(2,80))));
    legend(legandagap{61:80});
figure; clf; hold on;
    plot(t,probgap.U(:,81:100));
    title(strcat('Prob Y =',num2str(probgapmap(2,100))));
    legend(legandagap{1:100});

    figure; clf; hold on;
    plot(f,P1gap.U(:,1:20));
    title(strcat('spec Y =',num2str(probgapmap(2,20))));
    legend(legandagap{1:20});
figure; clf; hold on;
    plot(f,P1gap.U(:,21:40));
    title(strcat('spec Y =',num2str(probgapmap(2,40))));
    legend(legandagap{21:40});
figure; clf; hold on;
    plot(f,P1gap.U(:,41:60));
    title(strcat('spec Y =',num2str(probgapmap(2,60))));
    legend(legandagap{41:60});
figure; clf; hold on;
    plot(f,P1gap.U(:,61:80));
    title(strcat('spec Y =',num2str(probgapmap(2,80))));
    legend(legandagap{61:80});
figure; clf; hold on;
    plot(f,P1gap.U(:,81:100));
    title(strcat('spec Y =',num2str(probgapmap(2,100))));
    legend(legandagap{1:100});
    

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