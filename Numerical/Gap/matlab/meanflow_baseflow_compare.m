clear all;
% close all;
clc;

cd 'E:\DNS\new\m05-FINAL';

meanflow = load('flow_mean.mat');
meshmeanflow = load('mesh.mat');
meanflow.E = mean(meanflow.E,3);
meanflow.R = mean(meanflow.R,3);
meanflow.U = mean(meanflow.U,3);
meanflow.V = mean(meanflow.V,3);
meanflow.W = mean(meanflow.W,3);

cd 'E:\DNS\instabilidade\mach 05';

baseflow = load('flow_0000000619CASED.mat');
meshbaseflow = load('mesh734.mat');

%% CUTS / PCOLORS %%

% figure(1);clf;
% pcolor(meshmeanflow.X,meshmeanflow.Y,meanflow.U');
% shading interp;
% grid on;
% colorbar;
% 
% 
% figure(2);clf;
% pcolor(meshbaseflow.X,meshbaseflow.Y,baseflow.U');
% shading interp;
% grid on;
% colorbar;
% 
% figure(3);clf;
% quiver(meshmeanflow.X,meshmeanflow.Y,meanflow.U',meanflow.V',8);
% grid on;
% 
% figure(4);clf;
% quiver(meshbaseflow.X,meshbaseflow.Y,baseflow.U',baseflow.V',8);
% grid on;

%% LINES %%

D = meshmeanflow.flowType.cav{1,1}.y(1);
probsY = [(D-0.1*D) (D-0.25*D) (D-0.5*D) (D-0.75*D) 0 (0+0.1*-D) 1 (-0+0.5*-D) -D];
linemapBASE = zeros(length(probsY));
linemapMEAN = zeros(length(probsY));
lineBASE.U = zeros(length(meshmeanflow.X),length(probsY));
lineMEAN.U = zeros(length(meshmeanflow.X),length(probsY));
probcount = 0;

for j = probsY
        probcount = probcount+1;
        linemap(probcount) = [j];
        meanleganda{probcount} = strcat('mean y =',num2str(j));
        baseleganda{probcount} = strcat('base y =',num2str(j));
        meanline.U(:,probcount) = meanflow.U(:,find(abs(meshmeanflow.Y-j)==min(abs(meshmeanflow.Y-j))));
        meanline.V(:,probcount) = meanflow.V(:,find(abs(meshmeanflow.Y-j)==min(abs(meshmeanflow.Y-j))));
        meanline.W(:,probcount) = meanflow.W(:,find(abs(meshmeanflow.Y-j)==min(abs(meshmeanflow.Y-j))));
        meanline.R(:,probcount) = meanflow.R(:,find(abs(meshmeanflow.Y-j)==min(abs(meshmeanflow.Y-j))));
        meanline.E(:,probcount) = meanflow.E(:,find(abs(meshmeanflow.Y-j)==min(abs(meshmeanflow.Y-j))));
        baseline.U(:,probcount) = baseflow.U(:,find(abs(meshbaseflow.Y-j)==min(abs(meshbaseflow.Y-j))));
        baseline.V(:,probcount) = baseflow.V(:,find(abs(meshbaseflow.Y-j)==min(abs(meshbaseflow.Y-j))));
        baseline.W(:,probcount) = baseflow.W(:,find(abs(meshbaseflow.Y-j)==min(abs(meshbaseflow.Y-j))));
        baseline.R(:,probcount) = baseflow.R(:,find(abs(meshbaseflow.Y-j)==min(abs(meshbaseflow.Y-j))));
        baseline.E(:,probcount) = baseflow.E(:,find(abs(meshbaseflow.Y-j)==min(abs(meshbaseflow.Y-j))));
end

% figure;clf;
% hold on;
% plot(meshmeanflow.X,meanline.U(:,1:5));
% xlim([meshmeanflow.flowType.cav{1,1}.x(1) meshmeanflow.flowType.cav{1,1}.x(2)]);
% grid on;
% legend(leganda{:});

% figure;clf;
% hold on;
% plot(meshbaseflow.X,baseline.U(:,1:5));
% xlim([meshbaseflow.flowType.cav{1,1}.x(1) meshbaseflow.flowType.cav{1,1}.x(2)]);
% grid on;
% legend(leganda{:});

figure;clf;
hold on;
plot(meshmeanflow.X,meanline.U(:,1:5),'-');
plot(meshbaseflow.X,baseline.U(:,1:5),'--');
xlim([meshmeanflow.flowType.cav{1,1}.x(1) meshmeanflow.flowType.cav{1,1}.x(2)]);
grid on;
legend(meanleganda{1:5},baseleganda{1:5});

% figure;clf;
% hold on;
% plot(meshmeanflow.X,meanline.U(:,6:end));
% % xlim([flowType.cav{1,1}.x(1) flowType.cav{1,1}.x(2)]);
% grid on;
% legend(leganda{:});

% figure;clf;
% hold on;
% plot(meshbaseflow.X,baseline.U(:,6:end));
% % xlim([flowType.cav{1,1}.x(1) flowType.cav{1,1}.x(2)]);
% grid on;
% legend(leganda{:});

figure;clf;
hold on;
plot(meshmeanflow.X,meanline.U(:,6:end),'-');
plot(meshbaseflow.X,baseline.U(:,6:end),'--');
% xlim([meshmeanflow.flowType.cav{1,1}.x(1) meshmeanflow.flowType.cav{1,1}.x(2)]);
grid on;
legend(meanleganda{6:end},baseleganda{6:end});
