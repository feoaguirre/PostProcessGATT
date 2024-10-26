clear,clc
addpath 'C:\Users\Felipe\Documents\MATLAB/auxFunc/'
addpath 'C:\Users\Felipe\Documents\MATLAB/auxFunc/crameri_colormap/crameri/'
set(groot,'defaultTextinterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');

% ---------------------------------------------------
% definitions

Re  = 734;
Ma  = 1.2;
D = 6.11;
L   = 2*D;
xC1 = Re/1.72^2;
xC2 = xC1 + L;
xC  = mean([xC1 xC2]);


casePath = 'E:\DNS\m12';
steps = 8:26;
var      = 'U';
xStations = [xC2-0.2*L  xC2+2.6*L xC2+2.7*L xC2+2.8*L xC2+3*L xC2+4*L xC2+16*L];
yPos = ones(1,length(xStations)) * (1);
zInterval = [-1 1]*20;

% filters and mean

extractMeanFlow_z = true; % true | false
extractMeanFlow_t = true;

filt.active = false; % true | false  (or comment)
filt.omega.center = 0;
filt.omega.span = 0.4;
filt.omega.tol  = 0.01;

%filt.beta.center = 0;
%filt.beta.span = 12;
%filt.beta.tol  = 0.01;

cLimits = 'global'; % 'local' | 'global'
nLvls = 30;
cMap1 = crameri('vik',nLvls);
cMap2 = crameri('lajolla',nLvls);

%compute the lstmodes

modes = load('E:\DNS\instabilidade\modesLSTquali.mat');
betamodeR1 = real(modes.beta734([1]));
modelstR1 = imag(modes.modes734([1]));
betamodeC1 = real(modes.beta734([8]));
modelstC1 = imag(modes.modes734([8]));
betamodeC2 = real(modes.beta734([4]));
modelstC2 = imag(modes.modes734([4]));
betamodeC3 = real(modes.beta734([3]));
modelstC3 = imag(modes.modes734([3]));
betamodeDNS = [0.1481];
modeDNS = [0];

% ------------------------------------------------------------------------------------
nP = length(xStations);
for ii = 1:nP
%     fprintf('Case: %s\n x-Pos = %3.2f\n',casePath,(xStations(ii)-xC1)/L);
        fprintf('Case: %s\n x-Pos = %3.2f\n',casePath,(xStations(ii)-xC1)/L);
    if exist('ydS','var')
        fprintf(' y-Pos = %1.2f (relative Blasius disp. thickness!)\n',ydS(ii));
        yAux = 1.7208*sqrt(xStations(ii)/Re) * ydS(ii);
    else
        fprintf(' y-Pos = %1.2f\n',yPos(ii));
        yAux = yPos(ii);
    end
    axLim = [ [1 1]*xStations(ii),  [1 1]*yAux,  zInterval ];
    
    [x(ii),y(ii),z(ii,:),t(ii,:),varAux] = importFlowData(casePath,var,axLim,steps);
    varAux = squeeze(varAux);
    
    varMeanPhis_z = mean(varAux,1);
    varMeanPhis_t = mean(varAux,2);    
    
    if extractMeanFlow_t && ~extractMeanFlow_z
        fprintf('Extracting meanflow along time...\n')
        varAux = varAux - repmat(varMeanPhis_t,[1 length(t(ii,:))]);
    end
    if extractMeanFlow_z && ~extractMeanFlow_t
        fprintf('Extracting meanflow along z-dir...\n')
        varAux = varAux - repmat(varMeanPhis_z,[length(z(ii,:)) 1]);
    end
    if extractMeanFlow_z && extractMeanFlow_t
        fprintf('Extracting meanflow along z-dir and time...\n')
        varAux = varAux - mean(varMeanPhis_z);
    end
    
        
    [beta(ii,:),omega(ii,:),specAux] = specCalc_zt(z(ii,:),t(ii,:),varAux);
    
    filtFunc = ones(length(beta(ii,:)),length(omega(ii,:)));
    if filt.active
        if isfield(filt,'omega')
            fprintf('Filtering spectrum along omega...')
            filtFuncAux = filt_GaussianShape(omega(ii,:),filt.omega.center,filt.omega.span,filt.omega.tol);
            filtFunc = filtFunc .* repmat(filtFuncAux,[length(z(ii,:)) 1]);
        end
        if isfield(filt,'beta')
            fprintf('Filtering spectrum along beta...')
            filtFuncAux = filt_GaussianShape(beta(ii,:),filt.beta.center,filt.beta.span,filt.beta.tol);
            filtFunc = filtFunc .* repmat(filtFuncAux',[1 length(t(ii,:))]);
        end        
    end
%     figure(2); clf;
%     surf(beta(ii,:),omega(ii,:),filtFunc');    
    
    specAux = specAux .* filtFunc;
    varAux = ifft2(ifftshift(specAux));
    
    varPhys(:,:,ii) = varAux;
    varSpec(:,:,ii) = abs(specAux)/(length(beta(ii,:)) * length(omega(ii,:)));
    
    clearvars yAux axLim varAux   
    fprintf('Done!\n\n')
end

for ii = 1:nP
    varMinPhys(ii) = min(min(squeeze(varPhys(:,:,ii))));
    varMaxPhys(ii) = max(max(squeeze(varPhys(:,:,ii))));
    varMaxSpec(ii) = max(max(squeeze(varSpec(:,:,ii))));
end

for ii = 1:nP
    if strcmp(cLimits,'local')
        cLvls_phys(ii,:) = linspace(varMinPhys(ii),varMaxPhys(ii),nLvls+1);
        cLvls_spec(ii,:) = linspace(0,varMaxSpec(ii),nLvls+1);
%         cLvls_spec(ii,:) = [1e-6 0.0004612 0.0008575 0.001518 0.001858 0.002493 0.002847 0.003455 0.004036 0.004206 0.006342];
    else
        cLvls_phys(ii,:) = linspace(min(varMinPhys),max(varMaxPhys),nLvls+1);
        cLvls_spec(ii,:) = linspace(0,max(varMaxSpec),nLvls+1);
%         cLvls_phys(ii,:) = logspace(min(varMinPhys),max(varMaxPhys),nLvls+1);
%         cLvls_spec(ii,:) = logspace(0,max(varMaxSpec),nLvls+1);
    end
end

figure; clf;
for ii = 1:nP 
    ax1(nP-ii+1) = subplot(nP,2,2*ii-1); hold on; grid on;
    ax2(nP-ii+1) = subplot(nP,2,2*ii  ); hold on; grid on;
end
    
for ii = 1:nP
    plot(ax2(ii),betamodeR1,modelstR1,'rx','MarkerSize',12,'LineWidth',2);
    plot(ax2(ii),betamodeC1,modelstC1,'bd','MarkerSize',12,'LineWidth',2);
    plot(ax2(ii),-betamodeDNS,modeDNS,'bs','MarkerSize',9,'LineWidth',2,'MarkerFaceColor','black');
    plot(ax2(ii),betamodeC2,modelstC2,'ko','MarkerSize',12,'LineWidth',2);
    plot(ax2(ii),betamodeC3,modelstC3,'g^','MarkerSize',8,'LineWidth',2);
    contourf(ax1(ii),t(ii,:),z(ii,:),squeeze(varPhys(:,:,ii)),cLvls_phys(ii,:),'linestyle','none');
    contourf(ax2(ii),beta(ii,:)/(2*pi),omega(ii,:),squeeze(varSpec(:,:,ii))',cLvls_spec(ii,:),'linestyle','none');
    plot(ax2(ii),-flip(betamodeC1),flip(modelstC1),'bd','MarkerSize',12,'LineWidth',2);
    plot(ax2(ii),-flip(betamodeC2),flip(modelstC2),'ko','MarkerSize',12,'LineWidth',2);
    plot(ax2(ii),betamodeC3,modelstC3,'g^','MarkerSize',8,'LineWidth',2);
    plot(ax2(ii),-flip(betamodeC3),flip(modelstC3),'g^','MarkerSize',8,'LineWidth',2);
    plot(ax2(ii),-flip(betamodeR1),flip(modelstR1),'rx','MarkerSize',12,'LineWidth',2)
   plot(ax2(ii),betamodeDNS,modeDNS,'bs','MarkerSize',9,'LineWidth',2,'MarkerFaceColor','black');
    plot(ax2(ii),betamodeR1,modelstR1,'rx','MarkerSize',12,'LineWidth',2);
    plot(ax2(ii),betamodeC1,modelstC1,'bd','MarkerSize',12,'LineWidth',2);
    plot(ax2(ii),-betamodeDNS,modeDNS,'bs','MarkerSize',9,'LineWidth',2,'MarkerFaceColor','black');
    plot(ax2(ii),betamodeC2,modelstC2,'ko','MarkerSize',12,'LineWidth',2);

end



% Plot layout display

for ii = 1:nP
    colormap(ax1(ii),cMap1);
    colormap(ax2(ii),cMap2);    
   
    ax1(ii).CLim = cLvls_phys(ii,[1 end]);
    ax2(ii).CLim = cLvls_spec(ii,[1 end]);
    
    ax1(ii).XLim = [t(1,1) t(1,end)];
    ax1(ii).XTick = unique(round(linspace(t(1,1)/10,t(1,end)/10,7))*10);
    ax1(ii).YLim = [-1 1]*max(abs(z(1,:)));
    
    
%     ax2(ii).XLim = [-1 1]*6;
    ax2(ii).XLim = [-1 1]*0.6;
    ax2(ii).XTick =[-0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5];
    
    ax2(ii).YLim = [0 1]*0.5;
%     ax2(ii).YLim = [0 1]*0.12;
%     ax2(ii).YLim = [0 1]*0.3;  
%     ax2(ii).YLim = [0 1]*0.03;
    if filt.active == true
        ax2(ii).YLim = [0 1]*0.05;
        ax2(ii).YLim = [0 1]*0.03;
        

    end
%     
    
%     
%     ax2(ii).YTick = [0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6];
%     ax2(ii).YTick = [0 0.1 0.2 0.3 0.4 0.5];
      ax2(ii).YTick = [0 0.05 0.1 0.2 0.5];
%     ax2(ii).YTick = [0 0.01 0.02 0.03 0.04 0.05 0.06 0.07];
     if filt.active == true
        ax2(ii).YTick = [0 0.01 0.02 0.03 0.04 0.05 0.06 0.07];
    end
    
    ax1(ii).YLabel.String = '$z$';
    ax2(ii).YLabel.String = '$\omega$';
    
%     ax1(ii).Title.String = ['$(gap \ \% , y) = (',num2str((x(ii)-xC1)/L,'%1.1f'),', ',num2str(y(ii),'%1.1f'),')$'];
    ax1(ii).Title.String = ['$(x, y) = (',num2str(x(ii),'%1.0f'),', ',num2str(y(ii),'%1.1f'),')$'];
    
    ax1(ii).Position(2) = ax1(ii).Position(2) + 0.02;
    ax2(ii).Position(2) = ax2(ii).Position(2) + 0.02;
end
set(ax1(2:end), 'XTickLabel', []);
set(ax2(2:end), 'XTickLabel', []);

ax1(1).XLabel.String = '$t$';
ax2(1).XLabel.String = '$1 / \lambda$';


cBar1 = colorbar(ax1(1));
cBar1.Location = 'south';
cBar1.Ticks = [cLvls_phys(1,1), cLvls_phys(1,end)];
cBar1.Position = [ax1(1).Position(1)+0.05*ax1(1).Position(3),...
                  ax1(1).Position(2)-0.65*ax1(1).Position(4),...
                  0.30*ax1(1).Position(3),...
                  0.08*ax1(1).Position(4)];
cBar1.Label.Interpreter = 'latex'; 
cBar1.Label.FontSize = 12; 
cBar1.TickLabelInterpreter = 'latex';
if strcmp(cLimits,'local')
    cBar1.TickLabels = {'$min_L$';'$max_L$'};
else
    cBar1.TickLabels = {'$min_G$';'$max_G$'};
end

cBar2 = colorbar(ax2(1));
cBar2.Location = 'south';
cBar2.Ticks = [cLvls_spec(1,1), cLvls_spec(1,end)];
cBar2.Position = [ax2(1).Position(1)+0.05*ax2(1).Position(3),...
                  ax2(1).Position(2)-0.65*ax2(1).Position(4),...
                  0.30*ax2(1).Position(3),...
                  0.08*ax2(1).Position(4)];
cBar2.Label.Interpreter = 'latex'; 
cBar2.Label.FontSize = 12; 
cBar2.TickLabelInterpreter = 'latex';
if strcmp(cLimits,'local')
    cBar2.TickLabels = {'$0$';'$max_{L}$'};
else
    cBar2.TickLabels = {'$0$';'$max_{G}$'};
end

if extractMeanFlow_z && extractMeanFlow_t
    cBar1.Label.String = ['$',lower(var),'-','\bar{',lower(var),'}$'];
    cBar2.Label.String = ['$|FFT(',lower(var),'-','\bar{',lower(var),'} )|$'];
elseif extractMeanFlow_z && ~extractMeanFlow_t
    cBar1.Label.String = ['$',lower(var),'-','\bar{',lower(var),'}_z$'];
    cBar2.Label.String = ['$|FFT(',lower(var),'-','\bar{',lower(var),'}_z )|$'];
elseif ~extractMeanFlow_z && extractMeanFlow_t
    cBar1.Label.String = ['$',lower(var),'-','\bar{',lower(var),'}_t$'];
    cBar2.Label.String = ['$|FFT(',lower(var),'-','\bar{',lower(var),'}_t )|$'];
end

set(ax1,'Layer','top','FontSize',11)
set(ax2,'Layer','top','FontSize',11)

linkaxes(ax1,'xy')
linkaxes(ax2,'xy')
set(findall(gcf,'-property','FontSize'),'FontSize',18)