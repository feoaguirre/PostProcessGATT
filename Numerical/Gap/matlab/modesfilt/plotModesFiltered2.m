clear,clc

delete(gcp('nocreate'));
parpool(15);
% delete(gcp('nocreate'));
% parpool(2);

Re  = 734;
Ma  = 0.5;
D = 6.11;
L   = 2*D;
xC1 = Re/1.72^2;
xC2 = xC1 + L;
xC  = mean([xC1 xC2]);

casePath = '/home/felipe/autolst/m05-FINAL'; %'E:\DNS\new\m05-FINAL'
load '/home/felipe/autolst/m05-FINAL/mesh.mat';
steps = 1500:2000;
%steps = 1900:2000;
variables = ['U' 'V' 'W'];

indXstart = 185;
indXend = 580;
indYstart = 1;
indYend = 92;
xStations = X(185:580);
yStations = Y(1:92);


zInterval = [-1 1]*20;

extractMeanFlow_z = true; % true | false
extractMeanFlow_t = true;

filt.active = true; % true | false  (or comment)

%centrifugal band

%filt.omega.center = 0;
%filt.omega.span = 0.4;
%filt.omega.tol  = 0.01;

%rossiter band

filt.omega.center = 0.2;
filt.omega.span = 0.2;
filt.omega.tol  = 0.01;

% filt.beta.center = 0;
% filt.beta.span = 12;
% filt.beta.tol  = 0.01;

% ------------------------------------------------------------------------------------
nP = length(xStations);
nPy = length(yStations);
x = zeros(length(xStations),length(yStations),length(variables));
y = zeros(length(xStations),length(yStations),length(variables));
z = zeros(length(xStations),length(yStations),length(variables),length(Z));
t = zeros(length(xStations),length(yStations),length(variables),length(steps));
beta = zeros(length(xStations),length(yStations),length(variables),length(Z));
omega = zeros(length(xStations),length(yStations),length(variables),length(steps));
varPhys = zeros(length(steps),length(Z),length(xStations),length(yStations),length(variables));
Vortk = zeros(length(steps),length(xStations),length(yStations),length(Z));

for varii = 1:3

    if varii == 1
        var = 'U';
    elseif varii == 2
        var = 'V';
    elseif varii == 3
        var = 'W';
    end

            
    clc;
    disp(var);


    for jj = 1:nPy
        clc;
        disp(var);
        disp(100*jj/nPy)
        parfor ii = 1:nP

            axLim = [ [1 1]*xStations(ii),  [1 1]*yStations(jj),  zInterval ];
            
            [varX,varY,varZ,varT,varAux] = importFlowData(casePath,var,axLim,steps);
            varAux = squeeze(varAux);  
            varMeanPhis_z = mean(varAux,1);
            varMeanPhis_t = mean(varAux,2);

            if extractMeanFlow_t && ~extractMeanFlow_z
                %fprintf('Extracting meanflow along time...\n')
                varAux = varAux - repmat(varMeanPhis_t,[1 length(varT)]);
            end
            if extractMeanFlow_z && ~extractMeanFlow_t
                %fprintf('Extracting meanflow along z-dir...\n')
                varAux = varAux - repmat(varMeanPhis_z,[length(varZ) 1]);
            end
            if extractMeanFlow_z && extractMeanFlow_t
                %fprintf('Extracting meanflow along z-dir and time...\n')
                varAux = varAux - mean(varMeanPhis_z);
            end


            [varBeta,varOmega,specAux] = specCalc_zt(varZ,varT,varAux);
            
            filtFunc = ones(length(varBeta),length(varOmega));
            if filt.active
                if isfield(filt,'omega')
                    %fprintf('Filtering spectrum along omega...')
                    filtFuncAux = filt_GaussianShape(varOmega,filt.omega.center,filt.omega.span,filt.omega.tol);
                    filtFunc = filtFunc .* repmat(squeeze(filtFuncAux),[length(varZ) 1]);
                end
                if isfield(filt,'beta')
                    %fprintf('Filtering spectrum along beta...')
                    filtFuncAux = filt_GaussianShape(varBeta,filt.beta.center,filt.beta.span,filt.beta.tol);
                    filtFunc = filtFunc .* repmat(squeeze(filtFuncAux),[1 length(varT)]);
                end
            end

            specAux = specAux .* filtFunc;
            varAux = ifft2(ifftshift(specAux));
            

            varPhys(:,:,ii,jj,varii) = varAux';
            x(ii,jj,varii) = varX;
            y(ii,jj,varii) = varY;
            z(ii,jj,varii,:) = varZ;
            t(ii,jj,varii,:) = varT; 
            beta(ii,jj,varii,:) = varBeta;
            omega(ii,jj,varii,:) = varOmega;
            %fprintf('Done!\n\n')
        end
    end
end

clear beta cMap1 cMap2 filtFunc filtFuncAux omega specAux t varMeanPhis_t varMeanPhis_z x y z cLimits filt flowParameters ii jj var variables varii

for t = 1:length(steps)
    [~,~,Vortk(t,:,:,:),~] = vorticidade(permute(squeeze(varPhys(t,:,:,:,1)),[2 3 1]),permute(squeeze(varPhys(t,:,:,:,2)),[2 3 1]),permute(squeeze(varPhys(t,:,:,:,3)),[2 3 1]));
end

clear varPhys

iso_value3 = 0.005;
iso_value4 = 0.015;
linColV = lines(10);
figure('units','normalized','outerposition',[0 0 1 1],'Visible','off'); clf;
ax(1) = gca; grid on; box on;

[mx,my,mz] = meshgrid(xStations,yStations,Z);

wall = wall(indXstart:indXend,indYstart:indYend,1:end);

mx = permute(mx,[3 1 2]);
my = permute(my,[3 1 2]);
mz = permute(mz,[3 1 2]);
wall = permute(wall,[3 2 1]);
wall(find(my==min(yStations))) = 1; %#ok<*FNDSB>

for ii = 1:1

    ax(ii).BoxStyle = 'full'; %#ok<*SAGROW>
    ax(ii).XLim = xStations([1 end]);
    ax(ii).YLim = yStations([1 end]);
    ax(ii).ZLim = Z([1 end]);
    ax(ii).XTick = xStations(1):2*L:xStations(end);
    ax(ii).XTickLabel = fix([xStations(1):2*L:xStations(end)]); %#ok<*NBRAK>
    ax(ii).YTick = -D:0.5*D:D;
    ax(ii).YTickLabel = {'-D','-0.5D','0','0.5D','D'};
    ax(ii).ZTick = [Z(1) 0 Z(end)];
    ax(ii).ZTickLabel = [Z(1) 0 Z(end)];
    ax(ii).FontSize = 20;
    ax(ii).XLabel.String = '$x$';
    ax(ii).YLabel.String = '$y$';
    ax(ii).ZLabel.String = '$z$';
end

for tt = 1:length(steps)
    clc
    disp(strcat('plot', num2str(tt), 'from', num2str(steps(end)-steps(1))));
    if tt == 1       
        pWall4 = patch(ax(1),isosurface(mx,my,mz,wall,0)); %descomentar qndo for rodar full
        set(pWall4,'FaceColor',[1 1 1]*0,'EdgeColor','none','facealpha',0.4); %descomentar qndo for rodar full
    else
        delete(p32);%descomentar qndo for rodar full
        delete(p42);%descomentar qndo for rodar full
        delete(h3);%descomentar qndo for rodar full
    end
    varAux = squeeze(Vortk(tt,:,:,:));
    varAux = permute(varAux,[3 2 1]);
    p32 = patch(ax(1),isosurface(mx,my,mz,varAux,-iso_value3));
    set(p32,'FaceColor',linColV(1,:),'EdgeColor','none','facealpha',0.8);
    p42 = patch(ax(1),isosurface(mx,my,mz,varAux, iso_value4));
    set(p42,'FaceColor',linColV(2,:),'EdgeColor','none','facealpha',0.8);
    daspect(ax(1),[1,0.7,0.7])
    h3 = camlight(ax(1));
    lightangle(h3,-235,-60);
    lighting(ax(1),'gouraud');
    view(ax(1),[-130 50])
    if  tt ==1
        camroll(ax(1),235);
    end
    pause(0.5);
    %print(['/home/felipe/autolst/m05-FINAL/figs/centrifugal_band/Vortkstep_',num2str(steps(tt),'%04.0f'),'.png'],'-dpng');
    print(['/home/felipe/autolst/m05-FINAL/figs/rossiter_band/Vortkstep_',num2str(steps(tt),'%04.0f'),'.png'],'-dpng');
end
delete(gcp('nocreate'));
function [Vorti,Vortj,Vortk,Vort] = vorticidade(U,V,W)

[Vorti,Vortj,Vortk] = curl(U,V,W);
Vort = sqrt(Vorti.*Vorti + Vortj.*Vortj + Vortk.*Vortk);

end