%clear,clc

% set(groot,'defaultFigureColor',[1 1 1]);
set(groot,'defaultFigureColor','none');
set(groot,'defaultTextinterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% cd 'E:\DNS\new\m05-FINAL';
% cd 'E:\DNS\mach02';
cd 'B:\L12_5-D12_5final';
% cd 'B:\L20-D3r2';
% cd 'E:\DNS\m09final'
if ~exist('figs','dir')
    mkdir('figs');
end
load mesh.mat;
% xEnd = 500;
xEnd = 700;
domain.zf = Z(end);
domain.zi = Z(1);
% casePath = 'E:\DNS\new\m05-FINAL';
casePath = 'B:\L12_5-D12_5final';
% casePath =  'E:\DNS\m09final';
%  casePath ='B:\L20-D3r2';
% casePath = 'E:\DNS\mach02';
D = -flowType.cav{1,1}.y(1);
axLim = [(flowType.cav{1,1}.x(1)-10) (flowType.cav{1,1}.x(2)+(xEnd-flowType.cav{1,1}.x(2))/2), [flowType.cav{1,1}.y(1) -1.5*(flowType.cav{1,1}.y(1))], [-1 1]*domain.zf];
% axLim = [(flowType.cav{1,1}.x(1)-10) (flowType.cav{1,1}.x(2)+2*D), [flowType.cav{1,1}.y(1) -1.1*(flowType.cav{1,1}.y(1))], [-1 1]*domain.zf];

% steps = 100:5:2000;
% steps = 290:1:300;
steps = 300:1:400;
% steps = 192:1:292;
% steps = 50 :1:102;
linColV = lines(10);

[x,y,z,t,varOut,wall] = loadVar(casePath,steps,axLim);


[mx,my,mz] = meshgrid(x,y,z);

mx = permute(mx,[3 1 2]);
my = permute(my,[3 1 2]);
mz = permute(mz,[3 1 2]);
wall = permute(wall,[3 2 1]);
wall(find(my==min(y))) = 1;




% varPlot3 = varOut.L2;
varPlot4 = varOut.Vortk;

% iso_value3 = 0.015;
 iso_value3 = 0.005;
iso_value4 = 0.015;

figure('units','normalized','outerposition',[0 0 1 1]); clf; 
ax(1) = gca; grid on; box on


% ax(1).Title.String = '$\lambda_2$';
% ax(1).Title.String = '$Vortk$';
% ax(1).Title.Position(2) = 1.05;
for ii = 1:1
    
ax(ii).BoxStyle = 'full';
ax(ii).XLim = x([1 end]);
ax(ii).YLim = y([1 end]);
ax(ii).ZLim = z([1 end]);
ax(ii).XTick = x(1):2*L:x(end);
ax(ii).XTickLabel = fix([x(1):2*L:x(end)]);
ax(ii).YTick = -D:0.5*D:D;
ax(ii).YTickLabel = {'-D','0.5D','0','0.5D','D'};
% ax(ii).YTick = -D:D:2*D;
% ax(ii).YTickLabel = {'-D','0','D','2D'};
ax(ii).ZTick = [z(1) 0 z(end)];
ax(ii).ZTickLabel = [z(1) 0 z(end)];
ax(ii).FontSize = 20;
ax(ii).XLabel.String = '$x$';
ax(ii).YLabel.String = '$y$';
ax(ii).ZLabel.String = '$z$';
end


for tt = 1:length(steps)
    clc
    disp(strcat('plot', num2str(tt), 'from', num2str(steps(end)-steps(1))));
    if tt == 1
%         pWall3 = patch(ax(1),isosurface(mx,my,mz,wall,0));
        pWall4 = patch(ax(1),isosurface(mx,my,mz,wall,0));
%         set(pWall3,'FaceColor',[1 1 1]*0,'EdgeColor','none','facealpha',0.3);
        set(pWall4,'FaceColor',[1 1 1]*0,'EdgeColor','none','facealpha',0.4);
    else        
%         delete(p31);
%         delete(p41);
        delete(p32);
        delete(p42);
        delete(h3);
%         delete(h4);
    end
    
       
    varAux = varPlot4(:,:,:,tt);
    varAux = permute(varAux,[3 2 1]);
    p32 = patch(ax(1),isosurface(mx,my,mz,varAux,-iso_value3));
    set(p32,'FaceColor',linColV(1,:),'EdgeColor','none','facealpha',0.8);
    p42 = patch(ax(1),isosurface(mx,my,mz,varAux, iso_value4));
    set(p42,'FaceColor',linColV(2,:),'EdgeColor','none','facealpha',0.8);
    

    
    daspect(ax(1),[1,0.7,0.7])
        
    h3 = camlight(ax(1));
    lightangle(h3,-235,-60);
%     lightangle(h4,-160,-20);
    lighting(ax(1),'gouraud');
    
    
    view(ax(1),[-130 50])
        if  tt ==1
        camroll(ax(1),235);       
    end
%     ax(1).Position = [0.05 0.05 0.4 1];
        
    pause(0.5);
    print(['./figs/Vortkstep_',num2str(steps(tt),'%04.0f'),'.png'],'-dpng');
end

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

% L2 = zeros(length(x),length(y),length(z),length(steps));
% Q = zeros(length(x),length(y),length(z),length(steps));
% Dilatation = zeros(length(x),length(y),length(z),length(steps));
Vortk = zeros(length(x),length(y),length(z),length(steps));
for iStep = 1:length(steps)
    flow = matfile(sprintf('%s/flow_%010.0f.mat',casePath,steps(iStep)));
    %[nx,ny,nz] = size(flow,'L2');
    %[nx,ny,nz] = size(flow,'Q');
%     [nx,ny,nz] = size(flow,'Dilatation');
    [nx,ny,nz] = size(flow,'Vortk');
    
%     L2(:,:,:,iStep) = flow.L2(indX,indY,indZ);
%     Q(:,:,:,iStep) = flow.Q(indX,indY,indZ);
%     Dilatation(:,:,:,iStep) = flow.Dilatation(indX,indY,indZ);
    Vortk(:,:,:,iStep) = flow.Vortk(indX,indY,indZ);
    t(iStep) = flow.t;
end
% varOut.L2 = L2;
% varOut.Q = Q;
% varOut.Dilatation = Dilatation;
varOut.Vortk = Vortk;

fprintf('Finished Load \n\n')
end